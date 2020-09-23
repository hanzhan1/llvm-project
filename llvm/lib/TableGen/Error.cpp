//===- Error.cpp - tblgen error handling helper routines --------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file contains error handling helper routines to pretty-print diagnostic
// messages from tblgen.
//
//===----------------------------------------------------------------------===//

#include "llvm/ADT/Twine.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/Signals.h"
#include "llvm/Support/WithColor.h"
#include "llvm/TableGen/Error.h"
#include "llvm/TableGen/Record.h"
#include <cstdlib>

namespace llvm {

SourceMgr SrcMgr;
unsigned ErrorsPrinted = 0;

static void PrintMessage(ArrayRef<SMLoc> Loc, SourceMgr::DiagKind Kind,
                         const Twine &Msg) {
  // Count the total number of errors printed.
  // This is used to exit with an error code if there were any errors.
  if (Kind == SourceMgr::DK_Error)
    ++ErrorsPrinted;

  SMLoc NullLoc;
  if (Loc.empty())
    Loc = NullLoc;
  SrcMgr.PrintMessage(Loc.front(), Kind, Msg);
  for (unsigned i = 1; i < Loc.size(); ++i)
    SrcMgr.PrintMessage(Loc[i], SourceMgr::DK_Note,
                        "instantiated from multiclass");
}

void PrintNote(const Twine &Msg) { WithColor::note() << Msg << "\n"; }

void PrintNote(ArrayRef<SMLoc> NoteLoc, const Twine &Msg) {
  PrintMessage(NoteLoc, SourceMgr::DK_Note, Msg);
}

void PrintFatalNote(ArrayRef<SMLoc> NoteLoc, const Twine &Msg) {
  PrintNote(NoteLoc, Msg);
  // The following call runs the file cleanup handlers.
  sys::RunInterruptHandlers();
  std::exit(1);
}

void PrintWarning(ArrayRef<SMLoc> WarningLoc, const Twine &Msg) {
  PrintMessage(WarningLoc, SourceMgr::DK_Warning, Msg);
}

void PrintWarning(const char *Loc, const Twine &Msg) {
  SrcMgr.PrintMessage(SMLoc::getFromPointer(Loc), SourceMgr::DK_Warning, Msg);
}

void PrintWarning(const Twine &Msg) { WithColor::warning() << Msg << "\n"; }

void PrintError(ArrayRef<SMLoc> ErrorLoc, const Twine &Msg) {
  PrintMessage(ErrorLoc, SourceMgr::DK_Error, Msg);
}

void PrintError(const char *Loc, const Twine &Msg) {
  SrcMgr.PrintMessage(SMLoc::getFromPointer(Loc), SourceMgr::DK_Error, Msg);
}

void PrintError(const Twine &Msg) { WithColor::error() << Msg << "\n"; }

void PrintFatalError(const Twine &Msg) {
  PrintError(Msg);
  // The following call runs the file cleanup handlers.
  sys::RunInterruptHandlers();
  std::exit(1);
}

void PrintFatalError(ArrayRef<SMLoc> ErrorLoc, const Twine &Msg) {
  PrintError(ErrorLoc, Msg);
  // The following call runs the file cleanup handlers.
  sys::RunInterruptHandlers();
  std::exit(1);
}

// This method takes a Record and uses the source location
// stored in it.
void PrintFatalError(const Record *Rec, const Twine &Msg) {
  PrintError(Rec->getLoc(), Msg);
  // The following call runs the file cleanup handlers.
  sys::RunInterruptHandlers();
  std::exit(1);
}

// This method takes a RecordVal and uses the source location
// stored in it.
void PrintFatalError(const RecordVal *RecVal, const Twine &Msg) {
  PrintError(RecVal->getLoc(), Msg);
  // The following call runs the file cleanup handlers.
  sys::RunInterruptHandlers();
  std::exit(1);
}

} // end namespace llvm
