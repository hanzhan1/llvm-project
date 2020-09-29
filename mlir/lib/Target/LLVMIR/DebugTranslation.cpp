//===- DebugTranslation.cpp - MLIR to LLVM Debug conversion ---------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "DebugTranslation.h"
#include "mlir/Dialect/LLVMIR/LLVMDialect.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"

using namespace mlir;
using namespace mlir::LLVM;
using namespace mlir::LLVM::detail;

/// A utility walker that interrupts if the operation has valid debug
/// information.
static WalkResult interruptIfValidLocation(Operation *op) {
  return op->getLoc().isa<UnknownLoc>() ? WalkResult::advance()
                                        : WalkResult::interrupt();
}

DebugTranslation::DebugTranslation(Operation *module, llvm::Module &llvmModule)
    : builder(llvmModule), llvmCtx(llvmModule.getContext()),
      compileUnit(nullptr) {

  // If the module has no location information, there is nothing to do.
  if (!module->walk(interruptIfValidLocation).wasInterrupted())
    return;

  // TODO: Several parts of this are incorrect. Different source
  // languages may interpret different parts of the debug information
  // differently. Frontends will also want to pipe in various information, like
  // flags. This is fine for now as we only emit line-table information and not
  // types or variables. This should disappear as the debug information story
  // evolves; i.e. when we have proper attributes for LLVM debug metadata.
  compileUnit = builder.createCompileUnit(
      llvm::dwarf::DW_LANG_C,
      builder.createFile(llvmModule.getModuleIdentifier(), "/"),
      /*Producer=*/"mlir", /*isOptimized=*/true, /*Flags=*/"", /*RV=*/0);

  // Mark this module as having debug information.
  StringRef debugVersionKey = "Debug Info Version";
  if (!llvmModule.getModuleFlag(debugVersionKey))
    llvmModule.addModuleFlag(llvm::Module::Warning, debugVersionKey,
                             llvm::DEBUG_METADATA_VERSION);
}

/// Finalize the translation of debug information.
void DebugTranslation::finalize() { builder.finalize(); }

/// Attempt to extract a filename for the given loc.
static FileLineColLoc extractFileLoc(Location loc) {
  if (auto fileLoc = loc.dyn_cast<FileLineColLoc>())
    return fileLoc;
  if (auto nameLoc = loc.dyn_cast<NameLoc>())
    return extractFileLoc(nameLoc.getChildLoc());
  if (auto opaqueLoc = loc.dyn_cast<OpaqueLoc>())
    return extractFileLoc(opaqueLoc.getFallbackLocation());
  return FileLineColLoc();
}

/// Translate the debug information for the given function.
void DebugTranslation::translate(LLVMFuncOp func, llvm::Function &llvmFunc) {
  // If the function doesn't have location information, there is nothing to
  // translate.
  if (!compileUnit || !func.walk(interruptIfValidLocation).wasInterrupted())
    return;

  // If we are to create debug info for the function, we need to ensure that all
  // inlinable calls in it are with debug info, otherwise the LLVM verifier will
  // complain. For now, be more restricted and treat all calls as inlinable.
  const bool hasCallWithoutDebugInfo =
      func.walk([](LLVM::CallOp call) {
            return call.getLoc().isa<UnknownLoc>() ? WalkResult::interrupt()
                                                   : WalkResult::advance();
          })
          .wasInterrupted();
  if (hasCallWithoutDebugInfo)
    return;

  FileLineColLoc fileLoc = extractFileLoc(func.getLoc());
  auto *file = translateFile(fileLoc ? fileLoc.getFilename() : "<unknown>");
  unsigned line = fileLoc ? fileLoc.getLine() : 0;

  // TODO: This is the bare essentials for now. We will likely end
  // up with wrapper metadata around LLVMs metadata in the future, so this
  // doesn't need to be smart until then.
  llvm::DISubroutineType *type =
      builder.createSubroutineType(builder.getOrCreateTypeArray(llvm::None));
  llvm::DISubprogram::DISPFlags spFlags = llvm::DISubprogram::SPFlagDefinition |
                                          llvm::DISubprogram::SPFlagOptimized;
  llvm::DISubprogram *program =
      builder.createFunction(compileUnit, func.getName(), func.getName(), file,
                             line, type, line, llvm::DINode::FlagZero, spFlags);
  llvmFunc.setSubprogram(program);
  builder.finalizeSubprogram(program);
}

//===----------------------------------------------------------------------===//
// Locations
//===----------------------------------------------------------------------===//

/// Translate the given location to an llvm debug location.
const llvm::DILocation *
DebugTranslation::translateLoc(Location loc, llvm::DILocalScope *scope) {
  if (!compileUnit)
    return nullptr;
  return translateLoc(loc, scope, /*inlinedAt=*/nullptr);
}

/// Translate the given location to an llvm DebugLoc.
const llvm::DILocation *
DebugTranslation::translateLoc(Location loc, llvm::DILocalScope *scope,
                               const llvm::DILocation *inlinedAt) {
  // LLVM doesn't have a representation for unknown.
  if (!scope || loc.isa<UnknownLoc>())
    return nullptr;

  // Check for a cached instance.
  auto existingIt = locationToLoc.find(std::make_pair(loc, scope));
  if (existingIt != locationToLoc.end())
    return existingIt->second;

  const llvm::DILocation *llvmLoc = nullptr;
  if (auto callLoc = loc.dyn_cast<CallSiteLoc>()) {
    // For callsites, the caller is fed as the inlinedAt for the callee.
    const auto *callerLoc = translateLoc(callLoc.getCaller(), scope, inlinedAt);
    llvmLoc = translateLoc(callLoc.getCallee(), scope, callerLoc);

  } else if (auto fileLoc = loc.dyn_cast<FileLineColLoc>()) {
    auto *file = translateFile(fileLoc.getFilename());
    auto *fileScope = builder.createLexicalBlockFile(scope, file);
    llvmLoc = llvm::DILocation::get(llvmCtx, fileLoc.getLine(),
                                    fileLoc.getColumn(), fileScope,
                                    const_cast<llvm::DILocation *>(inlinedAt));

  } else if (auto fusedLoc = loc.dyn_cast<FusedLoc>()) {
    ArrayRef<Location> locations = fusedLoc.getLocations();

    // For fused locations, merge each of the nodes.
    llvmLoc = translateLoc(locations.front(), scope, inlinedAt);
    for (Location locIt : locations.drop_front()) {
      llvmLoc = llvm::DILocation::getMergedLocation(
          llvmLoc, translateLoc(locIt, scope, inlinedAt));
    }

  } else if (auto nameLoc = loc.dyn_cast<NameLoc>()) {
    llvmLoc = translateLoc(loc.cast<NameLoc>().getChildLoc(), scope, inlinedAt);

  } else if (auto opaqueLoc = loc.dyn_cast<OpaqueLoc>()) {
    llvmLoc = translateLoc(loc.cast<OpaqueLoc>().getFallbackLocation(), scope,
                           inlinedAt);
  } else {
    llvm_unreachable("unknown location kind");
  }

  locationToLoc.try_emplace(std::make_pair(loc, scope), llvmLoc);
  return llvmLoc;
}

/// Create an llvm debug file for the given file path.
llvm::DIFile *DebugTranslation::translateFile(StringRef fileName) {
  auto *&file = fileMap[fileName];
  if (file)
    return file;

  // Make sure the current working directory is up-to-date.
  if (currentWorkingDir.empty())
    llvm::sys::fs::current_path(currentWorkingDir);

  StringRef directory = currentWorkingDir;
  SmallString<128> dirBuf;
  SmallString<128> fileBuf;
  if (llvm::sys::path::is_absolute(fileName)) {
    // Strip the common prefix (if it is more than just "/") from current
    // directory and FileName for a more space-efficient encoding.
    auto fileIt = llvm::sys::path::begin(fileName);
    auto fileE = llvm::sys::path::end(fileName);
    auto curDirIt = llvm::sys::path::begin(directory);
    auto curDirE = llvm::sys::path::end(directory);
    for (; curDirIt != curDirE && *curDirIt == *fileIt; ++curDirIt, ++fileIt)
      llvm::sys::path::append(dirBuf, *curDirIt);
    if (std::distance(llvm::sys::path::begin(directory), curDirIt) == 1) {
      // Don't strip the common prefix if it is only the root "/"  since that
      // would make LLVM diagnostic locations confusing.
      directory = StringRef();
    } else {
      for (; fileIt != fileE; ++fileIt)
        llvm::sys::path::append(fileBuf, *fileIt);
      directory = dirBuf;
      fileName = fileBuf;
    }
  }
  return (file = builder.createFile(fileName, directory));
}
