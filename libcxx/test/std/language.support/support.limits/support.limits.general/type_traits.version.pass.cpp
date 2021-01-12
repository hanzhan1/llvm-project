//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// WARNING: This test was generated by generate_feature_test_macro_components.py
// and should not be edited manually.
//
// clang-format off

// <type_traits>

// Test the feature test macros defined by <type_traits>

/*  Constant                                       Value
    __cpp_lib_bool_constant                        201505L [C++17]
    __cpp_lib_bounded_array_traits                 201902L [C++20]
    __cpp_lib_has_unique_object_representations    201606L [C++17]
    __cpp_lib_integral_constant_callable           201304L [C++14]
    __cpp_lib_is_aggregate                         201703L [C++17]
    __cpp_lib_is_constant_evaluated                201811L [C++20]
    __cpp_lib_is_final                             201402L [C++14]
    __cpp_lib_is_invocable                         201703L [C++17]
    __cpp_lib_is_layout_compatible                 201907L [C++20]
    __cpp_lib_is_nothrow_convertible               201806L [C++20]
    __cpp_lib_is_null_pointer                      201309L [C++14]
    __cpp_lib_is_pointer_interconvertible          201907L [C++20]
    __cpp_lib_is_scoped_enum                       202011L [C++2b]
    __cpp_lib_is_swappable                         201603L [C++17]
    __cpp_lib_logical_traits                       201510L [C++17]
    __cpp_lib_remove_cvref                         201711L [C++20]
    __cpp_lib_result_of_sfinae                     201210L [C++14]
    __cpp_lib_transformation_trait_aliases         201304L [C++14]
    __cpp_lib_type_trait_variable_templates        201510L [C++17]
    __cpp_lib_void_t                               201411L [C++17]
*/

#include <type_traits>
#include "test_macros.h"

#if TEST_STD_VER < 14

# ifdef __cpp_lib_bool_constant
#   error "__cpp_lib_bool_constant should not be defined before c++17"
# endif

# ifdef __cpp_lib_bounded_array_traits
#   error "__cpp_lib_bounded_array_traits should not be defined before c++20"
# endif

# ifdef __cpp_lib_has_unique_object_representations
#   error "__cpp_lib_has_unique_object_representations should not be defined before c++17"
# endif

# ifdef __cpp_lib_integral_constant_callable
#   error "__cpp_lib_integral_constant_callable should not be defined before c++14"
# endif

# ifdef __cpp_lib_is_aggregate
#   error "__cpp_lib_is_aggregate should not be defined before c++17"
# endif

# ifdef __cpp_lib_is_constant_evaluated
#   error "__cpp_lib_is_constant_evaluated should not be defined before c++20"
# endif

# ifdef __cpp_lib_is_final
#   error "__cpp_lib_is_final should not be defined before c++14"
# endif

# ifdef __cpp_lib_is_invocable
#   error "__cpp_lib_is_invocable should not be defined before c++17"
# endif

# ifdef __cpp_lib_is_layout_compatible
#   error "__cpp_lib_is_layout_compatible should not be defined before c++20"
# endif

# ifdef __cpp_lib_is_nothrow_convertible
#   error "__cpp_lib_is_nothrow_convertible should not be defined before c++20"
# endif

# ifdef __cpp_lib_is_null_pointer
#   error "__cpp_lib_is_null_pointer should not be defined before c++14"
# endif

# ifdef __cpp_lib_is_pointer_interconvertible
#   error "__cpp_lib_is_pointer_interconvertible should not be defined before c++20"
# endif

# ifdef __cpp_lib_is_scoped_enum
#   error "__cpp_lib_is_scoped_enum should not be defined before c++2b"
# endif

# ifdef __cpp_lib_is_swappable
#   error "__cpp_lib_is_swappable should not be defined before c++17"
# endif

# ifdef __cpp_lib_logical_traits
#   error "__cpp_lib_logical_traits should not be defined before c++17"
# endif

# ifdef __cpp_lib_remove_cvref
#   error "__cpp_lib_remove_cvref should not be defined before c++20"
# endif

# ifdef __cpp_lib_result_of_sfinae
#   error "__cpp_lib_result_of_sfinae should not be defined before c++14"
# endif

# ifdef __cpp_lib_transformation_trait_aliases
#   error "__cpp_lib_transformation_trait_aliases should not be defined before c++14"
# endif

# ifdef __cpp_lib_type_trait_variable_templates
#   error "__cpp_lib_type_trait_variable_templates should not be defined before c++17"
# endif

# ifdef __cpp_lib_void_t
#   error "__cpp_lib_void_t should not be defined before c++17"
# endif

#elif TEST_STD_VER == 14

# ifdef __cpp_lib_bool_constant
#   error "__cpp_lib_bool_constant should not be defined before c++17"
# endif

# ifdef __cpp_lib_bounded_array_traits
#   error "__cpp_lib_bounded_array_traits should not be defined before c++20"
# endif

# ifdef __cpp_lib_has_unique_object_representations
#   error "__cpp_lib_has_unique_object_representations should not be defined before c++17"
# endif

# ifndef __cpp_lib_integral_constant_callable
#   error "__cpp_lib_integral_constant_callable should be defined in c++14"
# endif
# if __cpp_lib_integral_constant_callable != 201304L
#   error "__cpp_lib_integral_constant_callable should have the value 201304L in c++14"
# endif

# ifdef __cpp_lib_is_aggregate
#   error "__cpp_lib_is_aggregate should not be defined before c++17"
# endif

# ifdef __cpp_lib_is_constant_evaluated
#   error "__cpp_lib_is_constant_evaluated should not be defined before c++20"
# endif

# ifndef __cpp_lib_is_final
#   error "__cpp_lib_is_final should be defined in c++14"
# endif
# if __cpp_lib_is_final != 201402L
#   error "__cpp_lib_is_final should have the value 201402L in c++14"
# endif

# ifdef __cpp_lib_is_invocable
#   error "__cpp_lib_is_invocable should not be defined before c++17"
# endif

# ifdef __cpp_lib_is_layout_compatible
#   error "__cpp_lib_is_layout_compatible should not be defined before c++20"
# endif

# ifdef __cpp_lib_is_nothrow_convertible
#   error "__cpp_lib_is_nothrow_convertible should not be defined before c++20"
# endif

# ifndef __cpp_lib_is_null_pointer
#   error "__cpp_lib_is_null_pointer should be defined in c++14"
# endif
# if __cpp_lib_is_null_pointer != 201309L
#   error "__cpp_lib_is_null_pointer should have the value 201309L in c++14"
# endif

# ifdef __cpp_lib_is_pointer_interconvertible
#   error "__cpp_lib_is_pointer_interconvertible should not be defined before c++20"
# endif

# ifdef __cpp_lib_is_scoped_enum
#   error "__cpp_lib_is_scoped_enum should not be defined before c++2b"
# endif

# ifdef __cpp_lib_is_swappable
#   error "__cpp_lib_is_swappable should not be defined before c++17"
# endif

# ifdef __cpp_lib_logical_traits
#   error "__cpp_lib_logical_traits should not be defined before c++17"
# endif

# ifdef __cpp_lib_remove_cvref
#   error "__cpp_lib_remove_cvref should not be defined before c++20"
# endif

# ifndef __cpp_lib_result_of_sfinae
#   error "__cpp_lib_result_of_sfinae should be defined in c++14"
# endif
# if __cpp_lib_result_of_sfinae != 201210L
#   error "__cpp_lib_result_of_sfinae should have the value 201210L in c++14"
# endif

# ifndef __cpp_lib_transformation_trait_aliases
#   error "__cpp_lib_transformation_trait_aliases should be defined in c++14"
# endif
# if __cpp_lib_transformation_trait_aliases != 201304L
#   error "__cpp_lib_transformation_trait_aliases should have the value 201304L in c++14"
# endif

# ifdef __cpp_lib_type_trait_variable_templates
#   error "__cpp_lib_type_trait_variable_templates should not be defined before c++17"
# endif

# ifdef __cpp_lib_void_t
#   error "__cpp_lib_void_t should not be defined before c++17"
# endif

#elif TEST_STD_VER == 17

# ifndef __cpp_lib_bool_constant
#   error "__cpp_lib_bool_constant should be defined in c++17"
# endif
# if __cpp_lib_bool_constant != 201505L
#   error "__cpp_lib_bool_constant should have the value 201505L in c++17"
# endif

# ifdef __cpp_lib_bounded_array_traits
#   error "__cpp_lib_bounded_array_traits should not be defined before c++20"
# endif

# if TEST_HAS_BUILTIN_IDENTIFIER(__has_unique_object_representations) || TEST_GCC_VER >= 700
#   ifndef __cpp_lib_has_unique_object_representations
#     error "__cpp_lib_has_unique_object_representations should be defined in c++17"
#   endif
#   if __cpp_lib_has_unique_object_representations != 201606L
#     error "__cpp_lib_has_unique_object_representations should have the value 201606L in c++17"
#   endif
# else
#   ifdef __cpp_lib_has_unique_object_representations
#     error "__cpp_lib_has_unique_object_representations should not be defined when TEST_HAS_BUILTIN_IDENTIFIER(__has_unique_object_representations) || TEST_GCC_VER >= 700 is not defined!"
#   endif
# endif

# ifndef __cpp_lib_integral_constant_callable
#   error "__cpp_lib_integral_constant_callable should be defined in c++17"
# endif
# if __cpp_lib_integral_constant_callable != 201304L
#   error "__cpp_lib_integral_constant_callable should have the value 201304L in c++17"
# endif

# if TEST_HAS_BUILTIN_IDENTIFIER(__is_aggregate) || TEST_GCC_VER_NEW >= 7001
#   ifndef __cpp_lib_is_aggregate
#     error "__cpp_lib_is_aggregate should be defined in c++17"
#   endif
#   if __cpp_lib_is_aggregate != 201703L
#     error "__cpp_lib_is_aggregate should have the value 201703L in c++17"
#   endif
# else
#   ifdef __cpp_lib_is_aggregate
#     error "__cpp_lib_is_aggregate should not be defined when TEST_HAS_BUILTIN_IDENTIFIER(__is_aggregate) || TEST_GCC_VER_NEW >= 7001 is not defined!"
#   endif
# endif

# ifdef __cpp_lib_is_constant_evaluated
#   error "__cpp_lib_is_constant_evaluated should not be defined before c++20"
# endif

# ifndef __cpp_lib_is_final
#   error "__cpp_lib_is_final should be defined in c++17"
# endif
# if __cpp_lib_is_final != 201402L
#   error "__cpp_lib_is_final should have the value 201402L in c++17"
# endif

# ifndef __cpp_lib_is_invocable
#   error "__cpp_lib_is_invocable should be defined in c++17"
# endif
# if __cpp_lib_is_invocable != 201703L
#   error "__cpp_lib_is_invocable should have the value 201703L in c++17"
# endif

# ifdef __cpp_lib_is_layout_compatible
#   error "__cpp_lib_is_layout_compatible should not be defined before c++20"
# endif

# ifdef __cpp_lib_is_nothrow_convertible
#   error "__cpp_lib_is_nothrow_convertible should not be defined before c++20"
# endif

# ifndef __cpp_lib_is_null_pointer
#   error "__cpp_lib_is_null_pointer should be defined in c++17"
# endif
# if __cpp_lib_is_null_pointer != 201309L
#   error "__cpp_lib_is_null_pointer should have the value 201309L in c++17"
# endif

# ifdef __cpp_lib_is_pointer_interconvertible
#   error "__cpp_lib_is_pointer_interconvertible should not be defined before c++20"
# endif

# ifdef __cpp_lib_is_scoped_enum
#   error "__cpp_lib_is_scoped_enum should not be defined before c++2b"
# endif

# ifndef __cpp_lib_is_swappable
#   error "__cpp_lib_is_swappable should be defined in c++17"
# endif
# if __cpp_lib_is_swappable != 201603L
#   error "__cpp_lib_is_swappable should have the value 201603L in c++17"
# endif

# ifndef __cpp_lib_logical_traits
#   error "__cpp_lib_logical_traits should be defined in c++17"
# endif
# if __cpp_lib_logical_traits != 201510L
#   error "__cpp_lib_logical_traits should have the value 201510L in c++17"
# endif

# ifdef __cpp_lib_remove_cvref
#   error "__cpp_lib_remove_cvref should not be defined before c++20"
# endif

# ifndef __cpp_lib_result_of_sfinae
#   error "__cpp_lib_result_of_sfinae should be defined in c++17"
# endif
# if __cpp_lib_result_of_sfinae != 201210L
#   error "__cpp_lib_result_of_sfinae should have the value 201210L in c++17"
# endif

# ifndef __cpp_lib_transformation_trait_aliases
#   error "__cpp_lib_transformation_trait_aliases should be defined in c++17"
# endif
# if __cpp_lib_transformation_trait_aliases != 201304L
#   error "__cpp_lib_transformation_trait_aliases should have the value 201304L in c++17"
# endif

# ifndef __cpp_lib_type_trait_variable_templates
#   error "__cpp_lib_type_trait_variable_templates should be defined in c++17"
# endif
# if __cpp_lib_type_trait_variable_templates != 201510L
#   error "__cpp_lib_type_trait_variable_templates should have the value 201510L in c++17"
# endif

# ifndef __cpp_lib_void_t
#   error "__cpp_lib_void_t should be defined in c++17"
# endif
# if __cpp_lib_void_t != 201411L
#   error "__cpp_lib_void_t should have the value 201411L in c++17"
# endif

#elif TEST_STD_VER == 20

# ifndef __cpp_lib_bool_constant
#   error "__cpp_lib_bool_constant should be defined in c++20"
# endif
# if __cpp_lib_bool_constant != 201505L
#   error "__cpp_lib_bool_constant should have the value 201505L in c++20"
# endif

# ifndef __cpp_lib_bounded_array_traits
#   error "__cpp_lib_bounded_array_traits should be defined in c++20"
# endif
# if __cpp_lib_bounded_array_traits != 201902L
#   error "__cpp_lib_bounded_array_traits should have the value 201902L in c++20"
# endif

# if TEST_HAS_BUILTIN_IDENTIFIER(__has_unique_object_representations) || TEST_GCC_VER >= 700
#   ifndef __cpp_lib_has_unique_object_representations
#     error "__cpp_lib_has_unique_object_representations should be defined in c++20"
#   endif
#   if __cpp_lib_has_unique_object_representations != 201606L
#     error "__cpp_lib_has_unique_object_representations should have the value 201606L in c++20"
#   endif
# else
#   ifdef __cpp_lib_has_unique_object_representations
#     error "__cpp_lib_has_unique_object_representations should not be defined when TEST_HAS_BUILTIN_IDENTIFIER(__has_unique_object_representations) || TEST_GCC_VER >= 700 is not defined!"
#   endif
# endif

# ifndef __cpp_lib_integral_constant_callable
#   error "__cpp_lib_integral_constant_callable should be defined in c++20"
# endif
# if __cpp_lib_integral_constant_callable != 201304L
#   error "__cpp_lib_integral_constant_callable should have the value 201304L in c++20"
# endif

# if TEST_HAS_BUILTIN_IDENTIFIER(__is_aggregate) || TEST_GCC_VER_NEW >= 7001
#   ifndef __cpp_lib_is_aggregate
#     error "__cpp_lib_is_aggregate should be defined in c++20"
#   endif
#   if __cpp_lib_is_aggregate != 201703L
#     error "__cpp_lib_is_aggregate should have the value 201703L in c++20"
#   endif
# else
#   ifdef __cpp_lib_is_aggregate
#     error "__cpp_lib_is_aggregate should not be defined when TEST_HAS_BUILTIN_IDENTIFIER(__is_aggregate) || TEST_GCC_VER_NEW >= 7001 is not defined!"
#   endif
# endif

# if TEST_HAS_BUILTIN(__builtin_is_constant_evaluated) || TEST_GCC_VER >= 900
#   ifndef __cpp_lib_is_constant_evaluated
#     error "__cpp_lib_is_constant_evaluated should be defined in c++20"
#   endif
#   if __cpp_lib_is_constant_evaluated != 201811L
#     error "__cpp_lib_is_constant_evaluated should have the value 201811L in c++20"
#   endif
# else
#   ifdef __cpp_lib_is_constant_evaluated
#     error "__cpp_lib_is_constant_evaluated should not be defined when TEST_HAS_BUILTIN(__builtin_is_constant_evaluated) || TEST_GCC_VER >= 900 is not defined!"
#   endif
# endif

# ifndef __cpp_lib_is_final
#   error "__cpp_lib_is_final should be defined in c++20"
# endif
# if __cpp_lib_is_final != 201402L
#   error "__cpp_lib_is_final should have the value 201402L in c++20"
# endif

# ifndef __cpp_lib_is_invocable
#   error "__cpp_lib_is_invocable should be defined in c++20"
# endif
# if __cpp_lib_is_invocable != 201703L
#   error "__cpp_lib_is_invocable should have the value 201703L in c++20"
# endif

# if !defined(_LIBCPP_VERSION)
#   ifndef __cpp_lib_is_layout_compatible
#     error "__cpp_lib_is_layout_compatible should be defined in c++20"
#   endif
#   if __cpp_lib_is_layout_compatible != 201907L
#     error "__cpp_lib_is_layout_compatible should have the value 201907L in c++20"
#   endif
# else // _LIBCPP_VERSION
#   ifdef __cpp_lib_is_layout_compatible
#     error "__cpp_lib_is_layout_compatible should not be defined because it is unimplemented in libc++!"
#   endif
# endif

# ifndef __cpp_lib_is_nothrow_convertible
#   error "__cpp_lib_is_nothrow_convertible should be defined in c++20"
# endif
# if __cpp_lib_is_nothrow_convertible != 201806L
#   error "__cpp_lib_is_nothrow_convertible should have the value 201806L in c++20"
# endif

# ifndef __cpp_lib_is_null_pointer
#   error "__cpp_lib_is_null_pointer should be defined in c++20"
# endif
# if __cpp_lib_is_null_pointer != 201309L
#   error "__cpp_lib_is_null_pointer should have the value 201309L in c++20"
# endif

# if !defined(_LIBCPP_VERSION)
#   ifndef __cpp_lib_is_pointer_interconvertible
#     error "__cpp_lib_is_pointer_interconvertible should be defined in c++20"
#   endif
#   if __cpp_lib_is_pointer_interconvertible != 201907L
#     error "__cpp_lib_is_pointer_interconvertible should have the value 201907L in c++20"
#   endif
# else // _LIBCPP_VERSION
#   ifdef __cpp_lib_is_pointer_interconvertible
#     error "__cpp_lib_is_pointer_interconvertible should not be defined because it is unimplemented in libc++!"
#   endif
# endif

# ifdef __cpp_lib_is_scoped_enum
#   error "__cpp_lib_is_scoped_enum should not be defined before c++2b"
# endif

# ifndef __cpp_lib_is_swappable
#   error "__cpp_lib_is_swappable should be defined in c++20"
# endif
# if __cpp_lib_is_swappable != 201603L
#   error "__cpp_lib_is_swappable should have the value 201603L in c++20"
# endif

# ifndef __cpp_lib_logical_traits
#   error "__cpp_lib_logical_traits should be defined in c++20"
# endif
# if __cpp_lib_logical_traits != 201510L
#   error "__cpp_lib_logical_traits should have the value 201510L in c++20"
# endif

# ifndef __cpp_lib_remove_cvref
#   error "__cpp_lib_remove_cvref should be defined in c++20"
# endif
# if __cpp_lib_remove_cvref != 201711L
#   error "__cpp_lib_remove_cvref should have the value 201711L in c++20"
# endif

# ifndef __cpp_lib_result_of_sfinae
#   error "__cpp_lib_result_of_sfinae should be defined in c++20"
# endif
# if __cpp_lib_result_of_sfinae != 201210L
#   error "__cpp_lib_result_of_sfinae should have the value 201210L in c++20"
# endif

# ifndef __cpp_lib_transformation_trait_aliases
#   error "__cpp_lib_transformation_trait_aliases should be defined in c++20"
# endif
# if __cpp_lib_transformation_trait_aliases != 201304L
#   error "__cpp_lib_transformation_trait_aliases should have the value 201304L in c++20"
# endif

# ifndef __cpp_lib_type_trait_variable_templates
#   error "__cpp_lib_type_trait_variable_templates should be defined in c++20"
# endif
# if __cpp_lib_type_trait_variable_templates != 201510L
#   error "__cpp_lib_type_trait_variable_templates should have the value 201510L in c++20"
# endif

# ifndef __cpp_lib_void_t
#   error "__cpp_lib_void_t should be defined in c++20"
# endif
# if __cpp_lib_void_t != 201411L
#   error "__cpp_lib_void_t should have the value 201411L in c++20"
# endif

#elif TEST_STD_VER > 20

# ifndef __cpp_lib_bool_constant
#   error "__cpp_lib_bool_constant should be defined in c++2b"
# endif
# if __cpp_lib_bool_constant != 201505L
#   error "__cpp_lib_bool_constant should have the value 201505L in c++2b"
# endif

# ifndef __cpp_lib_bounded_array_traits
#   error "__cpp_lib_bounded_array_traits should be defined in c++2b"
# endif
# if __cpp_lib_bounded_array_traits != 201902L
#   error "__cpp_lib_bounded_array_traits should have the value 201902L in c++2b"
# endif

# if TEST_HAS_BUILTIN_IDENTIFIER(__has_unique_object_representations) || TEST_GCC_VER >= 700
#   ifndef __cpp_lib_has_unique_object_representations
#     error "__cpp_lib_has_unique_object_representations should be defined in c++2b"
#   endif
#   if __cpp_lib_has_unique_object_representations != 201606L
#     error "__cpp_lib_has_unique_object_representations should have the value 201606L in c++2b"
#   endif
# else
#   ifdef __cpp_lib_has_unique_object_representations
#     error "__cpp_lib_has_unique_object_representations should not be defined when TEST_HAS_BUILTIN_IDENTIFIER(__has_unique_object_representations) || TEST_GCC_VER >= 700 is not defined!"
#   endif
# endif

# ifndef __cpp_lib_integral_constant_callable
#   error "__cpp_lib_integral_constant_callable should be defined in c++2b"
# endif
# if __cpp_lib_integral_constant_callable != 201304L
#   error "__cpp_lib_integral_constant_callable should have the value 201304L in c++2b"
# endif

# if TEST_HAS_BUILTIN_IDENTIFIER(__is_aggregate) || TEST_GCC_VER_NEW >= 7001
#   ifndef __cpp_lib_is_aggregate
#     error "__cpp_lib_is_aggregate should be defined in c++2b"
#   endif
#   if __cpp_lib_is_aggregate != 201703L
#     error "__cpp_lib_is_aggregate should have the value 201703L in c++2b"
#   endif
# else
#   ifdef __cpp_lib_is_aggregate
#     error "__cpp_lib_is_aggregate should not be defined when TEST_HAS_BUILTIN_IDENTIFIER(__is_aggregate) || TEST_GCC_VER_NEW >= 7001 is not defined!"
#   endif
# endif

# if TEST_HAS_BUILTIN(__builtin_is_constant_evaluated) || TEST_GCC_VER >= 900
#   ifndef __cpp_lib_is_constant_evaluated
#     error "__cpp_lib_is_constant_evaluated should be defined in c++2b"
#   endif
#   if __cpp_lib_is_constant_evaluated != 201811L
#     error "__cpp_lib_is_constant_evaluated should have the value 201811L in c++2b"
#   endif
# else
#   ifdef __cpp_lib_is_constant_evaluated
#     error "__cpp_lib_is_constant_evaluated should not be defined when TEST_HAS_BUILTIN(__builtin_is_constant_evaluated) || TEST_GCC_VER >= 900 is not defined!"
#   endif
# endif

# ifndef __cpp_lib_is_final
#   error "__cpp_lib_is_final should be defined in c++2b"
# endif
# if __cpp_lib_is_final != 201402L
#   error "__cpp_lib_is_final should have the value 201402L in c++2b"
# endif

# ifndef __cpp_lib_is_invocable
#   error "__cpp_lib_is_invocable should be defined in c++2b"
# endif
# if __cpp_lib_is_invocable != 201703L
#   error "__cpp_lib_is_invocable should have the value 201703L in c++2b"
# endif

# if !defined(_LIBCPP_VERSION)
#   ifndef __cpp_lib_is_layout_compatible
#     error "__cpp_lib_is_layout_compatible should be defined in c++2b"
#   endif
#   if __cpp_lib_is_layout_compatible != 201907L
#     error "__cpp_lib_is_layout_compatible should have the value 201907L in c++2b"
#   endif
# else // _LIBCPP_VERSION
#   ifdef __cpp_lib_is_layout_compatible
#     error "__cpp_lib_is_layout_compatible should not be defined because it is unimplemented in libc++!"
#   endif
# endif

# ifndef __cpp_lib_is_nothrow_convertible
#   error "__cpp_lib_is_nothrow_convertible should be defined in c++2b"
# endif
# if __cpp_lib_is_nothrow_convertible != 201806L
#   error "__cpp_lib_is_nothrow_convertible should have the value 201806L in c++2b"
# endif

# ifndef __cpp_lib_is_null_pointer
#   error "__cpp_lib_is_null_pointer should be defined in c++2b"
# endif
# if __cpp_lib_is_null_pointer != 201309L
#   error "__cpp_lib_is_null_pointer should have the value 201309L in c++2b"
# endif

# if !defined(_LIBCPP_VERSION)
#   ifndef __cpp_lib_is_pointer_interconvertible
#     error "__cpp_lib_is_pointer_interconvertible should be defined in c++2b"
#   endif
#   if __cpp_lib_is_pointer_interconvertible != 201907L
#     error "__cpp_lib_is_pointer_interconvertible should have the value 201907L in c++2b"
#   endif
# else // _LIBCPP_VERSION
#   ifdef __cpp_lib_is_pointer_interconvertible
#     error "__cpp_lib_is_pointer_interconvertible should not be defined because it is unimplemented in libc++!"
#   endif
# endif

#ifndef __cpp_lib_is_scoped_enum
#error "__cpp_lib_is_scoped_enum should be defined in c++2b"
#endif
#if __cpp_lib_is_scoped_enum != 202011L
#error "__cpp_lib_is_scoped_enum should have the value 202011L in c++2b"
# endif

# ifndef __cpp_lib_is_swappable
#   error "__cpp_lib_is_swappable should be defined in c++2b"
# endif
# if __cpp_lib_is_swappable != 201603L
#   error "__cpp_lib_is_swappable should have the value 201603L in c++2b"
# endif

# ifndef __cpp_lib_logical_traits
#   error "__cpp_lib_logical_traits should be defined in c++2b"
# endif
# if __cpp_lib_logical_traits != 201510L
#   error "__cpp_lib_logical_traits should have the value 201510L in c++2b"
# endif

# ifndef __cpp_lib_remove_cvref
#   error "__cpp_lib_remove_cvref should be defined in c++2b"
# endif
# if __cpp_lib_remove_cvref != 201711L
#   error "__cpp_lib_remove_cvref should have the value 201711L in c++2b"
# endif

# ifndef __cpp_lib_result_of_sfinae
#   error "__cpp_lib_result_of_sfinae should be defined in c++2b"
# endif
# if __cpp_lib_result_of_sfinae != 201210L
#   error "__cpp_lib_result_of_sfinae should have the value 201210L in c++2b"
# endif

# ifndef __cpp_lib_transformation_trait_aliases
#   error "__cpp_lib_transformation_trait_aliases should be defined in c++2b"
# endif
# if __cpp_lib_transformation_trait_aliases != 201304L
#   error "__cpp_lib_transformation_trait_aliases should have the value 201304L in c++2b"
# endif

# ifndef __cpp_lib_type_trait_variable_templates
#   error "__cpp_lib_type_trait_variable_templates should be defined in c++2b"
# endif
# if __cpp_lib_type_trait_variable_templates != 201510L
#   error "__cpp_lib_type_trait_variable_templates should have the value 201510L in c++2b"
# endif

# ifndef __cpp_lib_void_t
#   error "__cpp_lib_void_t should be defined in c++2b"
# endif
# if __cpp_lib_void_t != 201411L
#   error "__cpp_lib_void_t should have the value 201411L in c++2b"
# endif

#endif // TEST_STD_VER > 20

int main(int, char**) { return 0; }
