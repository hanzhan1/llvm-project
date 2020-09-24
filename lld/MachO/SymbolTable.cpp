//===- SymbolTable.cpp ----------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "SymbolTable.h"
#include "InputFiles.h"
#include "Symbols.h"
#include "lld/Common/ErrorHandler.h"
#include "lld/Common/Memory.h"

using namespace llvm;
using namespace lld;
using namespace lld::macho;

Symbol *SymbolTable::find(StringRef name) {
  auto it = symMap.find(llvm::CachedHashStringRef(name));
  if (it == symMap.end())
    return nullptr;
  return symVector[it->second];
}

std::pair<Symbol *, bool> SymbolTable::insert(StringRef name) {
  auto p = symMap.insert({CachedHashStringRef(name), (int)symVector.size()});

  // Name already present in the symbol table.
  if (!p.second)
    return {symVector[p.first->second], false};

  // Name is a new symbol.
  Symbol *sym = reinterpret_cast<Symbol *>(make<SymbolUnion>());
  symVector.push_back(sym);
  return {sym, true};
}

Symbol *SymbolTable::addDefined(StringRef name, InputSection *isec,
                                uint32_t value, bool isWeakDef) {
  Symbol *s;
  bool wasInserted;
  bool overridesWeakDef = false;
  std::tie(s, wasInserted) = insert(name);

  if (!wasInserted) {
    if (auto *defined = dyn_cast<Defined>(s)) {
      if (isWeakDef)
        return s;
      if (!defined->isWeakDef())
        error("duplicate symbol: " + name);
    } else if (auto *dysym = dyn_cast<DylibSymbol>(s)) {
      overridesWeakDef = !isWeakDef && dysym->isWeakDef();
    }
    // Defined symbols take priority over other types of symbols, so in case
    // of a name conflict, we fall through to the replaceSymbol() call below.
  }

  Defined *defined = replaceSymbol<Defined>(s, name, isec, value, isWeakDef,
                                            /*isExternal=*/true);
  defined->overridesWeakDef = overridesWeakDef;
  return s;
}

Symbol *SymbolTable::addUndefined(StringRef name) {
  Symbol *s;
  bool wasInserted;
  std::tie(s, wasInserted) = insert(name);

  if (wasInserted)
    replaceSymbol<Undefined>(s, name);
  else if (LazySymbol *lazy = dyn_cast<LazySymbol>(s))
    lazy->fetchArchiveMember();
  return s;
}

Symbol *SymbolTable::addCommon(StringRef name, InputFile *file, uint64_t size,
                               uint32_t align) {
  Symbol *s;
  bool wasInserted;
  std::tie(s, wasInserted) = insert(name);

  if (!wasInserted) {
    if (auto *common = dyn_cast<CommonSymbol>(s)) {
      if (size < common->size)
        return s;
    } else if (isa<Defined>(s)) {
      return s;
    }
    // Common symbols take priority over all non-Defined symbols, so in case of
    // a name conflict, we fall through to the replaceSymbol() call below.
  }

  replaceSymbol<CommonSymbol>(s, name, file, size, align);
  return s;
}

Symbol *SymbolTable::addDylib(StringRef name, DylibFile *file, bool isWeakDef,
                              bool isTlv) {
  Symbol *s;
  bool wasInserted;
  std::tie(s, wasInserted) = insert(name);

  if (!wasInserted && isWeakDef)
    if (auto *defined = dyn_cast<Defined>(s))
      if (!defined->isWeakDef())
        defined->overridesWeakDef = true;

  if (wasInserted || isa<Undefined>(s) ||
      (isa<DylibSymbol>(s) && !isWeakDef && s->isWeakDef()))
    replaceSymbol<DylibSymbol>(s, file, name, isWeakDef, isTlv);

  return s;
}

Symbol *SymbolTable::addLazy(StringRef name, ArchiveFile *file,
                             const llvm::object::Archive::Symbol &sym) {
  Symbol *s;
  bool wasInserted;
  std::tie(s, wasInserted) = insert(name);

  if (wasInserted)
    replaceSymbol<LazySymbol>(s, file, sym);
  else if (isa<Undefined>(s) || (isa<DylibSymbol>(s) && s->isWeakDef()))
    file->fetch(sym);
  return s;
}

Symbol *SymbolTable::addDSOHandle(const MachHeaderSection *header) {
  Symbol *s;
  bool wasInserted;
  std::tie(s, wasInserted) = insert(DSOHandle::name);
  if (!wasInserted) {
    if (auto *defined = dyn_cast<Defined>(s))
      error("found defined symbol from " + defined->isec->file->getName() +
            " with illegal name " + DSOHandle::name);
  }
  replaceSymbol<DSOHandle>(s, header);
  return s;
}

SymbolTable *macho::symtab;
