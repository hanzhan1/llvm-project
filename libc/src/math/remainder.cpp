//===-- Implementation of remainder function ------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "src/math/remainder.h"
#include "src/__support/common.h"
#include "utils/FPUtil/DivisionAndRemainderOperations.h"

namespace __llvm_libc {

LLVM_LIBC_FUNCTION(double, remainder, (double x, double y)) {
  int quotient;
  return fputil::remquo(x, y, quotient);
}

} // namespace __llvm_libc
