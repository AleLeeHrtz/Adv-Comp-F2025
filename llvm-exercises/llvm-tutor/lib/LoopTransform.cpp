#include "llvm/Analysis/LoopInfo.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

struct LoopTransform : public PassInfoMixin<LoopTransform> {
  
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    LoopInfo &LI = FAM.getResult<LoopAnalysis>(F);
    
    bool Changed = false;
    
    llvm::errs() << "LLVM-TUTOR: Loop Transform for: " << F.getName() << "\n";
    
    for (Loop *L : LI) {
      if (!L->isInnermost())
        continue;
        
      BasicBlock *Header = L->getHeader();
      if (!Header) {
        llvm::errs() << "  Loop has no header, skipping\n";
        continue;
      }
      
      llvm::errs() << "  Transforming loop at depth " << L->getLoopDepth() << "\n";
      
      Instruction *FirstInst = &*(Header->getFirstInsertionPt());
      IRBuilder<> Builder(FirstInst);
      
      Value *Zero = Builder.getInt32(0);
      Value *One = Builder.getInt32(1);
      Value *Counter = Builder.CreateAdd(Zero, One, "loop_counter");
      
      llvm::errs() << "    -> Added counter instruction to loop\n";
      
      Changed = true;
    }
    
    if (!Changed) {
      llvm::errs() << "  No innermost loops found to transform\n";
    }
    
    
    return Changed ? PreservedAnalyses::none() : PreservedAnalyses::all();
  }
  
  static bool isRequired() { return true; }
};

} // anonymous namespace

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return {
    LLVM_PLUGIN_API_VERSION, "LoopTransform", LLVM_VERSION_STRING,
    [](PassBuilder &PB) {
      PB.registerPipelineParsingCallback(
        [](StringRef Name, FunctionPassManager &FPM,
           ArrayRef<PassBuilder::PipelineElement>) {
          if (Name == "loop-transform") {
            FPM.addPass(LoopTransform());
            return true;
          }
          return false;
        }
      );
    }
  };
}
