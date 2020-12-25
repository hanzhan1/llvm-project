//===- AsyncRuntime.h - Async runtime reference implementation ------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file declares basic Async runtime API for supporting Async dialect
// to LLVM dialect lowering.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_EXECUTIONENGINE_ASYNCRUNTIME_H_
#define MLIR_EXECUTIONENGINE_ASYNCRUNTIME_H_

#include <stdint.h>

#ifdef _WIN32
#ifndef MLIR_ASYNCRUNTIME_EXPORT
#ifdef mlir_async_runtime_EXPORTS
// We are building this library
#define MLIR_ASYNCRUNTIME_EXPORT __declspec(dllexport)
#define MLIR_ASYNCRUNTIME_DEFINE_FUNCTIONS
#else
// We are using this library
#define MLIR_ASYNCRUNTIME_EXPORT __declspec(dllimport)
#endif // mlir_async_runtime_EXPORTS
#endif // MLIR_ASYNCRUNTIME_EXPORT
#else
#define MLIR_ASYNCRUNTIME_EXPORT
#define MLIR_ASYNCRUNTIME_DEFINE_FUNCTIONS
#endif // _WIN32

namespace mlir {
namespace runtime {

//===----------------------------------------------------------------------===//
// Async runtime API.
//===----------------------------------------------------------------------===//

// Runtime implementation of `async.token` data type.
typedef struct AsyncToken AsyncToken;

// Runtime implementation of `async.group` data type.
typedef struct AsyncGroup AsyncGroup;

// Runtime implementation of `async.value` data type.
typedef struct AsyncValue AsyncValue;

// Async value payload stored in a memory owned by the async.value.
using ValueStorage = void *;

// Async runtime uses LLVM coroutines to represent asynchronous tasks. Task
// function is a coroutine handle and a resume function that continue coroutine
// execution from a suspension point.
using CoroHandle = void *;           // coroutine handle
using CoroResume = void (*)(void *); // coroutine resume function

// Async runtime uses reference counting to manage the lifetime of async values
// (values of async types like tokens, values and groups).
using RefCountedObjPtr = void *;

// Adds references to reference counted runtime object.
extern "C" MLIR_ASYNCRUNTIME_EXPORT void
    mlirAsyncRuntimeAddRef(RefCountedObjPtr, int32_t);

// Drops references from reference counted runtime object.
extern "C" MLIR_ASYNCRUNTIME_EXPORT void
    mlirAsyncRuntimeDropRef(RefCountedObjPtr, int32_t);

// Create a new `async.token` in not-ready state.
extern "C" MLIR_ASYNCRUNTIME_EXPORT AsyncToken *mlirAsyncRuntimeCreateToken();

// Create a new `async.value` in not-ready state. Size parameter specifies the
// number of bytes that will be allocated for the async value storage. Storage
// is owned by the `async.value` and deallocated when the async value is
// destructed (reference count drops to zero).
extern "C" MLIR_ASYNCRUNTIME_EXPORT AsyncValue *
    mlirAsyncRuntimeCreateValue(int32_t);

// Create a new `async.group` in empty state.
extern "C" MLIR_ASYNCRUNTIME_EXPORT AsyncGroup *mlirAsyncRuntimeCreateGroup();

extern "C" MLIR_ASYNCRUNTIME_EXPORT int64_t
mlirAsyncRuntimeAddTokenToGroup(AsyncToken *, AsyncGroup *);

// Switches `async.token` to ready state and runs all awaiters.
extern "C" MLIR_ASYNCRUNTIME_EXPORT void
mlirAsyncRuntimeEmplaceToken(AsyncToken *);

// Switches `async.value` to ready state and runs all awaiters.
extern "C" MLIR_ASYNCRUNTIME_EXPORT void
mlirAsyncRuntimeEmplaceValue(AsyncValue *);

// Blocks the caller thread until the token becomes ready.
extern "C" MLIR_ASYNCRUNTIME_EXPORT void
mlirAsyncRuntimeAwaitToken(AsyncToken *);

// Blocks the caller thread until the value becomes ready.
extern "C" MLIR_ASYNCRUNTIME_EXPORT void
mlirAsyncRuntimeAwaitValue(AsyncValue *);

// Blocks the caller thread until the elements in the group become ready.
extern "C" MLIR_ASYNCRUNTIME_EXPORT void
mlirAsyncRuntimeAwaitAllInGroup(AsyncGroup *);

// Returns a pointer to the storage owned by the async value.
extern "C" MLIR_ASYNCRUNTIME_EXPORT ValueStorage
mlirAsyncRuntimeGetValueStorage(AsyncValue *);

// Executes the task (coro handle + resume function) in one of the threads
// managed by the runtime.
extern "C" MLIR_ASYNCRUNTIME_EXPORT void mlirAsyncRuntimeExecute(CoroHandle,
                                                                 CoroResume);

// Executes the task (coro handle + resume function) in one of the threads
// managed by the runtime after the token becomes ready.
extern "C" MLIR_ASYNCRUNTIME_EXPORT void
mlirAsyncRuntimeAwaitTokenAndExecute(AsyncToken *, CoroHandle, CoroResume);

// Executes the task (coro handle + resume function) in one of the threads
// managed by the runtime after the value becomes ready.
extern "C" MLIR_ASYNCRUNTIME_EXPORT void
mlirAsyncRuntimeAwaitValueAndExecute(AsyncValue *, CoroHandle, CoroResume);

// Executes the task (coro handle + resume function) in one of the threads
// managed by the runtime after the all members of the group become ready.
extern "C" MLIR_ASYNCRUNTIME_EXPORT void
mlirAsyncRuntimeAwaitAllInGroupAndExecute(AsyncGroup *, CoroHandle, CoroResume);

//===----------------------------------------------------------------------===//
// Small async runtime support library for testing.
//===----------------------------------------------------------------------===//

extern "C" MLIR_ASYNCRUNTIME_EXPORT void mlirAsyncRuntimePrintCurrentThreadId();

} // namespace runtime
} // namespace mlir

#endif // MLIR_EXECUTIONENGINE_ASYNCRUNTIME_H_
