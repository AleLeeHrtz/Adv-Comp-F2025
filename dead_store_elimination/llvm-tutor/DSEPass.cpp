#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Analysis/MemorySSA.h"
#include "llvm/Analysis/MemorySSAUpdater.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/MemoryLocation.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Utils/Local.h"
#include <vector>

using namespace llvm;

struct DSEPass : PassInfoMixin<DSEPass> {
  
  // Check if an instruction is a simple store (i.e., not volatile, not atomic)
  bool isSimpleStore(Instruction *I) {
    if (auto *SI = dyn_cast<StoreInst>(I)) {
      return SI->isSimple();  // Not volatile, not atomic
    }
    return false;
  }
  
  // Check if two stores write to the same location
  bool isSameLocation(StoreInst *S1, StoreInst *S2) {
    // Simple case: same pointer operand
    return S1->getPointerOperand() == S2->getPointerOperand();
  }
  
  // Check if a MemoryDef is killed by another store before any use
  bool isKilledByLaterStore(MemoryDef *MD, MemorySSA &MSSA) {
    auto *SI = dyn_cast<StoreInst>(MD->getMemoryInst());
    if (!SI || !SI->isSimple()) {
      return false;
    }
    
    // Walk through all users of this MemoryDef
    for (auto *User : MD->users()) {
      // If theres a MemoryUse the value might be read
      if (isa<MemoryUse>(User)) {
        return false;  // There's a load that reads this value
      }
      
      // If theres a MemoryPhi, it might be used in another path
      if (isa<MemoryPhi>(User)) {
        return false;  // Conservative: might be used through phi
      }
      
      // Check if this is killed by another MemoryDef (store)
      if (auto *KillingDef = dyn_cast<MemoryDef>(User)) {
        auto *KillingSI = dyn_cast<StoreInst>(KillingDef->getMemoryInst());
        if (KillingSI && KillingSI->isSimple()) {
          // Check if they write to the same location
          if (isSameLocation(SI, KillingSI)) {
            // This store is overwritten before any use!
            errs() << "      Found killing store: ";
            KillingSI->print(errs());
            errs() << "\n";
            return true;
          }
        }
      }
    }
    
    return false;
  }
  
  // Check if store is never read 
  bool isDeadAtEnd(MemoryDef *MD) {
    // If this MemoryDef has no users at all then its dead
    return MD->user_empty();
  }
  
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
    auto &MSSAResult = AM.getResult<MemorySSAAnalysis>(F);
    auto &MSSA = MSSAResult.getMSSA();
    auto &AA = AM.getResult<AAManager>(F);
    
    // Create MemorySSA updater for proper removal
    MemorySSAUpdater MSSAUpdater(&MSSA);
    
    errs() << "\n=== Running DSE on function: " << F.getName() << " ===\n";
    
    bool Changed = false;
    std::vector<Instruction*> ToDelete;
    
    // Collect all stores (MemoryDefs) in the function
    for (auto &BB : F) {
      for (auto &I : BB) {
        // Only consider simple stores
        if (!isSimpleStore(&I)) {
          continue;
        }
        
        auto *MD = dyn_cast_or_null<MemoryDef>(MSSA.getMemoryAccess(&I));
        if (!MD) {
          continue;
        }
        
        errs() << "  Analyzing store: ";
        I.print(errs());
        errs() << "\n";
        
        bool isDead = false;
        std::string reason;
        
	// Here I implemented two main approaches
	
        // 1.- Store is never read 
        if (isDeadAtEnd(MD)) {
          isDead = true;
          reason = "never read (no users)";
        }
        // 2.- Store is killed by a later store to same location
        else if (isKilledByLaterStore(MD, MSSA)) {
          isDead = true;
          reason = "overwritten by later store to same location";
        }
        
        if (isDead) {
          errs() << "    -> DEAD STORE (" << reason << ")\n";
          ToDelete.push_back(&I);
          Changed = true;
        } else {
          errs() << "    -> LIVE (has uses or not provably dead)\n";
        }
      }
    }
    
    // Delete dead stores and update MemorySSA
    if (!ToDelete.empty()) {
      errs() << "\n  Eliminating " << ToDelete.size() << " dead store(s)\n";
      
      for (auto *I : ToDelete) {
        errs() << "    Deleting: ";
        I->print(errs());
        errs() << "\n";
        
        // Remove from MemorySSA using updater
        auto *MA = MSSA.getMemoryAccess(I);
        if (MA) {
          MSSAUpdater.removeMemoryAccess(MA);
        }
        
        // Remove instruction
        I->eraseFromParent();
      }
    } else {
      errs() << "\n  No dead stores found\n";
    }
    
    errs() << "=== DSE Complete ===\n\n";
    
    if (Changed) {
      PreservedAnalyses PA;
      PA.preserve<MemorySSAAnalysis>();
      return PA;
    }
    
    return PreservedAnalyses::all();
  }
};

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "DSEPass", "v1.0",
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "dse") {
                    FPM.addPass(DSEPass());
                    return true;
                  }
                  return false;
                });
          }};
}

