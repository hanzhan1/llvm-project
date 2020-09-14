//===- SCFOps.h - Structured Control Flow -----------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines structured control flow operations.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_SCF_H_
#define MLIR_DIALECT_SCF_H_

#include "mlir/IR/Attributes.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/Interfaces/ControlFlowInterfaces.h"
#include "mlir/Interfaces/LoopLikeInterface.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

namespace mlir {
namespace scf {
void buildTerminatedBody(OpBuilder &builder, Location loc);
} // namespace scf
} // namespace mlir

#include "mlir/Dialect/SCF/SCFOpsDialect.h.inc"

#define GET_OP_CLASSES
#include "mlir/Dialect/SCF/SCFOps.h.inc"

namespace mlir {
namespace scf {

// Insert `loop.yield` at the end of the only region's only block if it
// does not have a terminator already.  If a new `loop.yield` is inserted,
// the location is specified by `loc`. If the region is empty, insert a new
// block first.
void ensureLoopTerminator(Region &region, Builder &builder, Location loc);

/// Returns the loop parent of an induction variable. If the provided value is
/// not an induction variable, then return nullptr.
ForOp getForInductionVarOwner(Value val);

/// Returns the parallel loop parent of an induction variable. If the provided
/// value is not an induction variable, then return nullptr.
ParallelOp getParallelForInductionVarOwner(Value val);

/// An owning vector of values, handy to return from functions.
using ValueVector = std::vector<Value>;

/// Creates a perfect nest of "for" loops, i.e. all loops but the innermost
/// contain only another loop and a terminator. The lower, upper bounds and
/// steps are provided as `lbs`, `ubs` and `steps`, which are expected to be of
/// the same size. `iterArgs` points to the initial values of the loop iteration
/// arguments, which will be forwarded through the nest to the innermost loop.
/// The body of the loop is populated using `bodyBuilder`, which accepts an
/// ordered list of induction variables of all loops, followed by a list of
/// iteration arguments of the innermost loop, in the same order as provided to
/// `iterArgs`. This function is expected to return as many values as
/// `iterArgs`, of the same type and in the same order, that will be treated as
/// yielded from the loop body and forwarded back through the loop nest. If the
/// function is not provided, the loop nest is not expected to have iteration
/// arguments, the body of the innermost loop will be left empty, containing
/// only the zero-operand terminator. Returns the values yielded by the
/// outermost loop. If bound arrays are empty, the body builder will be called
/// once to construct the IR outside of the loop with an empty list of induction
/// variables.
ValueVector buildLoopNest(
    OpBuilder &builder, Location loc, ValueRange lbs, ValueRange ubs,
    ValueRange steps, ValueRange iterArgs,
    function_ref<ValueVector(OpBuilder &, Location, ValueRange, ValueRange)>
        bodyBuilder = nullptr);

/// A convenience version for building loop nests without iteration arguments
/// (like for reductions). Does not take the initial value of reductions or
/// expect the body building functions to return their current value.
ValueVector buildLoopNest(OpBuilder &builder, Location loc, ValueRange lbs,
                          ValueRange ubs, ValueRange steps,
                          function_ref<void(OpBuilder &, Location, ValueRange)>
                              bodyBuilder = nullptr);

} // end namespace scf
} // end namespace mlir
#endif // MLIR_DIALECT_SCF_H_
