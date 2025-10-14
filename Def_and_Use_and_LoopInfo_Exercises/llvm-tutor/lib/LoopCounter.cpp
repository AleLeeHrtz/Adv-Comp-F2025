#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

struct LoopCounter : public PassInfoMixin<LoopCounter> {
  
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    LoopInfo &LI = FAM.getResult<LoopAnalysis>(F);
    
    llvm::errs() << "LLVM-TUTOR: Loop Counter for: " << F.getName() << "\n";
    
    unsigned TotalLoops = 0;
    unsigned InnermostLoops = 0;
    unsigned NestedLoops = 0;
    
    for (Loop *L : LI) {
      TotalLoops++;
      
      if (L->isInnermost()) {
        InnermostLoops++;
        llvm::errs() << "  Innermost loop at depth: " << L->getLoopDepth() << "\n";
      } else {
        NestedLoops++;
        llvm::errs() << "  Nested loop at depth: " << L->getLoopDepth() 
                     << " with " << L->getSubLoops().size() << " subloop(s)\n";
      }
    }
    
    llvm::errs() << "Total loops:     " << TotalLoops << "\n";
    llvm::errs() << "Innermost loops: " << InnermostLoops << "\n";
    llvm::errs() << "Nested loops:    " << NestedLoops << "\n";
    
    return PreservedAnalyses::all();
  }
  
  static bool isRequired() { return true; }
};

} 

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return {
    LLVM_PLUGIN_API_VERSION, "LoopCounter", LLVM_VERSION_STRING,
    [](PassBuilder &PB) {
      PB.registerPipelineParsingCallback(
        [](StringRef Name, FunctionPassManager &FPM,
           ArrayRef<PassBuilder::PipelineElement>) {
          if (Name == "loop-counter") {
            FPM.addPass(LoopCounter());
            return true;
          }
          return false;
        }
      );
    }
  };
}
