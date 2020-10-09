; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -relocation-model=pic -verify-machineinstrs -mcpu=pwr7 -mattr=+altivec -mattr=-vsx < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-n32:64"
target triple = "powerpc64le-unknown-linux-gnu"

@g = common global ppc_fp128 0xM00000000000000000000000000000000, align 16

define void @callee(ppc_fp128 %x) {
; CHECK-LABEL: callee:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, .LC0@toc@ha
; CHECK-NEXT:    stfd 2, -8(1)
; CHECK-NEXT:    stfd 1, -16(1)
; CHECK-NEXT:    ld 3, .LC0@toc@l(3)
; CHECK-NEXT:    stfd 2, 8(3)
; CHECK-NEXT:    stfd 1, 0(3)
; CHECK-NEXT:    blr
entry:
  %x.addr = alloca ppc_fp128, align 16
  store ppc_fp128 %x, ppc_fp128* %x.addr, align 16
  %0 = load ppc_fp128, ppc_fp128* %x.addr, align 16
  store ppc_fp128 %0, ppc_fp128* @g, align 16
  ret void
}

define void @caller() {
; CHECK-LABEL: caller:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LC0@toc@ha
; CHECK-NEXT:    ld 3, .LC0@toc@l(3)
; CHECK-NEXT:    lfd 2, 8(3)
; CHECK-NEXT:    lfd 1, 0(3)
; CHECK-NEXT:    bl test
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %0 = load ppc_fp128, ppc_fp128* @g, align 16
  call void @test(ppc_fp128 %0)
  ret void
}

declare void @test(ppc_fp128)

define void @caller_const() {
; CHECK-LABEL: caller_const:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    addis 3, 2, .LCPI2_0@toc@ha
; CHECK-NEXT:    addis 4, 2, .LCPI2_1@toc@ha
; CHECK-NEXT:    lfs 1, .LCPI2_0@toc@l(3)
; CHECK-NEXT:    lfs 2, .LCPI2_1@toc@l(4)
; CHECK-NEXT:    bl test
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  call void @test(ppc_fp128 0xM3FF00000000000000000000000000000)
  ret void
}

define ppc_fp128 @result() {
; CHECK-LABEL: result:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addis 3, 2, .LC0@toc@ha
; CHECK-NEXT:    ld 3, .LC0@toc@l(3)
; CHECK-NEXT:    lfd 1, 0(3)
; CHECK-NEXT:    lfd 2, 8(3)
; CHECK-NEXT:    blr
entry:
  %0 = load ppc_fp128, ppc_fp128* @g, align 16
  ret ppc_fp128 %0
}

define void @use_result() {
; CHECK-LABEL: use_result:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    bl test_result
; CHECK-NEXT:    nop
; CHECK-NEXT:    addis 3, 2, .LC0@toc@ha
; CHECK-NEXT:    ld 3, .LC0@toc@l(3)
; CHECK-NEXT:    stfd 2, 8(3)
; CHECK-NEXT:    stfd 1, 0(3)
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = tail call ppc_fp128 @test_result() #3
  store ppc_fp128 %call, ppc_fp128* @g, align 16
  ret void
}

declare ppc_fp128 @test_result()

define void @caller_result() {
; CHECK-LABEL: caller_result:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    mflr 0
; CHECK-NEXT:    std 0, 16(1)
; CHECK-NEXT:    stdu 1, -32(1)
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset lr, 16
; CHECK-NEXT:    bl test_result
; CHECK-NEXT:    nop
; CHECK-NEXT:    bl test
; CHECK-NEXT:    nop
; CHECK-NEXT:    addi 1, 1, 32
; CHECK-NEXT:    ld 0, 16(1)
; CHECK-NEXT:    mtlr 0
; CHECK-NEXT:    blr
entry:
  %call = tail call ppc_fp128 @test_result()
  tail call void @test(ppc_fp128 %call)
  ret void
}

define i128 @convert_from(ppc_fp128 %x) {
; CHECK-LABEL: convert_from:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    stfd 1, -16(1)
; CHECK-NEXT:    stfd 2, -8(1)
; CHECK-NEXT:    ld 3, -16(1)
; CHECK-NEXT:    ld 4, -8(1)
; CHECK-NEXT:    blr
entry:
  %0 = bitcast ppc_fp128 %x to i128
  ret i128 %0
}

define ppc_fp128 @convert_to(i128 %x) {
; CHECK-LABEL: convert_to:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    std 3, -16(1)
; CHECK-NEXT:    std 4, -8(1)
; CHECK-NEXT:    lfd 1, -16(1)
; CHECK-NEXT:    lfd 2, -8(1)
; CHECK-NEXT:    blr
entry:
  %0 = bitcast i128 %x to ppc_fp128
  ret ppc_fp128 %0
}

define ppc_fp128 @convert_to2(i128 %x) {
; CHECK-LABEL: convert_to2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    rotldi 5, 3, 1
; CHECK-NEXT:    sldi 3, 3, 1
; CHECK-NEXT:    rldimi 5, 4, 1, 0
; CHECK-NEXT:    std 3, -16(1)
; CHECK-NEXT:    std 5, -8(1)
; CHECK-NEXT:    lfd 1, -16(1)
; CHECK-NEXT:    lfd 2, -8(1)
; CHECK-NEXT:    blr
entry:
  %shl = shl i128 %x, 1
  %0 = bitcast i128 %shl to ppc_fp128
  ret ppc_fp128 %0
}


define double @convert_vector(<4 x i32> %x) {
; CHECK-LABEL: convert_vector:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi 3, 1, -16
; CHECK-NEXT:    stvx 2, 0, 3
; CHECK-NEXT:    lfd 1, -16(1)
; CHECK-NEXT:    blr
entry:
  %cast = bitcast <4 x i32> %x to ppc_fp128
  %conv = fptrunc ppc_fp128 %cast to double
  ret double %conv
}

declare void @llvm.va_start(i8*)

define double @vararg(i32 %a, ...) {
; CHECK-LABEL: vararg:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi 3, 1, 55
; CHECK-NEXT:    std 4, 40(1)
; CHECK-NEXT:    rldicr 3, 3, 0, 59
; CHECK-NEXT:    std 5, 48(1)
; CHECK-NEXT:    ori 4, 3, 8
; CHECK-NEXT:    std 6, 56(1)
; CHECK-NEXT:    std 7, 64(1)
; CHECK-NEXT:    std 8, 72(1)
; CHECK-NEXT:    std 9, 80(1)
; CHECK-NEXT:    std 10, 88(1)
; CHECK-NEXT:    std 4, -8(1)
; CHECK-NEXT:    lfd 1, 0(3)
; CHECK-NEXT:    addi 3, 3, 16
; CHECK-NEXT:    std 3, -8(1)
; CHECK-NEXT:    blr
entry:
  %va = alloca i8*, align 8
  %va1 = bitcast i8** %va to i8*
  call void @llvm.va_start(i8* %va1)
  %arg = va_arg i8** %va, ppc_fp128
  %conv = fptrunc ppc_fp128 %arg to double
  ret double %conv
}

