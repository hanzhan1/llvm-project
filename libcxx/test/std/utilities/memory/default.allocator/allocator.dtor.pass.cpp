//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// UNSUPPORTED: c++03, c++11, c++14, c++17

// template <class T>
// constexpr allocator<T>::~allocator();

#include <memory>


template <typename T>
constexpr bool test() {
    std::allocator<T> alloc;
    (void)alloc;

    // destructor called here
    return true;
}

int main(int, char**)
{
    test<int>();
    test<int const>();

    static_assert(test<int>());
    static_assert(test<int const>());

    return 0;
}
