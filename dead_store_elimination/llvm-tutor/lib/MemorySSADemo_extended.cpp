#include "llvm/IR/Function.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Analysis/MemorySSA.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/FileSystem.h"
#include <system_error>

using namespace llvm;

struct MemorySSADemoPass : PassInfoMixin<MemorySSADemoPass> {
  
  // Function to generate DOT graph for MemorySSA
  void generateDotGraph(MemorySSA &MSSA, Function &F, const std::string &filename) {
    std::error_code EC;
    raw_fd_ostream File(filename, EC, sys::fs::OF_None);
    
    if (EC) {
      errs() << "Error opening file " << filename << ": " << EC.message() << "\n";
      return;
    }
    
    File << "digraph \"MemorySSA_" << F.getName() << "\" {\n";
    File << "  label=\"MemorySSA for function: " << F.getName() << "\";\n";
    File << "  rankdir=TB;\n";
    File << "  node [shape=box, fontname=\"Courier\"];\n\n";
    
    // Map to store node IDs for each MemoryAccess
    DenseMap<const MemoryAccess*, unsigned> NodeIDs;
    unsigned NodeCounter = 0;
    
    // First pass: assign IDs to all MemoryAccesses
    for (auto &BB : F) {
      // Handle MemoryPhi
      if (auto *MPhi = MSSA.getMemoryAccess(&BB)) {
        if (isa<MemoryPhi>(MPhi)) {
          NodeIDs[MPhi] = NodeCounter++;
        }
      }
      
      // Handle MemoryDef and MemoryUse
      for (auto &I : BB) {
        if (auto *MA = MSSA.getMemoryAccess(&I)) {
          NodeIDs[MA] = NodeCounter++;
        }
      }
    }
    
    // Add LiveOnEntry
    auto *LiveOnEntry = MSSA.getLiveOnEntryDef();
    NodeIDs[LiveOnEntry] = NodeCounter++;
    
    // Second pass: generate nodes and edges
    File << "  // LiveOnEntry\n";
    File << "  node" << NodeIDs[LiveOnEntry] 
         << " [label=\"LiveOnEntry\", style=filled, fillcolor=lightblue];\n\n";
    
    for (auto &BB : F) {
      File << "  // Basic Block: " << BB.getName() << "\n";
      
      // MemoryPhi nodes
      if (auto *MPhi = dyn_cast_or_null<MemoryPhi>(MSSA.getMemoryAccess(&BB))) {
        unsigned PhiID = NodeIDs[MPhi];
        
        std::string label = "MemoryPhi\\nBlock: ";
        label += BB.getName().str();
        
        File << "  node" << PhiID 
             << " [label=\"" << label << "\", style=filled, fillcolor=lightyellow];\n";
        
        // Draw edges from incoming values
        for (unsigned i = 0; i < MPhi->getNumIncomingValues(); ++i) {
          auto *IncomingAcc = MPhi->getIncomingValue(i);
          auto *Pred = MPhi->getIncomingBlock(i);
          
          if (NodeIDs.count(IncomingAcc)) {
            File << "  node" << NodeIDs[IncomingAcc] 
                 << " -> node" << PhiID 
                 << " [label=\"" << Pred->getName() << "\"];\n";
          }
        }
        File << "\n";
      }
      
      // MemoryDef and MemoryUse
      for (auto &I : BB) {
        if (auto *MA = MSSA.getMemoryAccess(&I)) {
          unsigned NodeID = NodeIDs[MA];
          
          std::string label;
          std::string color;
          
          if (auto *Def = dyn_cast<MemoryDef>(MA)) {
            label = "MemoryDef\\n";
            color = "lightgreen";
            
            // Add instruction info
            std::string InstStr;
            raw_string_ostream OS(InstStr);
            I.print(OS);
            OS.flush();
            
            // Truncate long instructions
            if (InstStr.length() > 50) {
              InstStr = InstStr.substr(0, 47) + "...";
            }
            
            // Escape special characters
            for (char &c : InstStr) {
              if (c == '"' || c == '\\' || c == '\n') c = ' ';
            }
            label += InstStr;
            
            File << "  node" << NodeID 
                 << " [label=\"" << label << "\", style=filled, fillcolor=" << color << "];\n";
            
            // Draw edge to defining access
            auto *DefiningAccess = Def->getDefiningAccess();
            if (NodeIDs.count(DefiningAccess)) {
              File << "  node" << NodeIDs[DefiningAccess] 
                   << " -> node" << NodeID << ";\n";
            }
            
          } else if (auto *Use = dyn_cast<MemoryUse>(MA)) {
            label = "MemoryUse\\n";
            color = "lightcoral";
            
            // Add instruction info
            std::string InstStr;
            raw_string_ostream OS(InstStr);
            I.print(OS);
            OS.flush();
            
            // Truncate long instructions
            if (InstStr.length() > 50) {
              InstStr = InstStr.substr(0, 47) + "...";
            }
            
            // Escape special characters
            for (char &c : InstStr) {
              if (c == '"' || c == '\\' || c == '\n') c = ' ';
            }
            label += InstStr;
            
            File << "  node" << NodeID 
                 << " [label=\"" << label << "\", style=filled, fillcolor=" << color << "];\n";
            
            // Draw edge to defining access
            auto *DefiningAccess = Use->getDefiningAccess();
            if (NodeIDs.count(DefiningAccess)) {
              File << "  node" << NodeIDs[DefiningAccess] 
                   << " -> node" << NodeID << " [style=dashed];\n";
            }
          }
        }
      }
      File << "\n";
    }
    
    File << "}\n";
    File.close();
    
    errs() << "MemorySSA graph written to: " << filename << "\n";
    errs() << "Convert to PDF with: dot -Tpdf " << filename << " -o " 
           << filename.substr(0, filename.length()-4) << ".pdf\n";
  }
  
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
    auto &MSSAResult = AM.getResult<MemorySSAAnalysis>(F);
    auto &MSSA = MSSAResult.getMSSA();
    
    errs() << "Analyzing function: " << F.getName() << "\n";
    
    // Generate DOT graph
    std::string dotFilename = F.getName().str() + "_memssa.dot";
    generateDotGraph(MSSA, F, dotFilename);
    
    // Original text output
    // Iterate over basic blocks to show all MemoryAccesses
    for (auto &BB : F) {
      errs() << "BasicBlock: " << BB.getName() << "\n";
      
      // MemoryPhi nodes are found at block entries
      if (auto *Phi = MSSA.getMemoryAccess(&BB)) {
        if (auto *MPhi = dyn_cast<MemoryPhi>(Phi)) {
          errs() << "  MemoryPhi for block " << BB.getName() << ":\n";
          for (unsigned i = 0; i < MPhi->getNumIncomingValues(); ++i) {
            auto *IncomingAcc = MPhi->getIncomingValue(i);
            auto *Pred = MPhi->getIncomingBlock(i);
            errs() << "    from " << Pred->getName() << ": ";
            IncomingAcc->print(errs());
            errs() << "\n";
          }
        }
      }
      
      // Iterate over instructions for MemoryDef/Use
      for (auto &I : BB) {
        if (auto *MA = MSSA.getMemoryAccess(&I)) {
          errs() << "  ";
          MA->print(errs());
          errs() << "\n";
        }
      }
    }
    
    return PreservedAnalyses::all();
  }
};

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "MemorySSADemoPass", "v0.9",
          [](PassBuilder &PB) {
            PB.registerAnalysisRegistrationCallback(
                [](FunctionAnalysisManager &FAM) {
                  FAM.registerPass([] { return MemorySSAAnalysis(); });
                });
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "memssa-demo") {
                    FPM.addPass(MemorySSADemoPass());
                    return true;
                  }
                  return false;
                });
          }};
}

