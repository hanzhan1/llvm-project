//===- LoopUtils.h - Loop transformation utilities --------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This header file defines prototypes for various loop transformation utility
// methods: these are not passes by themselves but are used either by passes,
// optimization sequences, or in turn by other transformation utilities.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_TRANSFORMS_LOOP_UTILS_H
#define MLIR_TRANSFORMS_LOOP_UTILS_H

#include "mlir/IR/Block.h"
#include "mlir/Support/LLVM.h"
#include "mlir/Support/LogicalResult.h"

namespace mlir {
class AffineForOp;
class FuncOp;
class LoopLikeOpInterface;
struct MemRefRegion;
class OpBuilder;
class Value;
class ValueRange;

namespace scf {
class ForOp;
class ParallelOp;
} // end namespace scf

/// Unrolls this for operation completely if the trip count is known to be
/// constant. Returns failure otherwise.
LogicalResult loopUnrollFull(AffineForOp forOp);

/// Unrolls this for operation by the specified unroll factor. Returns failure
/// if the loop cannot be unrolled either due to restrictions or due to invalid
/// unroll factors. Requires positive loop bounds and step.
LogicalResult loopUnrollByFactor(AffineForOp forOp, uint64_t unrollFactor);
LogicalResult loopUnrollByFactor(scf::ForOp forOp, uint64_t unrollFactor);

/// Unrolls this loop by the specified unroll factor or its trip count,
/// whichever is lower.
LogicalResult loopUnrollUpToFactor(AffineForOp forOp, uint64_t unrollFactor);

/// Returns true if `loops` is a perfectly nested loop nest, where loops appear
/// in it from outermost to innermost.
bool LLVM_ATTRIBUTE_UNUSED isPerfectlyNested(ArrayRef<AffineForOp> loops);

/// Get perfectly nested sequence of loops starting at root of loop nest
/// (the first op being another AffineFor, and the second op - a terminator).
/// A loop is perfectly nested iff: the first op in the loop's body is another
/// AffineForOp, and the second op is a terminator).
void getPerfectlyNestedLoops(SmallVectorImpl<AffineForOp> &nestedLoops,
                             AffineForOp root);
void getPerfectlyNestedLoops(SmallVectorImpl<scf::ForOp> &nestedLoops,
                             scf::ForOp root);

/// Unrolls and jams this loop by the specified factor. Returns success if the
/// loop is successfully unroll-jammed.
LogicalResult loopUnrollJamByFactor(AffineForOp forOp,
                                    uint64_t unrollJamFactor);

/// Unrolls and jams this loop by the specified factor or by the trip count (if
/// constant), whichever is lower.
LogicalResult loopUnrollJamUpToFactor(AffineForOp forOp,
                                      uint64_t unrollJamFactor);

/// Promotes the loop body of a AffineForOp/scf::ForOp to its containing block
/// if the loop was known to have a single iteration.
LogicalResult promoteIfSingleIteration(AffineForOp forOp);
LogicalResult promoteIfSingleIteration(scf::ForOp forOp);

/// Promotes all single iteration AffineForOp's in the Function, i.e., moves
/// their body into the containing Block.
void promoteSingleIterationLoops(FuncOp f);

/// Skew the operations in an affine.for's body with the specified
/// operation-wise shifts. The shifts are with respect to the original execution
/// order, and are multiplied by the loop 'step' before being applied. If
/// `unrollPrologueEpilogue` is set, fully unroll the prologue and epilogue
/// loops when possible.
LLVM_NODISCARD
LogicalResult affineForOpBodySkew(AffineForOp forOp, ArrayRef<uint64_t> shifts,
                                  bool unrollPrologueEpilogue = false);

/// Identify valid and profitable bands of loops to tile. This is currently just
/// a temporary placeholder to test the mechanics of tiled code generation.
/// Returns all maximal outermost perfect loop nests to tile.
void getTileableBands(FuncOp f,
                      std::vector<SmallVector<AffineForOp, 6>> *bands);

/// Tiles the specified band of perfectly nested loops creating tile-space loops
/// and intra-tile loops. A band is a contiguous set of loops.
LLVM_NODISCARD
LogicalResult
tilePerfectlyNested(MutableArrayRef<AffineForOp> input,
                    ArrayRef<unsigned> tileSizes,
                    SmallVectorImpl<AffineForOp> *tiledNest = nullptr);

/// Tiles the specified band of perfectly nested loops creating tile-space
/// loops and intra-tile loops, using SSA values as tiling parameters. A band
/// is a contiguous set of loops.
LLVM_NODISCARD
LogicalResult tilePerfectlyNestedParametric(
    MutableArrayRef<AffineForOp> input, ArrayRef<Value> tileSizes,
    SmallVectorImpl<AffineForOp> *tiledNest = nullptr);

/// Performs loop interchange on 'forOpA' and 'forOpB'. Requires that 'forOpA'
/// and 'forOpB' are part of a perfectly nested sequence of loops.
void interchangeLoops(AffineForOp forOpA, AffineForOp forOpB);

/// Checks if the loop interchange permutation 'loopPermMap', of the perfectly
/// nested sequence of loops in 'loops', would violate dependences (loop 'i' in
/// 'loops' is mapped to location 'j = 'loopPermMap[i]' in the interchange).
bool isValidLoopInterchangePermutation(ArrayRef<AffineForOp> loops,
                                       ArrayRef<unsigned> loopPermMap);

/// Performs a loop permutation on a perfectly nested loop nest `inputNest`
/// (where the contained loops appear from outer to inner) as specified by the
/// permutation `permMap`: loop 'i' in `inputNest` is mapped to location
/// 'loopPermMap[i]', where positions 0, 1, ... are from the outermost position
/// to inner. Returns the position in `inputNest` of the AffineForOp that
/// becomes the new outermost loop of this nest. This method always succeeds,
/// asserts out on invalid input / specifications.
unsigned permuteLoops(MutableArrayRef<AffineForOp> inputNest,
                      ArrayRef<unsigned> permMap);

// Sinks all sequential loops to the innermost levels (while preserving
// relative order among them) and moves all parallel loops to the
// outermost (while again preserving relative order among them).
// Returns AffineForOp of the root of the new loop nest after loop interchanges.
AffineForOp sinkSequentialLoops(AffineForOp forOp);

/// Performs tiling fo imperfectly nested loops (with interchange) by
/// strip-mining the `forOps` by `sizes` and sinking them, in their order of
/// occurrence in `forOps`, under each of the `targets`.
/// Returns the new AffineForOps, one per each of (`forOps`, `targets`) pair,
/// nested immediately under each of `targets`.
using Loops = SmallVector<scf::ForOp, 8>;
using TileLoops = std::pair<Loops, Loops>;
SmallVector<SmallVector<AffineForOp, 8>, 8> tile(ArrayRef<AffineForOp> forOps,
                                                 ArrayRef<uint64_t> sizes,
                                                 ArrayRef<AffineForOp> targets);
SmallVector<Loops, 8> tile(ArrayRef<scf::ForOp> forOps, ArrayRef<Value> sizes,
                           ArrayRef<scf::ForOp> targets);

/// Performs tiling (with interchange) by strip-mining the `forOps` by `sizes`
/// and sinking them, in their order of occurrence in `forOps`, under `target`.
/// Returns the new AffineForOps, one per `forOps`, nested immediately under
/// `target`.
SmallVector<AffineForOp, 8> tile(ArrayRef<AffineForOp> forOps,
                                 ArrayRef<uint64_t> sizes, AffineForOp target);
Loops tile(ArrayRef<scf::ForOp> forOps, ArrayRef<Value> sizes,
           scf::ForOp target);

/// Tile a nest of scf::ForOp loops rooted at `rootForOp` with the given
/// (parametric) sizes. Sizes are expected to be strictly positive values at
/// runtime.  If more sizes than loops are provided, discard the trailing values
/// in sizes.  Assumes the loop nest is permutable.
/// Returns the newly created intra-tile loops.
Loops tilePerfectlyNested(scf::ForOp rootForOp, ArrayRef<Value> sizes);

/// Explicit copy / DMA generation options for mlir::affineDataCopyGenerate.
struct AffineCopyOptions {
  // True if DMAs should be generated instead of point-wise copies.
  bool generateDma;
  // The slower memory space from which data is to be moved.
  unsigned slowMemorySpace;
  // Memory space of the faster one (typically a scratchpad).
  unsigned fastMemorySpace;
  // Memory space to place tags in: only meaningful for DMAs.
  unsigned tagMemorySpace;
  // Capacity of the fast memory space in bytes.
  uint64_t fastMemCapacityBytes;
};

/// Performs explicit copying for the contiguous sequence of operations in the
/// block iterator range [`begin', `end'), where `end' can't be past the
/// terminator of the block (since additional operations are potentially
/// inserted right before `end`. Returns the total size of fast memory space
/// buffers used. `copyOptions` provides various parameters, and the output
/// argument `copyNests` is the set of all copy nests inserted, each represented
/// by its root affine.for. Since we generate alloc's and dealloc's for all fast
/// buffers (before and after the range of operations resp. or at a hoisted
/// position), all of the fast memory capacity is assumed to be available for
/// processing this block range. When 'filterMemRef' is specified, copies are
/// only generated for the provided MemRef.
uint64_t affineDataCopyGenerate(Block::iterator begin, Block::iterator end,
                                const AffineCopyOptions &copyOptions,
                                Optional<Value> filterMemRef,
                                DenseSet<Operation *> &copyNests);

/// A convenience version of affineDataCopyGenerate for all ops in the body of
/// an AffineForOp.
uint64_t affineDataCopyGenerate(AffineForOp forOp,
                                const AffineCopyOptions &copyOptions,
                                Optional<Value> filterMemRef,
                                DenseSet<Operation *> &copyNests);

/// Result for calling generateCopyForMemRegion.
struct CopyGenerateResult {
  // Number of bytes used by alloc.
  uint64_t sizeInBytes;

  // The newly created buffer allocation.
  Operation *alloc;

  // Generated loop nest for copying data between the allocated buffer and the
  // original memref.
  Operation *copyNest;
};

/// generateCopyForMemRegion is similar to affineDataCopyGenerate, but works
/// with a single memref region. `memrefRegion` is supposed to contain analysis
/// information within analyzedOp. The generated prologue and epilogue always
/// surround `analyzedOp`.
///
/// Note that `analyzedOp` is a single op for API convenience, and the
/// [begin, end) version can be added as needed.
///
/// Also note that certain options in `copyOptions` aren't looked at anymore,
/// like slowMemorySpace.
LogicalResult generateCopyForMemRegion(const MemRefRegion &memrefRegion,
                                       Operation *analyzedOp,
                                       const AffineCopyOptions &copyOptions,
                                       CopyGenerateResult &result);

/// Tile a nest of standard for loops rooted at `rootForOp` by finding such
/// parametric tile sizes that the outer loops have a fixed number of iterations
/// as defined in `sizes`.
TileLoops extractFixedOuterLoops(scf::ForOp rootFOrOp, ArrayRef<int64_t> sizes);

/// Replace a perfect nest of "for" loops with a single linearized loop. Assumes
/// `loops` contains a list of perfectly nested loops with bounds and steps
/// independent of any loop induction variable involved in the nest.
void coalesceLoops(MutableArrayRef<scf::ForOp> loops);

/// Take the ParallelLoop and for each set of dimension indices, combine them
/// into a single dimension. combinedDimensions must contain each index into
/// loops exactly once.
void collapseParallelLoops(scf::ParallelOp loops,
                           ArrayRef<std::vector<unsigned>> combinedDimensions);

/// Maps `forOp` for execution on a parallel grid of virtual `processorIds` of
/// size given by `numProcessors`. This is achieved by embedding the SSA values
/// corresponding to `processorIds` and `numProcessors` into the bounds and step
/// of the `forOp`. No check is performed on the legality of the rewrite, it is
/// the caller's responsibility to ensure legality.
///
/// Requires that `processorIds` and `numProcessors` have the same size and that
/// for each idx, `processorIds`[idx] takes, at runtime, all values between 0
/// and `numProcessors`[idx] - 1. This corresponds to traditional use cases for:
///   1. GPU (threadIdx, get_local_id(), ...)
///   2. MPI (MPI_Comm_rank)
///   3. OpenMP (omp_get_thread_num)
///
/// Example:
/// Assuming a 2-d grid with processorIds = [blockIdx.x, threadIdx.x] and
/// numProcessors = [gridDim.x, blockDim.x], the loop:
///
/// ```
///    scf.for %i = %lb to %ub step %step {
///      ...
///    }
/// ```
///
/// is rewritten into a version resembling the following pseudo-IR:
///
/// ```
///    scf.for %i = %lb + %step * (threadIdx.x + blockIdx.x * blockDim.x)
///       to %ub step %gridDim.x * blockDim.x * %step {
///      ...
///    }
/// ```
void mapLoopToProcessorIds(scf::ForOp forOp, ArrayRef<Value> processorId,
                           ArrayRef<Value> numProcessors);

/// Gathers all AffineForOps in 'func' grouped by loop depth.
void gatherLoops(FuncOp func,
                 std::vector<SmallVector<AffineForOp, 2>> &depthToLoops);

/// Creates an AffineForOp while ensuring that the lower and upper bounds are
/// canonicalized, i.e., unused and duplicate operands are removed, any constant
/// operands propagated/folded in, and duplicate bound maps dropped.
AffineForOp createCanonicalizedAffineForOp(OpBuilder b, Location loc,
                                           ValueRange lbOperands,
                                           AffineMap lbMap,
                                           ValueRange ubOperands,
                                           AffineMap ubMap, int64_t step = 1);

/// Separates full tiles from partial tiles for a perfect nest `nest` by
/// generating a conditional guard that selects between the full tile version
/// and the partial tile version using an AffineIfOp. The original loop nest
/// is replaced by this guarded two version form.
///
///    affine.if (cond)
///      // full_tile
///    else
///      // partial tile
///
LogicalResult
separateFullTiles(MutableArrayRef<AffineForOp> nest,
                  SmallVectorImpl<AffineForOp> *fullTileNest = nullptr);

/// Move loop invariant code out of `looplike`.
LogicalResult moveLoopInvariantCode(LoopLikeOpInterface looplike);

} // end namespace mlir

#endif // MLIR_TRANSFORMS_LOOP_UTILS_H
