//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <unordered_map>

// template <class Key, class T, class Hash = hash<Key>, class Pred = equal_to<Key>,
//           class Alloc = allocator<pair<const Key, T>>>
// class unordered_multimap

// size_type bucket_size(size_type n) const

// UNSUPPORTED: libcxx-no-debug-mode

// ADDITIONAL_COMPILE_FLAGS: -D_LIBCPP_DEBUG=1

#include <unordered_map>
#include <string>

#include "test_macros.h"
#include "debug_macros.h"

int main(int, char**) {
    typedef std::unordered_multimap<int, std::string> C;
    C c;
    TEST_LIBCPP_ASSERT_FAILURE(c.bucket_size(3), "unordered container::bucket_size(n) called with n >= bucket_count()");

    return 0;
}
