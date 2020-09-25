//===--- MacroExpander.cpp - Format C++ code --------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file contains the implementation of MacroExpander, which handles macro
/// configuration and expansion while formatting.
///
//===----------------------------------------------------------------------===//

#include "Macros.h"

#include "Encoding.h"
#include "FormatToken.h"
#include "FormatTokenLexer.h"
#include "clang/Basic/TokenKinds.h"
#include "clang/Format/Format.h"
#include "clang/Lex/HeaderSearch.h"
#include "clang/Lex/HeaderSearchOptions.h"
#include "clang/Lex/Lexer.h"
#include "clang/Lex/ModuleLoader.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Lex/PreprocessorOptions.h"
#include "llvm/ADT/StringSet.h"
#include "llvm/Support/ErrorHandling.h"

namespace clang {
namespace format {

struct MacroExpander::Definition {
  StringRef Name;
  SmallVector<FormatToken *, 8> Params;
  SmallVector<FormatToken *, 8> Body;

  // Map from each argument's name to its position in the argument list.
  // With "M(x, y) x + y":
  //   x -> 0
  //   y -> 1
  llvm::StringMap<size_t> ArgMap;

  bool ObjectLike = true;
};

class MacroExpander::DefinitionParser {
public:
  DefinitionParser(ArrayRef<FormatToken *> Tokens) : Tokens(Tokens) {
    assert(!Tokens.empty());
    Current = Tokens[0];
  }

  // Parse the token stream and return the corresonding Definition object.
  // Returns an empty definition object with a null-Name on error.
  MacroExpander::Definition parse() {
    if (!Current->is(tok::identifier))
      return {};
    Def.Name = Current->TokenText;
    nextToken();
    if (Current->is(tok::l_paren)) {
      Def.ObjectLike = false;
      if (!parseParams())
        return {};
    }
    if (!parseExpansion())
      return {};

    return Def;
  }

private:
  bool parseParams() {
    assert(Current->is(tok::l_paren));
    nextToken();
    while (Current->is(tok::identifier)) {
      Def.Params.push_back(Current);
      Def.ArgMap[Def.Params.back()->TokenText] = Def.Params.size() - 1;
      nextToken();
      if (Current->isNot(tok::comma))
        break;
      nextToken();
    }
    if (Current->isNot(tok::r_paren))
      return false;
    nextToken();
    return true;
  }

  bool parseExpansion() {
    if (!Current->isOneOf(tok::equal, tok::eof))
      return false;
    if (Current->is(tok::equal))
      nextToken();
    parseTail();
    return true;
  }

  void parseTail() {
    while (Current->isNot(tok::eof)) {
      Def.Body.push_back(Current);
      nextToken();
    }
    Def.Body.push_back(Current);
  }

  void nextToken() {
    if (Pos + 1 < Tokens.size())
      ++Pos;
    Current = Tokens[Pos];
    Current->Finalized = true;
  }

  size_t Pos = 0;
  FormatToken *Current = nullptr;
  Definition Def;
  ArrayRef<FormatToken *> Tokens;
};

MacroExpander::MacroExpander(
    const std::vector<std::string> &Macros, clang::SourceManager &SourceMgr,
    const FormatStyle &Style,
    llvm::SpecificBumpPtrAllocator<FormatToken> &Allocator,
    IdentifierTable &IdentTable)
    : SourceMgr(SourceMgr), Style(Style), Allocator(Allocator),
      IdentTable(IdentTable) {
  for (const std::string &Macro : Macros) {
    parseDefinition(Macro);
  }
}

MacroExpander::~MacroExpander() = default;

void MacroExpander::parseDefinition(const std::string &Macro) {
  Buffers.push_back(
      llvm::MemoryBuffer::getMemBufferCopy(Macro, "<scratch space>"));
  clang::FileID FID =
      SourceMgr.createFileID(SourceManager::Unowned, Buffers.back().get());
  FormatTokenLexer Lex(SourceMgr, FID, 0, Style, encoding::Encoding_UTF8,
                       Allocator, IdentTable);
  const auto Tokens = Lex.lex();
  if (!Tokens.empty()) {
    DefinitionParser Parser(Tokens);
    auto Definition = Parser.parse();
    Definitions[Definition.Name] = std::move(Definition);
  }
}

bool MacroExpander::defined(llvm::StringRef Name) const {
  return Definitions.find(Name) != Definitions.end();
}

bool MacroExpander::objectLike(llvm::StringRef Name) const {
  return Definitions.find(Name)->second.ObjectLike;
}

llvm::SmallVector<FormatToken *, 8> MacroExpander::expand(FormatToken *ID,
                                                          ArgsList Args) const {
  assert(defined(ID->TokenText));
  SmallVector<FormatToken *, 8> Result;
  const Definition &Def = Definitions.find(ID->TokenText)->second;

  // Expand each argument at most once.
  llvm::StringSet<> ExpandedArgs;

  // Adds the given token to Result.
  auto pushToken = [&](FormatToken *Tok) {
    Tok->MacroCtx->ExpandedFrom.push_back(ID);
    Result.push_back(Tok);
  };

  // If Tok references a parameter, adds the corresponding argument to Result.
  // Returns false if Tok does not reference a parameter.
  auto expandArgument = [&](FormatToken *Tok) -> bool {
    // If the current token references a parameter, expand the corresponding
    // argument.
    if (!Tok->is(tok::identifier) || ExpandedArgs.contains(Tok->TokenText))
      return false;
    ExpandedArgs.insert(Tok->TokenText);
    auto I = Def.ArgMap.find(Tok->TokenText);
    if (I == Def.ArgMap.end())
      return false;
    // If there are fewer arguments than referenced parameters, treat the
    // parameter as empty.
    // FIXME: Potentially fully abort the expansion instead.
    if (I->getValue() >= Args.size())
      return true;
    for (FormatToken *Arg : Args[I->getValue()]) {
      // A token can be part of a macro argument at multiple levels.
      // For example, with "ID(x) x":
      // in ID(ID(x)), 'x' is expanded first as argument to the inner
      // ID, then again as argument to the outer ID. We keep the macro
      // role the token had from the inner expansion.
      if (!Arg->MacroCtx)
        Arg->MacroCtx = MacroExpansion(MR_ExpandedArg);
      pushToken(Arg);
    }
    return true;
  };

  // Expand the definition into Result.
  for (FormatToken *Tok : Def.Body) {
    if (expandArgument(Tok))
      continue;
    // Create a copy of the tokens from the macro body, i.e. were not provided
    // by user code.
    FormatToken *New = new (Allocator.Allocate()) FormatToken;
    New->copyFrom(*Tok);
    assert(!New->MacroCtx);
    // Tokens that are not part of the user code are not formatted.
    New->MacroCtx = MacroExpansion(MR_Hidden);
    pushToken(New);
  }
  assert(Result.size() >= 1 && Result.back()->is(tok::eof));
  if (Result.size() > 1) {
    ++Result[0]->MacroCtx->StartOfExpansion;
    ++Result[Result.size() - 2]->MacroCtx->EndOfExpansion;
  }
  return Result;
}

} // namespace format
} // namespace clang
