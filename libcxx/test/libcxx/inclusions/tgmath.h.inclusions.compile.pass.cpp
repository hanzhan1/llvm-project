//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// WARNING: This test was generated by generate_header_inclusion_tests.py
// and should not be edited manually.
//
// clang-format off

// <tgmath.h>

// Test that <tgmath.h> includes all the other headers it's supposed to.

#include <tgmath.h>
#include "test_macros.h"

#if !defined(_LIBCPP_TGMATH_H)
 #   error "<tgmath.h> was expected to define _LIBCPP_TGMATH_H"
#endif
#if !defined(_LIBCPP_CMATH)
 #   error "<tgmath.h> should include <cmath> in C++03 and later"
#endif
#if !defined(_LIBCPP_COMPLEX)
 #   error "<tgmath.h> should include <complex> in C++03 and later"
#endif
