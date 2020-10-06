//===----------- BPFPreserveDIType.cpp - Preserve DebugInfo Types ---------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Preserve Debuginfo types encoded in __builtin_btf_type_id() metadata.
//
//===----------------------------------------------------------------------===//

#include "BPF.h"
#include "BPFCORE.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/User.h"
#include "llvm/IR/Value.h"
#include "llvm/Pass.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"

#define DEBUG_TYPE "bpf-preserve-di-type"

namespace llvm {
constexpr StringRef BPFCoreSharedInfo::TypeIdAttr;
} // namespace llvm

using namespace llvm;

namespace {

static bool BPFPreserveDITypeImpl(Function &F) {
  LLVM_DEBUG(dbgs() << "********** preserve debuginfo type **********\n");

  Module *M = F.getParent();

  // Bail out if no debug info.
  if (M->debug_compile_units().empty())
    return false;

  std::vector<CallInst *> PreserveDITypeCalls;

  for (auto &BB : F) {
    for (auto &I : BB) {
      auto *Call = dyn_cast<CallInst>(&I);
      if (!Call)
        continue;

      const auto *GV = dyn_cast<GlobalValue>(Call->getCalledOperand());
      if (!GV)
        continue;

      if (GV->getName().startswith("llvm.bpf.btf.type.id")) {
        if (!Call->getMetadata(LLVMContext::MD_preserve_access_index))
          report_fatal_error(
              "Missing metadata for llvm.bpf.btf.type.id intrinsic");
        PreserveDITypeCalls.push_back(Call);
      }
    }
  }

  if (PreserveDITypeCalls.empty())
    return false;

  std::string BaseName = "llvm.btf_type_id.";
  int Count = 0;
  for (auto Call : PreserveDITypeCalls) {
    const ConstantInt *Flag = dyn_cast<ConstantInt>(Call->getArgOperand(1));
    assert(Flag);
    uint64_t FlagValue = Flag->getValue().getZExtValue();

    if (FlagValue >= BPFCoreSharedInfo::MAX_BTF_TYPE_ID_FLAG)
      report_fatal_error("Incorrect flag for llvm.bpf.btf.type.id intrinsic");

    MDNode *MD = Call->getMetadata(LLVMContext::MD_preserve_access_index);

    uint32_t Reloc;
    if (FlagValue == BPFCoreSharedInfo::BTF_TYPE_ID_LOCAL_RELOC) {
      Reloc = BPFCoreSharedInfo::BTF_TYPE_ID_LOCAL;
    } else {
      Reloc = BPFCoreSharedInfo::BTF_TYPE_ID_REMOTE;
      DIType *Ty = cast<DIType>(MD);
      if (Ty->getName().empty())
        report_fatal_error("Empty type name for BTF_TYPE_ID_REMOTE reloc");
    }

    BasicBlock *BB = Call->getParent();
    IntegerType *VarType = Type::getInt32Ty(BB->getContext());
    std::string GVName = BaseName + std::to_string(Count) + "$" +
        std::to_string(Reloc);
    GlobalVariable *GV = new GlobalVariable(
        *M, VarType, false, GlobalVariable::ExternalLinkage, NULL, GVName);
    GV->addAttribute(BPFCoreSharedInfo::TypeIdAttr);
    GV->setMetadata(LLVMContext::MD_preserve_access_index, MD);

    // Load the global variable which represents the type info.
    auto *LDInst = new LoadInst(Type::getInt32Ty(BB->getContext()), GV, "",
                                Call);
    Instruction *PassThroughInst =
        BPFCoreSharedInfo::insertPassThrough(M, BB, LDInst, Call);
    Call->replaceAllUsesWith(PassThroughInst);
    Call->eraseFromParent();
    Count++;
  }

  return true;
}

class BPFPreserveDIType final : public FunctionPass {
  bool runOnFunction(Function &F) override;

public:
  static char ID;
  BPFPreserveDIType() : FunctionPass(ID) {}
};
} // End anonymous namespace

char BPFPreserveDIType::ID = 0;
INITIALIZE_PASS(BPFPreserveDIType, DEBUG_TYPE, "BPF Preserve Debuginfo Type",
                false, false)

FunctionPass *llvm::createBPFPreserveDIType() {
  return new BPFPreserveDIType();
}

bool BPFPreserveDIType::runOnFunction(Function &F) {
  return BPFPreserveDITypeImpl(F);
}

PreservedAnalyses BPFPreserveDITypePass::run(Function &F,
                                             FunctionAnalysisManager &AM) {
  return BPFPreserveDITypeImpl(F) ? PreservedAnalyses::none()
                                  : PreservedAnalyses::all();
}
