//===- NormalizeMemRefs.cpp -----------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file implements an interprocedural pass to normalize memrefs to have
// identity layout maps.
//
//===----------------------------------------------------------------------===//

#include "PassDetail.h"
#include "mlir/Dialect/Affine/IR/AffineOps.h"
#include "mlir/Transforms/Passes.h"
#include "mlir/Transforms/Utils.h"
#include "llvm/ADT/SmallSet.h"

#define DEBUG_TYPE "normalize-memrefs"

using namespace mlir;

namespace {

/// All memrefs passed across functions with non-trivial layout maps are
/// converted to ones with trivial identity layout ones.
/// If all the memref types/uses in a function are normalizable, we treat
/// such functions as normalizable. Also, if a normalizable function is known
/// to call a non-normalizable function, we treat that function as
/// non-normalizable as well. We assume external functions to be normalizable.
///
/// Input :-
/// #tile = affine_map<(i) -> (i floordiv 4, i mod 4)>
/// func @matmul(%A: memref<16xf64, #tile>, %B: index, %C: memref<16xf64>) ->
/// (memref<16xf64, #tile>) {
///   affine.for %arg3 = 0 to 16 {
///         %a = affine.load %A[%arg3] : memref<16xf64, #tile>
///         %p = mulf %a, %a : f64
///         affine.store %p, %A[%arg3] : memref<16xf64, #tile>
///   }
///   %c = alloc() : memref<16xf64, #tile>
///   %d = affine.load %c[0] : memref<16xf64, #tile>
///   return %A: memref<16xf64, #tile>
/// }
///
/// Output :-
///   func @matmul(%arg0: memref<4x4xf64>, %arg1: index, %arg2: memref<16xf64>)
///   -> memref<4x4xf64> {
///     affine.for %arg3 = 0 to 16 {
///       %2 = affine.load %arg0[%arg3 floordiv 4, %arg3 mod 4] :
///       memref<4x4xf64> %3 = mulf %2, %2 : f64 affine.store %3, %arg0[%arg3
///       floordiv 4, %arg3 mod 4] : memref<4x4xf64>
///     }
///     %0 = alloc() : memref<16xf64, #map0>
///     %1 = affine.load %0[0] : memref<16xf64, #map0>
///     return %arg0 : memref<4x4xf64>
///   }
///
struct NormalizeMemRefs : public NormalizeMemRefsBase<NormalizeMemRefs> {
  void runOnOperation() override;
  void normalizeFuncOpMemRefs(FuncOp funcOp, ModuleOp moduleOp);
  bool areMemRefsNormalizable(FuncOp funcOp);
  void updateFunctionSignature(FuncOp funcOp, ModuleOp moduleOp);
  void setCalleesAndCallersNonNormalizable(FuncOp funcOp, ModuleOp moduleOp,
                                           DenseSet<FuncOp> &normalizableFuncs);
};

} // end anonymous namespace

std::unique_ptr<OperationPass<ModuleOp>> mlir::createNormalizeMemRefsPass() {
  return std::make_unique<NormalizeMemRefs>();
}

void NormalizeMemRefs::runOnOperation() {
  ModuleOp moduleOp = getOperation();
  // We maintain all normalizable FuncOps in a DenseSet. It is initialized
  // with all the functions within a module and then functions which are not
  // normalizable are removed from this set.
  // TODO: Change this to work on FuncLikeOp once there is an operation
  // interface for it.
  DenseSet<FuncOp> normalizableFuncs;
  // Initialize `normalizableFuncs` with all the functions within a module.
  moduleOp.walk([&](FuncOp funcOp) { normalizableFuncs.insert(funcOp); });

  // Traverse through all the functions applying a filter which determines
  // whether that function is normalizable or not. All callers/callees of
  // a non-normalizable function will also become non-normalizable even if
  // they aren't passing any or specific non-normalizable memrefs. So,
  // functions which calls or get called by a non-normalizable becomes non-
  // normalizable functions themselves.
  moduleOp.walk([&](FuncOp funcOp) {
    if (normalizableFuncs.contains(funcOp)) {
      if (!areMemRefsNormalizable(funcOp)) {
        // Since this function is not normalizable, we set all the caller
        // functions and the callees of this function as not normalizable.
        // TODO: Drop this conservative assumption in the future.
        setCalleesAndCallersNonNormalizable(funcOp, moduleOp,
                                            normalizableFuncs);
      }
    }
  });

  // Those functions which can be normalized are subjected to normalization.
  for (FuncOp &funcOp : normalizableFuncs)
    normalizeFuncOpMemRefs(funcOp, moduleOp);
}

/// Return true if this operation dereferences one or more memref's.
/// TODO: Temporary utility, will be replaced when this is modeled through
/// side-effects/op traits.
static bool isMemRefDereferencingOp(Operation &op) {
  return isa<AffineReadOpInterface, AffineWriteOpInterface, AffineDmaStartOp,
             AffineDmaWaitOp>(op);
}

/// Check whether all the uses of oldMemRef are either dereferencing uses or the
/// op is of type : DeallocOp, CallOp or ReturnOp. Only if these constraints
/// are satisfied will the value become a candidate for replacement.
/// TODO: Extend this for DimOps.
static bool isMemRefNormalizable(Value::user_range opUsers) {
  if (llvm::any_of(opUsers, [](Operation *op) {
        if (isMemRefDereferencingOp(*op))
          return false;
        return !isa<DeallocOp, CallOp, ReturnOp>(*op);
      }))
    return false;
  return true;
}

/// Set all the calling functions and the callees of the function as not
/// normalizable.
void NormalizeMemRefs::setCalleesAndCallersNonNormalizable(
    FuncOp funcOp, ModuleOp moduleOp, DenseSet<FuncOp> &normalizableFuncs) {
  if (!normalizableFuncs.contains(funcOp))
    return;

  normalizableFuncs.erase(funcOp);
  // Caller of the function.
  Optional<SymbolTable::UseRange> symbolUses = funcOp.getSymbolUses(moduleOp);
  for (SymbolTable::SymbolUse symbolUse : *symbolUses) {
    // TODO: Extend this for ops that are FunctionLike. This would require
    // creating an OpInterface for FunctionLike ops.
    FuncOp parentFuncOp = symbolUse.getUser()->getParentOfType<FuncOp>();
    for (FuncOp &funcOp : normalizableFuncs) {
      if (parentFuncOp == funcOp) {
        setCalleesAndCallersNonNormalizable(funcOp, moduleOp,
                                            normalizableFuncs);
        break;
      }
    }
  }

  // Functions called by this function.
  funcOp.walk([&](CallOp callOp) {
    StringRef callee = callOp.getCallee();
    for (FuncOp &funcOp : normalizableFuncs) {
      // We compare FuncOp and callee's name.
      if (callee == funcOp.getName()) {
        setCalleesAndCallersNonNormalizable(funcOp, moduleOp,
                                            normalizableFuncs);
        break;
      }
    }
  });
}

/// Check whether all the uses of AllocOps, CallOps and function arguments of a
/// function are either of dereferencing type or are uses in: DeallocOp, CallOp
/// or ReturnOp. Only if these constraints are satisfied will the function
/// become a candidate for normalization. We follow a conservative approach here
/// wherein even if the non-normalizable memref is not a part of the function's
/// argument or return type, we still label the entire function as
/// non-normalizable. We assume external functions to be normalizable.
bool NormalizeMemRefs::areMemRefsNormalizable(FuncOp funcOp) {
  // We assume external functions to be normalizable.
  if (funcOp.isExternal())
    return true;

  if (funcOp
          .walk([&](AllocOp allocOp) -> WalkResult {
            Value oldMemRef = allocOp.getResult();
            if (!isMemRefNormalizable(oldMemRef.getUsers()))
              return WalkResult::interrupt();
            return WalkResult::advance();
          })
          .wasInterrupted())
    return false;

  if (funcOp
          .walk([&](CallOp callOp) -> WalkResult {
            for (unsigned resIndex :
                 llvm::seq<unsigned>(0, callOp.getNumResults())) {
              Value oldMemRef = callOp.getResult(resIndex);
              if (oldMemRef.getType().isa<MemRefType>())
                if (!isMemRefNormalizable(oldMemRef.getUsers()))
                  return WalkResult::interrupt();
            }
            return WalkResult::advance();
          })
          .wasInterrupted())
    return false;

  for (unsigned argIndex : llvm::seq<unsigned>(0, funcOp.getNumArguments())) {
    BlockArgument oldMemRef = funcOp.getArgument(argIndex);
    if (oldMemRef.getType().isa<MemRefType>())
      if (!isMemRefNormalizable(oldMemRef.getUsers()))
        return false;
  }

  return true;
}

/// Fetch the updated argument list and result of the function and update the
/// function signature. This updates the function's return type at the caller
/// site and in case the return type is a normalized memref then it updates
/// the calling function's signature.
/// TODO: An update to the calling function signature is required only if the
/// returned value is in turn used in ReturnOp of the calling function.
void NormalizeMemRefs::updateFunctionSignature(FuncOp funcOp,
                                               ModuleOp moduleOp) {
  FunctionType functionType = funcOp.getType();
  SmallVector<Type, 4> resultTypes;
  FunctionType newFuncType;
  resultTypes = llvm::to_vector<4>(functionType.getResults());

  // External function's signature was already updated in
  // 'normalizeFuncOpMemRefs()'.
  if (!funcOp.isExternal()) {
    SmallVector<Type, 8> argTypes;
    for (const auto &argEn : llvm::enumerate(funcOp.getArguments()))
      argTypes.push_back(argEn.value().getType());

    // Traverse ReturnOps to check if an update to the return type in the
    // function signature is required.
    funcOp.walk([&](ReturnOp returnOp) {
      for (const auto &operandEn : llvm::enumerate(returnOp.getOperands())) {
        Type opType = operandEn.value().getType();
        MemRefType memrefType = opType.dyn_cast<MemRefType>();
        // If type is not memref or if the memref type is same as that in
        // function's return signature then no update is required.
        if (!memrefType || memrefType == resultTypes[operandEn.index()])
          continue;
        // Update function's return type signature.
        // Return type gets normalized either as a result of function argument
        // normalization, AllocOp normalization or an update made at CallOp.
        // There can be many call flows inside a function and an update to a
        // specific ReturnOp has not yet been made. So we check that the result
        // memref type is normalized.
        // TODO: When selective normalization is implemented, handle multiple
        // results case where some are normalized, some aren't.
        if (memrefType.getAffineMaps().empty())
          resultTypes[operandEn.index()] = memrefType;
      }
    });

    // We create a new function type and modify the function signature with this
    // new type.
    newFuncType = FunctionType::get(/*inputs=*/argTypes,
                                    /*results=*/resultTypes,
                                    /*context=*/&getContext());
  }

  // Since we update the function signature, it might affect the result types at
  // the caller site. Since this result might even be used by the caller
  // function in ReturnOps, the caller function's signature will also change.
  // Hence we record the caller function in 'funcOpsToUpdate' to update their
  // signature as well.
  llvm::SmallDenseSet<FuncOp, 8> funcOpsToUpdate;
  // We iterate over all symbolic uses of the function and update the return
  // type at the caller site.
  Optional<SymbolTable::UseRange> symbolUses = funcOp.getSymbolUses(moduleOp);
  for (SymbolTable::SymbolUse symbolUse : *symbolUses) {
    Operation *callOp = symbolUse.getUser();
    OpBuilder builder(callOp);
    StringRef callee = cast<CallOp>(callOp).getCallee();
    Operation *newCallOp = builder.create<CallOp>(
        callOp->getLoc(), resultTypes, builder.getSymbolRefAttr(callee),
        callOp->getOperands());
    bool replacingMemRefUsesFailed = false;
    bool returnTypeChanged = false;
    for (unsigned resIndex : llvm::seq<unsigned>(0, callOp->getNumResults())) {
      OpResult oldResult = callOp->getResult(resIndex);
      OpResult newResult = newCallOp->getResult(resIndex);
      // This condition ensures that if the result is not of type memref or if
      // the resulting memref was already having a trivial map layout then we
      // need not perform any use replacement here.
      if (oldResult.getType() == newResult.getType())
        continue;
      AffineMap layoutMap =
          oldResult.getType().dyn_cast<MemRefType>().getAffineMaps().front();
      if (failed(replaceAllMemRefUsesWith(oldResult, /*newMemRef=*/newResult,
                                          /*extraIndices=*/{},
                                          /*indexRemap=*/layoutMap,
                                          /*extraOperands=*/{},
                                          /*symbolOperands=*/{},
                                          /*domInstFilter=*/nullptr,
                                          /*postDomInstFilter=*/nullptr,
                                          /*allowDereferencingOps=*/true,
                                          /*replaceInDeallocOp=*/true))) {
        // If it failed (due to escapes for example), bail out.
        // It should never hit this part of the code because it is called by
        // only those functions which are normalizable.
        newCallOp->erase();
        replacingMemRefUsesFailed = true;
        break;
      }
      returnTypeChanged = true;
    }
    if (replacingMemRefUsesFailed)
      continue;
    // Replace all uses for other non-memref result types.
    callOp->replaceAllUsesWith(newCallOp);
    callOp->erase();
    if (returnTypeChanged) {
      // Since the return type changed it might lead to a change in function's
      // signature.
      // TODO: If funcOp doesn't return any memref type then no need to update
      // signature.
      // TODO: Further optimization - Check if the memref is indeed part of
      // ReturnOp at the parentFuncOp and only then updation of signature is
      // required.
      // TODO: Extend this for ops that are FunctionLike. This would require
      // creating an OpInterface for FunctionLike ops.
      FuncOp parentFuncOp = newCallOp->getParentOfType<FuncOp>();
      funcOpsToUpdate.insert(parentFuncOp);
    }
  }
  // Because external function's signature is already updated in
  // 'normalizeFuncOpMemRefs()', we don't need to update it here again.
  if (!funcOp.isExternal())
    funcOp.setType(newFuncType);

  // Updating the signature type of those functions which call the current
  // function. Only if the return type of the current function has a normalized
  // memref will the caller function become a candidate for signature update.
  for (FuncOp parentFuncOp : funcOpsToUpdate)
    updateFunctionSignature(parentFuncOp, moduleOp);
}

/// Normalizes the memrefs within a function which includes those arising as a
/// result of AllocOps, CallOps and function's argument. The ModuleOp argument
/// is used to help update function's signature after normalization.
void NormalizeMemRefs::normalizeFuncOpMemRefs(FuncOp funcOp,
                                              ModuleOp moduleOp) {
  // Turn memrefs' non-identity layouts maps into ones with identity. Collect
  // alloc ops first and then process since normalizeMemRef replaces/erases ops
  // during memref rewriting.
  SmallVector<AllocOp, 4> allocOps;
  funcOp.walk([&](AllocOp op) { allocOps.push_back(op); });
  for (AllocOp allocOp : allocOps)
    normalizeMemRef(allocOp);

  // We use this OpBuilder to create new memref layout later.
  OpBuilder b(funcOp);

  FunctionType functionType = funcOp.getType();
  SmallVector<Type, 8> inputTypes;
  // Walk over each argument of a function to perform memref normalization (if
  for (unsigned argIndex :
       llvm::seq<unsigned>(0, functionType.getNumInputs())) {
    Type argType = functionType.getInput(argIndex);
    MemRefType memrefType = argType.dyn_cast<MemRefType>();
    // Check whether argument is of MemRef type. Any other argument type can
    // simply be part of the final function signature.
    if (!memrefType) {
      inputTypes.push_back(argType);
      continue;
    }
    // Fetch a new memref type after normalizing the old memref to have an
    // identity map layout.
    MemRefType newMemRefType = normalizeMemRefType(memrefType, b,
                                                   /*numSymbolicOperands=*/0);
    if (newMemRefType == memrefType || funcOp.isExternal()) {
      // Either memrefType already had an identity map or the map couldn't be
      // transformed to an identity map.
      inputTypes.push_back(newMemRefType);
      continue;
    }

    // Insert a new temporary argument with the new memref type.
    BlockArgument newMemRef =
        funcOp.front().insertArgument(argIndex, newMemRefType);
    BlockArgument oldMemRef = funcOp.getArgument(argIndex + 1);
    AffineMap layoutMap = memrefType.getAffineMaps().front();
    // Replace all uses of the old memref.
    if (failed(replaceAllMemRefUsesWith(oldMemRef, /*newMemRef=*/newMemRef,
                                        /*extraIndices=*/{},
                                        /*indexRemap=*/layoutMap,
                                        /*extraOperands=*/{},
                                        /*symbolOperands=*/{},
                                        /*domInstFilter=*/nullptr,
                                        /*postDomInstFilter=*/nullptr,
                                        /*allowNonDereferencingOps=*/true,
                                        /*replaceInDeallocOp=*/true))) {
      // If it failed (due to escapes for example), bail out. Removing the
      // temporary argument inserted previously.
      funcOp.front().eraseArgument(argIndex);
      continue;
    }

    // All uses for the argument with old memref type were replaced
    // successfully. So we remove the old argument now.
    funcOp.front().eraseArgument(argIndex + 1);
  }

  // In a normal function, memrefs in the return type signature gets normalized
  // as a result of normalization of functions arguments, AllocOps or CallOps'
  // result types. Since an external function doesn't have a body, memrefs in
  // the return type signature can only get normalized by iterating over the
  // individual return types.
  if (funcOp.isExternal()) {
    SmallVector<Type, 4> resultTypes;
    for (unsigned resIndex :
         llvm::seq<unsigned>(0, functionType.getNumResults())) {
      Type resType = functionType.getResult(resIndex);
      MemRefType memrefType = resType.dyn_cast<MemRefType>();
      // Check whether result is of MemRef type. Any other argument type can
      // simply be part of the final function signature.
      if (!memrefType) {
        resultTypes.push_back(resType);
        continue;
      }
      // Computing a new memref type after normalizing the old memref to have an
      // identity map layout.
      MemRefType newMemRefType = normalizeMemRefType(memrefType, b,
                                                     /*numSymbolicOperands=*/0);
      resultTypes.push_back(newMemRefType);
      continue;
    }

    FunctionType newFuncType = FunctionType::get(/*inputs=*/inputTypes,
                                                 /*results=*/resultTypes,
                                                 /*context=*/&getContext());
    // Setting the new function signature for this external function.
    funcOp.setType(newFuncType);
  }
  updateFunctionSignature(funcOp, moduleOp);
}
