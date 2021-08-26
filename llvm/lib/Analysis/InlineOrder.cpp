#include "llvm/Analysis/InlineOrder.h"
#include "llvm/Analysis/AssumptionCache.h"
#include "llvm/Analysis/BlockFrequencyInfo.h"
#include "llvm/Analysis/GlobalsModRef.h"
#include "llvm/Analysis/InlineAdvisor.h"
#include "llvm/Analysis/InlineCost.h"
#include "llvm/Analysis/OptimizationRemarkEmitter.h"
#include "llvm/Analysis/ProfileSummaryInfo.h"
#include "llvm/Analysis/TargetLibraryInfo.h"
#include "llvm/Analysis/TargetTransformInfo.h"

using namespace llvm;

#define DEBUG_TYPE "inline-order"

llvm::InlineCost static getInlineCostWrapper(CallBase &CB,
                                             FunctionAnalysisManager &FAM,
                                             const InlineParams &Params) {
  Function &Caller = *CB.getCaller();
  ProfileSummaryInfo *PSI =
      FAM.getResult<ModuleAnalysisManagerFunctionProxy>(Caller)
          .getCachedResult<ProfileSummaryAnalysis>(
              *CB.getParent()->getParent()->getParent());

  auto &ORE = FAM.getResult<OptimizationRemarkEmitterAnalysis>(Caller);
  auto GetAssumptionCache = [&](Function &F) -> AssumptionCache & {
    return FAM.getResult<AssumptionAnalysis>(F);
  };
  auto GetBFI = [&](Function &F) -> BlockFrequencyInfo & {
    return FAM.getResult<BlockFrequencyAnalysis>(F);
  };
  auto GetTLI = [&](Function &F) -> const TargetLibraryInfo & {
    return FAM.getResult<TargetLibraryAnalysis>(F);
  };

  Function &Callee = *CB.getCalledFunction();
  auto &CalleeTTI = FAM.getResult<TargetIRAnalysis>(Callee);
  bool RemarksEnabled =
      Callee.getContext().getDiagHandlerPtr()->isMissedOptRemarkEnabled(
          DEBUG_TYPE);
  return getInlineCost(CB, Params, CalleeTTI, GetAssumptionCache, GetTLI,
                       GetBFI, PSI, RemarksEnabled ? &ORE : nullptr);
}

std::unique_ptr<InlineOrder<std::pair<CallBase *, int>>>
llvm::getInlineOrder(InlinePriorityMode UseInlinePriority,
                     FunctionAnalysisManager &FAM, const InlineParams &Params) {
  switch (UseInlinePriority) {
  case InlinePriorityMode::NoPriority:
    return std::make_unique<DefaultInlineOrder<std::pair<CallBase *, int>>>();
  case InlinePriorityMode::Size:
    LLVM_DEBUG(dbgs() << "    Current used priority: Size priority ---- \n");
    return std::make_unique<PriorityInlineOrder<InlineSizePriority>>();
  case InlinePriorityMode::Cost:
    LLVM_DEBUG(dbgs() << "    Current used priority: Cost priority ---- \n");
    return std::make_unique<PriorityInlineOrder<InlineCostPriority>>(
        [&](CallBase *CB) -> InlineCostPriority {
          auto IC = getInlineCostWrapper(*CB, FAM, Params);
          int cost = 0;
          if (IC.isVariable())
            cost = IC.getCost();
          else
            cost = IC.isNever() ? INT_MAX : INT_MIN;
          return InlineCostPriority(cost);
        });
  case InlinePriorityMode::OptRatio:
    LLVM_DEBUG(
        dbgs() << "    Current used priority: cost-benefit priority ---- \n");
    return std::make_unique<PriorityInlineOrder<CostBenefitPriority>>(
        [&](CallBase *CB) -> CostBenefitPriority {
          auto IC = getInlineCostWrapper(*CB, FAM, Params);
          auto CostBenefit = IC.getCostBenefit().getValueOr(
              CostBenefitPair(APInt(128, 1), APInt(128, 0)));
          return CostBenefitPriority(CostBenefit);
        });
  default:
    break;
  }
  return nullptr;
}