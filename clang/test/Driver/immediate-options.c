// RUN: %clang --help | FileCheck %s -check-prefix=HELP
// HELP: isystem
// HELP-NOT: ast-dump
// HELP-NOT: driver-mode

// Make sure that Flang-only options are not available in Clang
// HELP-NOT: test-io

// RUN: %clang --help-hidden | FileCheck %s -check-prefix=HELP-HIDDEN
// HELP-HIDDEN: driver-mode
// HELP-HIDDEN-NOT: test-io

// RUN: %clang -dumpversion | FileCheck %s -check-prefix=DUMPVERSION
// DUMPVERSION: {{[0-9]+\.[0-9.]+}}

// Test if the -print-resource-dir option is accepted without error.
// Allow unspecified output because the value of CLANG_RESOURCE_DIR is unknown.
// RUN: %clang -print-resource-dir | FileCheck %s -check-prefix=PRINT-RESOURCE-DIR
// PRINT-RESOURCE-DIR: {{.+}}
