; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefix=X32

; shift left

define i32 @and_signbit_shl(i32 %x, i32* %dst) {
; X64-LABEL: and_signbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    andl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: and_signbit_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shll $24, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 4294901760 ; 0xFFFF0000
  %r = shl i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @and_nosignbit_shl(i32 %x, i32* %dst) {
; X64-LABEL: and_nosignbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    andl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: and_nosignbit_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shll $24, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 2147418112 ; 0x7FFF0000
  %r = shl i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}

define i32 @or_signbit_shl(i32 %x, i32* %dst) {
; X64-LABEL: or_signbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    orl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: or_signbit_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    orl $-16777216, %eax # imm = 0xFF000000
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 4294901760 ; 0xFFFF0000
  %r = shl i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @or_nosignbit_shl(i32 %x, i32* %dst) {
; X64-LABEL: or_nosignbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    orl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: or_nosignbit_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    orl $-16777216, %eax # imm = 0xFF000000
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 2147418112 ; 0x7FFF0000
  %r = shl i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}

define i32 @xor_signbit_shl(i32 %x, i32* %dst) {
; X64-LABEL: xor_signbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    xorl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: xor_signbit_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $16711680, %eax # imm = 0xFF0000
; X32-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 4294901760 ; 0xFFFF0000
  %r = shl i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @xor_nosignbit_shl(i32 %x, i32* %dst) {
; X64-LABEL: xor_nosignbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    xorl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: xor_nosignbit_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $16711680, %eax # imm = 0xFF0000
; X32-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 2147418112 ; 0x7FFF0000
  %r = shl i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}

define i32 @add_signbit_shl(i32 %x, i32* %dst) {
; X64-LABEL: add_signbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    addl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: add_signbit_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    addl $-16777216, %eax # imm = 0xFF000000
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 4294901760 ; 0xFFFF0000
  %r = shl i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @add_nosignbit_shl(i32 %x, i32* %dst) {
; X64-LABEL: add_nosignbit_shl:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll $8, %eax
; X64-NEXT:    addl $-16777216, %eax # imm = 0xFF000000
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: add_nosignbit_shl:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    addl $-16777216, %eax # imm = 0xFF000000
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 2147418112 ; 0x7FFF0000
  %r = shl i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}

; logical shift right

define i32 @and_signbit_lshr(i32 %x, i32* %dst) {
; X64-LABEL: and_signbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    andl $16776960, %eax # imm = 0xFFFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: and_signbit_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shll $16, %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 4294901760 ; 0xFFFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @and_nosignbit_lshr(i32 %x, i32* %dst) {
; X64-LABEL: and_nosignbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    andl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: and_nosignbit_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 2147418112 ; 0x7FFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}

define i32 @or_signbit_lshr(i32 %x, i32* %dst) {
; X64-LABEL: or_signbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    orl $16776960, %eax # imm = 0xFFFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: or_signbit_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:    orl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 4294901760 ; 0xFFFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @or_nosignbit_lshr(i32 %x, i32* %dst) {
; X64-LABEL: or_nosignbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    orl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: or_nosignbit_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:    orl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 2147418112 ; 0x7FFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}

define i32 @xor_signbit_lshr(i32 %x, i32* %dst) {
; X64-LABEL: xor_signbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    xorl $16776960, %eax # imm = 0xFFFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: xor_signbit_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 4294901760 ; 0xFFFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @xor_nosignbit_lshr(i32 %x, i32* %dst) {
; X64-LABEL: xor_nosignbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    xorl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: xor_nosignbit_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 2147418112 ; 0x7FFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}

define i32 @add_signbit_lshr(i32 %x, i32* %dst) {
; X64-LABEL: add_signbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    addl $-65536, %eax # imm = 0xFFFF0000
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: add_signbit_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:    addl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 4294901760 ; 0xFFFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @add_nosignbit_lshr(i32 %x, i32* %dst) {
; X64-LABEL: add_nosignbit_lshr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    addl $2147418112, %eax # imm = 0x7FFF0000
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: add_nosignbit_lshr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:    addl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 2147418112 ; 0x7FFF0000
  %r = lshr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}

; arithmetic shift right

define i32 @and_signbit_ashr(i32 %x, i32* %dst) {
; X64-LABEL: and_signbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    andl $-256, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: and_signbit_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movswl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shll $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 4294901760 ; 0xFFFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @and_nosignbit_ashr(i32 %x, i32* %dst) {
; X64-LABEL: and_nosignbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    andl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: and_nosignbit_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:    andl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    shrl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = and i32 %x, 2147418112 ; 0x7FFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}

define i32 @or_signbit_ashr(i32 %x, i32* %dst) {
; X64-LABEL: or_signbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shrl $8, %eax
; X64-NEXT:    orl $-256, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: or_signbit_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:    orl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 4294901760 ; 0xFFFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @or_nosignbit_ashr(i32 %x, i32* %dst) {
; X64-LABEL: or_nosignbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    orl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: or_nosignbit_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:    orl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = or i32 %x, 2147418112 ; 0x7FFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}

define i32 @xor_signbit_ashr(i32 %x, i32* %dst) {
; X64-LABEL: xor_signbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    xorl $-256, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: xor_signbit_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 4294901760 ; 0xFFFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @xor_nosignbit_ashr(i32 %x, i32* %dst) {
; X64-LABEL: xor_nosignbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    xorl $8388352, %eax # imm = 0x7FFF00
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: xor_nosignbit_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:    xorl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = xor i32 %x, 2147418112 ; 0x7FFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}

define i32 @add_signbit_ashr(i32 %x, i32* %dst) {
; X64-LABEL: add_signbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    addl $-65536, %eax # imm = 0xFFFF0000
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: add_signbit_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $-65536, %eax # imm = 0xFFFF0000
; X32-NEXT:    addl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 4294901760 ; 0xFFFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
define i32 @add_nosignbit_ashr(i32 %x, i32* %dst) {
; X64-LABEL: add_nosignbit_ashr:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    addl $2147418112, %eax # imm = 0x7FFF0000
; X64-NEXT:    sarl $8, %eax
; X64-NEXT:    movl %eax, (%rsi)
; X64-NEXT:    retq
;
; X32-LABEL: add_nosignbit_ashr:
; X32:       # %bb.0:
; X32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32-NEXT:    movl $2147418112, %eax # imm = 0x7FFF0000
; X32-NEXT:    addl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    sarl $8, %eax
; X32-NEXT:    movl %eax, (%ecx)
; X32-NEXT:    retl
  %t0 = add i32 %x, 2147418112 ; 0x7FFF0000
  %r = ashr i32 %t0, 8
  store i32 %r, i32* %dst
  ret i32 %r
}
