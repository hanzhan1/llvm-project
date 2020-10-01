//===- TypeMerger.h ---------------------------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef LLD_COFF_TYPEMERGER_H
#define LLD_COFF_TYPEMERGER_H

#include "Config.h"
#include "llvm/DebugInfo/CodeView/MergingTypeTableBuilder.h"
#include "llvm/DebugInfo/CodeView/TypeHashing.h"
#include "llvm/Support/Allocator.h"
#include <atomic>

namespace lld {
namespace coff {

using llvm::codeview::GloballyHashedType;
using llvm::codeview::TypeIndex;

struct GHashState;

class TypeMerger {
public:
  TypeMerger(llvm::BumpPtrAllocator &alloc);

  ~TypeMerger();

  /// Get the type table or the global type table if /DEBUG:GHASH is enabled.
  inline llvm::codeview::TypeCollection &getTypeTable() {
    assert(!config->debugGHashes);
    return typeTable;
  }

  /// Get the ID table or the global ID table if /DEBUG:GHASH is enabled.
  inline llvm::codeview::TypeCollection &getIDTable() {
    assert(!config->debugGHashes);
    return idTable;
  }

  /// Use global hashes to eliminate duplicate types and identify unique type
  /// indices in each TpiSource.
  void mergeTypesWithGHash();

  /// Map from PDB function id type indexes to PDB function type indexes.
  /// Populated after mergeTypesWithGHash.
  llvm::DenseMap<TypeIndex, TypeIndex> funcIdToType;

  /// Type records that will go into the PDB TPI stream.
  llvm::codeview::MergingTypeTableBuilder typeTable;

  /// Item records that will go into the PDB IPI stream.
  llvm::codeview::MergingTypeTableBuilder idTable;

  // When showSummary is enabled, these are histograms of TPI and IPI records
  // keyed by type index.
  SmallVector<uint32_t, 0> tpiCounts;
  SmallVector<uint32_t, 0> ipiCounts;
};

} // namespace coff
} // namespace lld

#endif
