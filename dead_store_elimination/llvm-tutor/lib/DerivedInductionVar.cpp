/* DerivedInductionVar.cpp 
 *
 * This pass detects derived induction variables using ScalarEvolution.
 *
 * Compatible with New Pass Manager
*/

#include "llvm/IR/PassManager.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/ScalarEvolution.h"
#include "llvm/Analysis/ScalarEvolutionExpressions.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

// lib required:
//#include "llvm/Analysis/ScalarEvolutionExpander.h"
// but on my machine is on:
#include "llvm/Transforms/Utils/ScalarEvolutionExpander.h"// NOTE: PLEASE UNCOMMENT UPPER LINE AND COMMENT THIS ONE IN THE CASE OF TESTING
#include "llvm/IR/IRBuilder.h"

using namespace llvm;

namespace {

	// returning an affine expression
static const SCEVAddRecExpr *getAffineAddRecInLoop(const SCEV *S, Loop *L) {
  if (auto *AR = dyn_cast<SCEVAddRecExpr>(S)) {
    if (AR->getLoop() == L && AR->isAffine())
      return AR;
  }
  return nullptr;
}

// just detecting minimal steps, if not found just pick any affine
static PHINode *pickBaseIV(Loop *L, ScalarEvolution &SE) {
  BasicBlock *Header = L->getHeader();
  if (!Header)
    return nullptr;

  PHINode *Fallback = nullptr;

  for (PHINode &PN : Header->phis()) {
    if (!PN.getType()->isIntegerTy())
      continue;
    const SCEV *S = SE.getSCEV(&PN);
    if (auto *AR = getAffineAddRecInLoop(S, L)) {
      const SCEV *Step = AR->getStepRecurrence(SE);
      if (const SCEVConstant *C = dyn_cast<SCEVConstant>(Step)) {
        auto V = C->getAPInt().getSExtValue();
        if (V == 1 || V == -1)
          return &PN; 
      }
      if (!Fallback)
        Fallback = &PN;
    }
  }
  return Fallback;
}

// detect IVS and elim. derived ones
static bool processOneLoop(Loop *L, Function &F, ScalarEvolution &SE) {
  bool Changed = false;
  BasicBlock *Header = L->getHeader();
  if (!Header)
    return false;

  errs() << "Analyzing loop (header=" << Header->getName()
         << ") in function " << F.getName() << ":\n";

  PHINode *BaseIV = pickBaseIV(L, SE);

  Instruction *InsertPt = Header->getFirstNonPHI();
  (void)InsertPt; // avoid unused warnings
  SCEVExpander Exp(SE, F.getParent()->getDataLayout(), "ive");

  SmallVector<PHINode *, 8> DerivedIVs;

  // Detect affine AddRec IVs
  for (PHINode &PN : Header->phis()) {
    if (!PN.getType()->isIntegerTy())
      continue;
    const SCEV *S = SE.getSCEV(&PN);
    if (auto *AR = getAffineAddRecInLoop(S, L)) {
      const SCEV *Step = AR->getStepRecurrence(SE);
      const SCEV *Start = AR->getStart();

      errs() << "  IV: " << PN.getName() << " = {" << *Start << ",+," << *Step
             << "}<" << Header->getName() << ">\n";

      if (&PN != BaseIV)
        DerivedIVs.push_back(&PN);
    }
  }

  // Elimination step
  for (PHINode *PN : DerivedIVs) {
    const SCEV *S = SE.getSCEV(PN);
    bool LocalChanged = false;

    for (auto UI = PN->use_begin(), UE = PN->use_end(); UI != UE; ) {
      Use &U = *UI++;
      User *Usr = U.getUser();

      if (auto *I = dyn_cast<Instruction>(Usr)) {
        Instruction *IP = I;

        if (auto *PhiU = dyn_cast<PHINode>(I)) {
          unsigned OpNo = U.getOperandNo();
          BasicBlock *IncomingBB = PhiU->getIncomingBlock(OpNo);
          IP = IncomingBB->getTerminator();
        }

        Value *Mat = Exp.expandCodeFor(S, PN->getType(), IP);

        // I understood that sometimes LLVM makes the decission to not select PN, then doing a linear fallback
        if (Mat == PN) {
          const SCEVAddRecExpr *BaseAR = BaseIV ? getAffineAddRecInLoop(SE.getSCEV(BaseIV), L) : nullptr;
          const SCEVAddRecExpr *DAR    = getAffineAddRecInLoop(S, L);

          if (BaseAR && DAR) {
            auto *BaseStartC = dyn_cast<SCEVConstant>(BaseAR->getStart());
            auto *BaseStepC  = dyn_cast<SCEVConstant>(BaseAR->getStepRecurrence(SE));
            auto *DStartC    = dyn_cast<SCEVConstant>(DAR->getStart());
            auto *DStepC     = dyn_cast<SCEVConstant>(DAR->getStepRecurrence(SE));

            if (BaseStartC && BaseStepC && DStartC && DStepC) {
              auto B1 = BaseStepC->getAPInt();
              if (B1 == 1 || B1 == -1) {
                IRBuilder<> B(IP);
                Value *iVal  = BaseIV;
                Value *B0Val = ConstantInt::get(PN->getType(), BaseStartC->getAPInt());
                Value *D0Val = ConstantInt::get(PN->getType(), DStartC->getAPInt());
                Value *D1Val = ConstantInt::get(PN->getType(), DStepC->getAPInt());

                Value *iMinusB0 = B.CreateSub(iVal, B0Val, "iv_diff");
                Value *k = (B1 == 1) ? iMinusB0 : B.CreateNeg(iMinusB0, "k");
                Mat = B.CreateAdd(D0Val, B.CreateMul(D1Val, k, "d_step_mul"),
                                  "derived_repl");
              }
            }
          }
        }

        // Apply the replacement only if it actually changed.
        if (Mat != PN) {
          if (auto *PhiU = dyn_cast<PHINode>(I)) {
            unsigned OpNo = U.getOperandNo();
            PhiU->setIncomingValue(OpNo, Mat);
          } else {
            U.set(Mat);
          }
          LocalChanged = true;
        }

        continue;
      }

    }

    if (LocalChanged && PN->use_empty()) {
      PN->eraseFromParent();
      Changed = true;
      errs() << "  Eliminated derived IV by per-use expansion.\n";
    }
  }

  return Changed;
}

class DerivedInductionVar : public PassInfoMixin<DerivedInductionVar> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &AM) {
    auto &LI = AM.getResult<LoopAnalysis>(F);
    auto &SE = AM.getResult<ScalarEvolutionAnalysis>(F);

    bool Changed = false;
    
    SmallVector<Loop *, 8> Work;
    for (Loop *Top : LI)
      Work.push_back(Top);

    while (!Work.empty()) {
      Loop *L = Work.pop_back_val();
      for (Loop *Sub : *L)
        Work.push_back(Sub);
      Changed |= processOneLoop(L, F, SE);
    }

    return Changed ? PreservedAnalyses::none() : PreservedAnalyses::all();
  }
};

} // namespace

// Register the pass
llvm::PassPluginLibraryInfo getDerivedInductionVarPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "DerivedInductionVar", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "derived-iv") {
                    FPM.addPass(DerivedInductionVar());
                    return true;
                  }
                  return false;
                });
          }};
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getDerivedInductionVarPluginInfo();
}

