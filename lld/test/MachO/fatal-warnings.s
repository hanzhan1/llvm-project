# REQUIRES: x86
# RUN: llvm-mc -filetype=obj -triple=x86_64-apple-darwin %s -o %t1.o

# RUN: %lld %t1.o -o /dev/null -single_module 2>&1 \
# RUN:     | FileCheck -check-prefix=WARNING %s
# RUN: not %lld %t1.o -fatal_warnings -o /dev/null -single_module 2>&1 \
# RUN:     | FileCheck -check-prefix=ERROR %s

# ERROR: error: Option `-single_module' is deprecated
# WARNING: warning: Option `-single_module' is deprecated

.globl _main
_main:
