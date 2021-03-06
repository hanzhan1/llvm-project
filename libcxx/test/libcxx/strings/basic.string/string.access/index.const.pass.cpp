//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <string>

// const_reference operator[](size_type pos) const;

// UNSUPPORTED: libcxx-no-debug-mode

// ADDITIONAL_COMPILE_FLAGS: -D_LIBCPP_DEBUG=1

#include <string>
#include <cassert>

#include "test_macros.h"
#include "debug_macros.h"

int main(int, char**) {
    std::string const s;
    char c = s[0];
    assert(c == '\0');
    TEST_LIBCPP_ASSERT_FAILURE(s[1], "string index out of bounds");

    return 0;
}
