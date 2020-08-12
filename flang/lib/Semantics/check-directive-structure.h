//===-- lib/Semantics/check-directive-structure.h ---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// Directive structure validity checks common to OpenMP, OpenACC and other
// directive language.

#ifndef FORTRAN_SEMANTICS_CHECK_DIRECTIVE_STRUCTURE_H_
#define FORTRAN_SEMANTICS_CHECK_DIRECTIVE_STRUCTURE_H_

#include "flang/Common/enum-set.h"
#include "flang/Semantics/semantics.h"
#include "flang/Semantics/tools.h"

#include <unordered_map>

namespace Fortran::semantics {

template <typename C, std::size_t ClauseEnumSize> struct DirectiveClauses {
  const common::EnumSet<C, ClauseEnumSize> allowed;
  const common::EnumSet<C, ClauseEnumSize> allowedOnce;
  const common::EnumSet<C, ClauseEnumSize> allowedExclusive;
  const common::EnumSet<C, ClauseEnumSize> requiredOneOf;
};

// Generic structure checker for directives/clauses language such as OpenMP
// and OpenACC.
// typename D is the directive enumeration.
// tyepname C is the clause enumeration.
// typename PC is the parser class defined in parse-tree.h for the clauses.
template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
class DirectiveStructureChecker : public virtual BaseChecker {
protected:
  DirectiveStructureChecker(SemanticsContext &context,
      std::unordered_map<D, DirectiveClauses<C, ClauseEnumSize>>
          directiveClausesMap)
      : context_{context}, directiveClausesMap_(directiveClausesMap) {}
  virtual ~DirectiveStructureChecker() {}

  struct DirectiveContext {
    DirectiveContext(parser::CharBlock source, D d)
        : directiveSource{source}, directive{d} {}

    parser::CharBlock directiveSource{nullptr};
    parser::CharBlock clauseSource{nullptr};
    D directive;
    common::EnumSet<C, ClauseEnumSize> allowedClauses{};
    common::EnumSet<C, ClauseEnumSize> allowedOnceClauses{};
    common::EnumSet<C, ClauseEnumSize> allowedExclusiveClauses{};
    common::EnumSet<C, ClauseEnumSize> requiredClauses{};

    const PC *clause{nullptr};
    std::multimap<C, const PC *> clauseInfo;
    std::list<C> actualClauses;
  };

  // back() is the top of the stack
  DirectiveContext &GetContext() {
    CHECK(!dirContext_.empty());
    return dirContext_.back();
  }

  void SetContextClause(const PC &clause) {
    GetContext().clauseSource = clause.source;
    GetContext().clause = &clause;
  }

  void ResetPartialContext(const parser::CharBlock &source) {
    CHECK(!dirContext_.empty());
    SetContextDirectiveSource(source);
    GetContext().allowedClauses = {};
    GetContext().allowedOnceClauses = {};
    GetContext().allowedExclusiveClauses = {};
    GetContext().requiredClauses = {};
    GetContext().clauseInfo = {};
  }

  void SetContextDirectiveSource(const parser::CharBlock &directive) {
    GetContext().directiveSource = directive;
  }

  void SetContextDirectiveEnum(D dir) { GetContext().directive = dir; }

  void SetContextAllowed(const common::EnumSet<C, ClauseEnumSize> &allowed) {
    GetContext().allowedClauses = allowed;
  }

  void SetContextAllowedOnce(
      const common::EnumSet<C, ClauseEnumSize> &allowedOnce) {
    GetContext().allowedOnceClauses = allowedOnce;
  }

  void SetContextAllowedExclusive(
      const common::EnumSet<C, ClauseEnumSize> &allowedExclusive) {
    GetContext().allowedExclusiveClauses = allowedExclusive;
  }

  void SetContextRequired(const common::EnumSet<C, ClauseEnumSize> &required) {
    GetContext().requiredClauses = required;
  }

  void SetContextClauseInfo(C type) {
    GetContext().clauseInfo.emplace(type, GetContext().clause);
  }

  void AddClauseToCrtContext(C type) {
    GetContext().actualClauses.push_back(type);
  }

  const PC *FindClause(C type) {
    auto it{GetContext().clauseInfo.find(type)};
    if (it != GetContext().clauseInfo.end()) {
      return it->second;
    }
    return nullptr;
  }

  void PushContext(const parser::CharBlock &source, D dir) {
    dirContext_.emplace_back(source, dir);
  }

  bool CurrentDirectiveIsNested() { return dirContext_.size() > 0; };

  void SetClauseSets(D dir) {
    dirContext_.back().allowedClauses = directiveClausesMap_[dir].allowed;
    dirContext_.back().allowedOnceClauses =
        directiveClausesMap_[dir].allowedOnce;
    dirContext_.back().allowedExclusiveClauses =
        directiveClausesMap_[dir].allowedExclusive;
    dirContext_.back().requiredClauses =
        directiveClausesMap_[dir].requiredOneOf;
  }
  void PushContextAndClauseSets(const parser::CharBlock &source, D dir) {
    PushContext(source, dir);
    SetClauseSets(dir);
  }

  void SayNotMatching(const parser::CharBlock &, const parser::CharBlock &);

  template <typename B> void CheckMatching(const B &beginDir, const B &endDir) {
    const auto &begin{beginDir.v};
    const auto &end{endDir.v};
    if (begin != end) {
      SayNotMatching(beginDir.source, endDir.source);
    }
  }

  // Check that only clauses in set are after the specific clauses.
  void CheckOnlyAllowedAfter(C clause, common::EnumSet<C, ClauseEnumSize> set);

  void CheckRequired(C clause);

  void CheckRequireAtLeastOneOf();

  void CheckAllowed(C clause);

  void CheckAtLeastOneClause();

  void CheckNotAllowedIfClause(
      C clause, common::EnumSet<C, ClauseEnumSize> set);

  std::string ContextDirectiveAsFortran();

  void RequiresConstantPositiveParameter(
      const C &clause, const parser::ScalarIntConstantExpr &i);

  void RequiresPositiveParameter(
      const C &clause, const parser::ScalarIntExpr &i);

  void OptionalConstantPositiveParameter(
      const C &clause, const std::optional<parser::ScalarIntConstantExpr> &o);

  virtual llvm::StringRef getClauseName(C clause) { return ""; };

  virtual llvm::StringRef getDirectiveName(D directive) { return ""; };

  SemanticsContext &context_;
  std::vector<DirectiveContext> dirContext_; // used as a stack
  std::unordered_map<D, DirectiveClauses<C, ClauseEnumSize>>
      directiveClausesMap_;

  std::string ClauseSetToString(const common::EnumSet<C, ClauseEnumSize> set);
};

// Check that only clauses included in the given set are present after the given
// clause.
template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
void DirectiveStructureChecker<D, C, PC, ClauseEnumSize>::CheckOnlyAllowedAfter(
    C clause, common::EnumSet<C, ClauseEnumSize> set) {
  bool enforceCheck = false;
  for (auto cl : GetContext().actualClauses) {
    if (cl == clause) {
      enforceCheck = true;
      continue;
    } else if (enforceCheck && !set.test(cl)) {
      auto parserClause = GetContext().clauseInfo.find(cl);
      context_.Say(parserClause->second->source,
          "Clause %s is not allowed after clause %s on the %s "
          "directive"_err_en_US,
          parser::ToUpperCaseLetters(getClauseName(cl).str()),
          parser::ToUpperCaseLetters(getClauseName(clause).str()),
          ContextDirectiveAsFortran());
    }
  }
}

// Check that at least one clause is attached to the directive.
template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
void DirectiveStructureChecker<D, C, PC,
    ClauseEnumSize>::CheckAtLeastOneClause() {
  if (GetContext().actualClauses.empty()) {
    context_.Say(GetContext().directiveSource,
        "At least one clause is required on the %s directive"_err_en_US,
        ContextDirectiveAsFortran());
  }
}

template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
std::string
DirectiveStructureChecker<D, C, PC, ClauseEnumSize>::ClauseSetToString(
    const common::EnumSet<C, ClauseEnumSize> set) {
  std::string list;
  set.IterateOverMembers([&](C o) {
    if (!list.empty())
      list.append(", ");
    list.append(parser::ToUpperCaseLetters(getClauseName(o).str()));
  });
  return list;
}

// Check that at least one clause in the required set is present on the
// directive.
template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
void DirectiveStructureChecker<D, C, PC,
    ClauseEnumSize>::CheckRequireAtLeastOneOf() {
  for (auto cl : GetContext().actualClauses) {
    if (GetContext().requiredClauses.test(cl))
      return;
  }
  // No clause matched in the actual clauses list
  context_.Say(GetContext().directiveSource,
      "At least one of %s clause must appear on the %s directive"_err_en_US,
      ClauseSetToString(GetContext().requiredClauses),
      ContextDirectiveAsFortran());
}

template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
std::string DirectiveStructureChecker<D, C, PC,
    ClauseEnumSize>::ContextDirectiveAsFortran() {
  return parser::ToUpperCaseLetters(
      getDirectiveName(GetContext().directive).str());
}

// Check that clauses present on the directive are allowed clauses.
template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
void DirectiveStructureChecker<D, C, PC, ClauseEnumSize>::CheckAllowed(
    C clause) {
  if (!GetContext().allowedClauses.test(clause) &&
      !GetContext().allowedOnceClauses.test(clause) &&
      !GetContext().allowedExclusiveClauses.test(clause) &&
      !GetContext().requiredClauses.test(clause)) {
    context_.Say(GetContext().clauseSource,
        "%s clause is not allowed on the %s directive"_err_en_US,
        parser::ToUpperCaseLetters(getClauseName(clause).str()),
        parser::ToUpperCaseLetters(GetContext().directiveSource.ToString()));
    return;
  }
  if ((GetContext().allowedOnceClauses.test(clause) ||
          GetContext().allowedExclusiveClauses.test(clause)) &&
      FindClause(clause)) {
    context_.Say(GetContext().clauseSource,
        "At most one %s clause can appear on the %s directive"_err_en_US,
        parser::ToUpperCaseLetters(getClauseName(clause).str()),
        parser::ToUpperCaseLetters(GetContext().directiveSource.ToString()));
    return;
  }
  if (GetContext().allowedExclusiveClauses.test(clause)) {
    std::vector<C> others;
    GetContext().allowedExclusiveClauses.IterateOverMembers([&](C o) {
      if (FindClause(o)) {
        others.emplace_back(o);
      }
    });
    for (const auto &e : others) {
      context_.Say(GetContext().clauseSource,
          "%s and %s clauses are mutually exclusive and may not appear on the "
          "same %s directive"_err_en_US,
          parser::ToUpperCaseLetters(getClauseName(clause).str()),
          parser::ToUpperCaseLetters(getClauseName(e).str()),
          parser::ToUpperCaseLetters(GetContext().directiveSource.ToString()));
    }
    if (!others.empty()) {
      return;
    }
  }
  SetContextClauseInfo(clause);
  AddClauseToCrtContext(clause);
}

// Enforce restriction where clauses in the given set are not allowed if the
// given clause appears.
template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
void DirectiveStructureChecker<D, C, PC,
    ClauseEnumSize>::CheckNotAllowedIfClause(C clause,
    common::EnumSet<C, ClauseEnumSize> set) {
  if (std::find(GetContext().actualClauses.begin(),
          GetContext().actualClauses.end(),
          clause) == GetContext().actualClauses.end()) {
    return; // Clause is not present
  }

  for (auto cl : GetContext().actualClauses) {
    if (set.test(cl)) {
      context_.Say(GetContext().directiveSource,
          "Clause %s is not allowed if clause %s appears on the %s directive"_err_en_US,
          parser::ToUpperCaseLetters(getClauseName(cl).str()),
          parser::ToUpperCaseLetters(getClauseName(clause).str()),
          ContextDirectiveAsFortran());
    }
  }
}

// Check the value of the clause is a constant positive integer.
template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
void DirectiveStructureChecker<D, C, PC,
    ClauseEnumSize>::RequiresConstantPositiveParameter(const C &clause,
    const parser::ScalarIntConstantExpr &i) {
  if (const auto v{GetIntValue(i)}) {
    if (*v <= 0) {
      context_.Say(GetContext().clauseSource,
          "The parameter of the %s clause must be "
          "a constant positive integer expression"_err_en_US,
          parser::ToUpperCaseLetters(getClauseName(clause).str()));
    }
  }
}

// Check the value of the clause is a constant positive parameter.
template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
void DirectiveStructureChecker<D, C, PC,
    ClauseEnumSize>::OptionalConstantPositiveParameter(const C &clause,
    const std::optional<parser::ScalarIntConstantExpr> &o) {
  if (o != std::nullopt) {
    RequiresConstantPositiveParameter(clause, o.value());
  }
}

template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
void DirectiveStructureChecker<D, C, PC, ClauseEnumSize>::SayNotMatching(
    const parser::CharBlock &beginSource, const parser::CharBlock &endSource) {
  context_
      .Say(endSource, "Unmatched %s directive"_err_en_US,
          parser::ToUpperCaseLetters(endSource.ToString()))
      .Attach(beginSource, "Does not match directive"_en_US);
}

// Check that at least one of the required clauses is present on the directive.
template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
void DirectiveStructureChecker<D, C, PC, ClauseEnumSize>::CheckRequired(C c) {
  if (!FindClause(c)) {
    context_.Say(GetContext().directiveSource,
        "At least one %s clause must appear on the %s directive"_err_en_US,
        parser::ToUpperCaseLetters(getClauseName(c).str()),
        ContextDirectiveAsFortran());
  }
}

// Check the value of the clause is a positive parameter.
template <typename D, typename C, typename PC, std::size_t ClauseEnumSize>
void DirectiveStructureChecker<D, C, PC,
    ClauseEnumSize>::RequiresPositiveParameter(const C &clause,
    const parser::ScalarIntExpr &i) {
  if (const auto v{GetIntValue(i)}) {
    if (*v <= 0) {
      context_.Say(GetContext().clauseSource,
          "The parameter of the %s clause must be "
          "a positive integer expression"_err_en_US,
          parser::ToUpperCaseLetters(getClauseName(clause).str()));
    }
  }
}

} // namespace Fortran::semantics

#endif // FORTRAN_SEMANTICS_CHECK_DIRECTIVE_STRUCTURE_H_
