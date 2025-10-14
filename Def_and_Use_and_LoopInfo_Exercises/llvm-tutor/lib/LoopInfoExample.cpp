// LoopInfoExample.cpp extended
#include "llvm/IR/Function.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Support/raw_ostream.h"
using namespace llvm;

namespace {

// Helper function to print subloops recursively with depth
void printSubLoopsRecursive(Loop *L, unsigned Depth) {
  std::string Indent(Depth * 2, ' ');
  
  for (Loop *SubL : L->getSubLoops()) {
    errs() << Indent << "Subloop at depth " << Depth << " with header: ";
    SubL->getHeader()->printAsOperand(errs(), false);
    errs() << "\n";
    
    // Print preheader for subloop
    if (BasicBlock *Preheader = SubL->getLoopPreheader()) {
      errs() << Indent << "  Preheader: ";
      Preheader->printAsOperand(errs(), false);
      errs() << "\n";
    } else {
      errs() << Indent << "  Preheader: None\n";
    }
    
    // Print latch for subloop
    if (BasicBlock *Latch = SubL->getLoopLatch()) {
      errs() << Indent << "  Latch: ";
      Latch->printAsOperand(errs(), false);
      errs() << "\n";
    } else {
      errs() << Indent << "  Latch: None (multiple latches)\n";
    }
    
    // Recursively print nested subloops
    printSubLoopsRecursive(SubL, Depth + 1);
  }
}

struct LoopInfoExample : public PassInfoMixin<LoopInfoExample> {
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
    errs() << "========================================\n";
    errs() << "Analyzing function: " << F.getName() << "\n";
    errs() << "========================================\n";
    
    // Get LoopInfo for this function
    LoopInfo &LI = AM.getResult<LoopAnalysis>(F);
    
    if (LI.empty()) {
      errs() << "  No loops found in this function.\n\n";
      return PreservedAnalyses::all();
    }
    
    for (Loop *L : LI) {
      errs() << "\n[TOP-LEVEL LOOP]\n";
      errs() << "  Header: ";
      L->getHeader()->printAsOperand(errs(), false);
      errs() << "\n";
      
      // Print Preheader and Latch
      errs() << "\n  --- Loop Structure ---\n";
      if (BasicBlock *Preheader = L->getLoopPreheader()) {
        errs() << "  Preheader: ";
        Preheader->printAsOperand(errs(), false);
        errs() << "\n";
      } else {
        errs() << "  Preheader: None\n";
      }
      
      if (BasicBlock *Latch = L->getLoopLatch()) {
        errs() << "  Latch: ";
        Latch->printAsOperand(errs(), false);
        errs() << "\n";
      } else {
        errs() << "  Latch: None (multiple latches)\n";
      }
      
      // Additional loop information
      errs() << "\n  --- Additional Information ---\n";
      
      // Loop depth
      errs() << "  Loop Depth: " << L->getLoopDepth() << "\n";
      
      // Number of blocks in the loop
      errs() << "  Number of blocks: " << L->getNumBlocks() << "\n";
      
      // Exit blocks
      SmallVector<BasicBlock *, 4> ExitBlocks;
      L->getExitBlocks(ExitBlocks);
      errs() << "  Number of exit blocks: " << ExitBlocks.size() << "\n";
      if (!ExitBlocks.empty()) {
        errs() << "  Exit blocks: ";
        for (unsigned i = 0; i < ExitBlocks.size(); ++i) {
          if (i > 0) errs() << ", ";
          ExitBlocks[i]->printAsOperand(errs(), false);
        }
        errs() << "\n";
      }
      
      // General Checks
      
      // Exiting blocks
      SmallVector<BasicBlock *, 4> ExitingBlocks;
      L->getExitingBlocks(ExitingBlocks);
      errs() << "  Number of exiting blocks: " << ExitingBlocks.size() << "\n";
      
      // Check if loop is in simplified form
      errs() << "  Is in simplified form: " 
             << (L->isLoopSimplifyForm() ? "Yes" : "No") << "\n";
      
      // Check if loop is rotated
      errs() << "  Is rotated: " 
             << (L->isRotatedForm() ? "Yes" : "No") << "\n";
      
      // Print subloops recursively with depth
      if (!L->getSubLoops().empty()) {
        errs() << "\n  --- Nested Subloops ---\n";
        printSubLoopsRecursive(L, 1);
      } else {
        errs() << "\n  --- Nested Subloops ---\n";
        errs() << "  No nested subloops.\n";
      }
      
      errs() << "\n";
    }
    
    errs() << "========================================\n\n";
    return PreservedAnalyses::all();
  }
};

} // namespace

// Register pass plugin
llvm::PassPluginLibraryInfo getLoopInfoExamplePluginInfo() {
  return {
      LLVM_PLUGIN_API_VERSION, "loop-info-example", LLVM_VERSION_STRING,
      [](PassBuilder &PB) {
        PB.registerPipelineParsingCallback(
            [](StringRef Name, FunctionPassManager &FPM,
               ArrayRef<PassBuilder::PipelineElement>) {
              if (Name == "loop-info-example") {
                FPM.addPass(LoopInfoExample());
                return true;
              }
              return false;
            });
      }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getLoopInfoExamplePluginInfo();
}
