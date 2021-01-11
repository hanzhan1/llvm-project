//===--- Check.cpp - clangd self-diagnostics ------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// Many basic problems can occur processing a file in clangd, e.g.:
//  - system includes are not found
//  - crash when indexing its AST
// clangd --check provides a simplified, isolated way to reproduce these,
// with no editor, LSP, threads, background indexing etc to contend with.
//
// One important use case is gathering information for bug reports.
// Another is reproducing crashes, and checking which setting prevent them.
//
// It simulates opening a file (determining compile command, parsing, indexing)
// and then running features at many locations.
//
// Currently it adds some basic logging of progress and results.
// We should consider extending it to also recognize common symptoms and
// recommend solutions (e.g. standard library installation issues).
//
//===----------------------------------------------------------------------===//

#include "ClangdLSPServer.h"
#include "CodeComplete.h"
#include "GlobalCompilationDatabase.h"
#include "Hover.h"
#include "ParsedAST.h"
#include "Preamble.h"
#include "SourceCode.h"
#include "XRefs.h"
#include "index/CanonicalIncludes.h"
#include "index/FileIndex.h"
#include "refactor/Tweak.h"
#include "support/ThreadsafeFS.h"
#include "clang/AST/ASTContext.h"
#include "clang/Basic/DiagnosticIDs.h"
#include "clang/Format/Format.h"
#include "clang/Frontend/CompilerInvocation.h"
#include "clang/Tooling/CompilationDatabase.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/StringExtras.h"
#include "llvm/Support/Path.h"

namespace clang {
namespace clangd {
namespace {

// Print (and count) the error-level diagnostics (warnings are ignored).
unsigned showErrors(llvm::ArrayRef<Diag> Diags) {
  unsigned ErrCount = 0;
  for (const auto &D : Diags) {
    if (D.Severity >= DiagnosticsEngine::Error) {
      elog("[{0}] Line {1}: {2}", D.Name, D.Range.start.line + 1, D.Message);
      ++ErrCount;
    }
  }
  return ErrCount;
}

// This class is just a linear pipeline whose functions get called in sequence.
// Each exercises part of clangd's logic on our test file and logs results.
// Later steps depend on state built in earlier ones (such as the AST).
// Many steps can fatally fail (return false), then subsequent ones cannot run.
// Nonfatal failures are logged and tracked in ErrCount.
class Checker {
  // from constructor
  std::string File;
  ClangdLSPServer::Options Opts;
  // from buildCommand
  tooling::CompileCommand Cmd;
  // from buildInvocation
  ParseInputs Inputs;
  std::unique_ptr<CompilerInvocation> Invocation;
  format::FormatStyle Style;
  // from buildAST
  std::shared_ptr<const PreambleData> Preamble;
  llvm::Optional<ParsedAST> AST;
  FileIndex Index;

public:
  // Number of non-fatal errors seen.
  unsigned ErrCount = 0;

  Checker(llvm::StringRef File, const ClangdLSPServer::Options &Opts)
      : File(File), Opts(Opts) {}

  // Read compilation database and choose a compile command for the file.
  bool buildCommand(const ThreadsafeFS &TFS) {
    log("Loading compilation database...");
    DirectoryBasedGlobalCompilationDatabase::Options CDBOpts(TFS);
    CDBOpts.CompileCommandsDir = Opts.CompileCommandsDir;
    std::unique_ptr<GlobalCompilationDatabase> BaseCDB =
        std::make_unique<DirectoryBasedGlobalCompilationDatabase>(CDBOpts);
    BaseCDB = getQueryDriverDatabase(llvm::makeArrayRef(Opts.QueryDriverGlobs),
                                     std::move(BaseCDB));
    auto Mangler = CommandMangler::detect();
    if (Opts.ResourceDir)
      Mangler.ResourceDir = *Opts.ResourceDir;
    auto CDB = std::make_unique<OverlayCDB>(
        BaseCDB.get(), std::vector<std::string>{},
        tooling::ArgumentsAdjuster(std::move(Mangler)));

    if (auto TrueCmd = CDB->getCompileCommand(File)) {
      Cmd = std::move(*TrueCmd);
      log("Compile command from CDB is: {0}", llvm::join(Cmd.CommandLine, " "));
    } else {
      Cmd = CDB->getFallbackCommand(File);
      log("Generic fallback command is: {0}", llvm::join(Cmd.CommandLine, " "));
    }

    return true;
  }

  // Prepare inputs and build CompilerInvocation (parsed compile command).
  bool buildInvocation(const ThreadsafeFS &TFS,
                       llvm::Optional<std::string> Contents) {
    StoreDiags CaptureInvocationDiags;
    std::vector<std::string> CC1Args;
    Inputs.CompileCommand = Cmd;
    Inputs.TFS = &TFS;
    Inputs.ClangTidyProvider = Opts.ClangTidyProvider;
    if (Contents.hasValue()) {
      Inputs.Contents = *Contents;
      log("Imaginary source file contents:\n{0}", Inputs.Contents);
    } else {
      if (auto Contents = TFS.view(llvm::None)->getBufferForFile(File)) {
        Inputs.Contents = Contents->get()->getBuffer().str();
      } else {
        elog("Couldn't read {0}: {1}", File, Contents.getError().message());
        return false;
      }
    }
    log("Parsing command...");
    Invocation =
        buildCompilerInvocation(Inputs, CaptureInvocationDiags, &CC1Args);
    auto InvocationDiags = CaptureInvocationDiags.take();
    ErrCount += showErrors(InvocationDiags);
    log("internal (cc1) args are: {0}", llvm::join(CC1Args, " "));
    if (!Invocation) {
      elog("Failed to parse command line");
      return false;
    }

    // FIXME: Check that resource-dir/built-in-headers exist?

    Style = getFormatStyleForFile(File, Inputs.Contents, TFS);

    return true;
  }

  // Build preamble and AST, and index them.
  bool buildAST() {
    log("Building preamble...");
    Preamble =
        buildPreamble(File, *Invocation, Inputs, /*StoreInMemory=*/true,
                      [&](ASTContext &Ctx, std::shared_ptr<Preprocessor> PP,
                          const CanonicalIncludes &Includes) {
                        if (!Opts.BuildDynamicSymbolIndex)
                          return;
                        log("Indexing headers...");
                        Index.updatePreamble(File, /*Version=*/"null", Ctx,
                                             std::move(PP), Includes);
                      });
    if (!Preamble) {
      elog("Failed to build preamble");
      return false;
    }
    ErrCount += showErrors(Preamble->Diags);

    log("Building AST...");
    AST = ParsedAST::build(File, Inputs, std::move(Invocation),
                           /*InvocationDiags=*/std::vector<Diag>{}, Preamble);
    if (!AST) {
      elog("Failed to build AST");
      return false;
    }
    ErrCount += showErrors(llvm::makeArrayRef(AST->getDiagnostics())
                               .drop_front(Preamble->Diags.size()));

    if (Opts.BuildDynamicSymbolIndex) {
      log("Indexing AST...");
      Index.updateMain(File, *AST);
    }
    return true;
  }

  // Run AST-based features at each token in the file.
  void testLocationFeatures() {
    log("Testing features at each token (may be slow in large files)");
    auto SpelledTokens =
        AST->getTokens().spelledTokens(AST->getSourceManager().getMainFileID());
    for (const auto &Tok : SpelledTokens) {
      unsigned Start = AST->getSourceManager().getFileOffset(Tok.location());
      unsigned End = Start + Tok.length();
      Position Pos = offsetToPosition(Inputs.Contents, Start);
      // FIXME: dumping the tokens may leak sensitive code into bug reports.
      // Add an option to turn this off, once we decide how options work.
      vlog("  {0} {1}", Pos, Tok.text(AST->getSourceManager()));
      auto Tree = SelectionTree::createRight(AST->getASTContext(),
                                             AST->getTokens(), Start, End);
      Tweak::Selection Selection(&Index, *AST, Start, End, std::move(Tree));
      for (const auto &T : prepareTweaks(Selection, Opts.TweakFilter)) {
        auto Result = T->apply(Selection);
        if (!Result) {
          elog("    tweak: {0} ==> FAIL: {1}", T->id(), Result.takeError());
          ++ErrCount;
        } else {
          vlog("    tweak: {0}", T->id());
        }
      }
      unsigned Definitions = locateSymbolAt(*AST, Pos, &Index).size();
      vlog("    definition: {0}", Definitions);

      auto Hover = getHover(*AST, Pos, Style, &Index);
      vlog("    hover: {0}", Hover.hasValue());

      // FIXME: it'd be nice to include code completion, but it's too slow.
      // Maybe in combination with a line restriction?
    }
  }
};

} // namespace

bool check(llvm::StringRef File, const ThreadsafeFS &TFS,
           const ClangdLSPServer::Options &Opts) {
  llvm::SmallString<0> FakeFile;
  llvm::Optional<std::string> Contents;
  if (File.empty()) {
    llvm::sys::path::system_temp_directory(false, FakeFile);
    llvm::sys::path::append(FakeFile, "test.cc");
    File = FakeFile;
    Contents = R"cpp(
      #include <stddef.h>
      #include <string>

      size_t N = 50;
      auto xxx = std::string(N, 'x');
    )cpp";
  }
  log("Testing on source file {0}", File);

  Checker C(File, Opts);
  if (!C.buildCommand(TFS) || !C.buildInvocation(TFS, Contents) ||
      !C.buildAST())
    return false;
  C.testLocationFeatures();

  log("All checks completed, {0} errors", C.ErrCount);
  return C.ErrCount == 0;
}

} // namespace clangd
} // namespace clang
