; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv6 < %s | FileCheck %s --check-prefixes=ARM,ARM6
; RUN: llc -mtriple=armv7 < %s | FileCheck %s --check-prefixes=ARM,ARM78
; RUN: llc -mtriple=armv8a < %s | FileCheck %s --check-prefixes=ARM,ARM78
; RUN: llc -mtriple=thumbv6 < %s | FileCheck %s --check-prefixes=THUMB6
; RUN: llc -mtriple=thumbv7 < %s | FileCheck %s --check-prefixes=THUMB78
; RUN: llc -mtriple=thumbv8-eabi < %s | FileCheck %s --check-prefixes=THUMB78

; These two forms are equivalent:
;   sub %y, (xor %x, -1)
;   add (add %x, 1), %y
; Some targets may prefer one to the other.

define i8 @scalar_i8(i8 %x, i8 %y) nounwind {
; ARM-LABEL: scalar_i8:
; ARM:       @ %bb.0:
; ARM-NEXT:    add r0, r1, r0
; ARM-NEXT:    add r0, r0, #1
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i8:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    adds r0, r1, r0
; THUMB6-NEXT:    adds r0, r0, #1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i8:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    add r0, r1
; THUMB78-NEXT:    adds r0, #1
; THUMB78-NEXT:    bx lr
  %t0 = xor i8 %x, -1
  %t1 = sub i8 %y, %t0
  ret i8 %t1
}

define i16 @scalar_i16(i16 %x, i16 %y) nounwind {
; ARM-LABEL: scalar_i16:
; ARM:       @ %bb.0:
; ARM-NEXT:    add r0, r1, r0
; ARM-NEXT:    add r0, r0, #1
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i16:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    adds r0, r1, r0
; THUMB6-NEXT:    adds r0, r0, #1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i16:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    add r0, r1
; THUMB78-NEXT:    adds r0, #1
; THUMB78-NEXT:    bx lr
  %t0 = xor i16 %x, -1
  %t1 = sub i16 %y, %t0
  ret i16 %t1
}

define i32 @scalar_i32(i32 %x, i32 %y) nounwind {
; ARM-LABEL: scalar_i32:
; ARM:       @ %bb.0:
; ARM-NEXT:    add r0, r1, r0
; ARM-NEXT:    add r0, r0, #1
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i32:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    adds r0, r1, r0
; THUMB6-NEXT:    adds r0, r0, #1
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i32:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    add r0, r1
; THUMB78-NEXT:    adds r0, #1
; THUMB78-NEXT:    bx lr
  %t0 = xor i32 %x, -1
  %t1 = sub i32 %y, %t0
  ret i32 %t1
}

define i64 @scalar_i64(i64 %x, i64 %y) nounwind {
; ARM-LABEL: scalar_i64:
; ARM:       @ %bb.0:
; ARM-NEXT:    adds r0, r2, r0
; ARM-NEXT:    adc r1, r3, r1
; ARM-NEXT:    adds r0, r0, #1
; ARM-NEXT:    adc r1, r1, #0
; ARM-NEXT:    bx lr
;
; THUMB6-LABEL: scalar_i64:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    mvns r1, r1
; THUMB6-NEXT:    mvns r0, r0
; THUMB6-NEXT:    subs r0, r2, r0
; THUMB6-NEXT:    sbcs r3, r1
; THUMB6-NEXT:    mov r1, r3
; THUMB6-NEXT:    bx lr
;
; THUMB78-LABEL: scalar_i64:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    adds r0, r0, r2
; THUMB78-NEXT:    adcs r1, r3
; THUMB78-NEXT:    adds r0, #1
; THUMB78-NEXT:    adc r1, r1, #0
; THUMB78-NEXT:    bx lr
  %t0 = xor i64 %x, -1
  %t1 = sub i64 %y, %t0
  ret i64 %t1
}

define <16 x i8> @vector_i128_i8(<16 x i8> %x, <16 x i8> %y) nounwind {
; ARM6-LABEL: vector_i128_i8:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    ldrb r12, [sp, #52]
; ARM6-NEXT:    ldrb r1, [sp, #116]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #48]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #15]
; ARM6-NEXT:    ldrb r1, [sp, #112]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #44]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #14]
; ARM6-NEXT:    ldrb r1, [sp, #108]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #40]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #13]
; ARM6-NEXT:    ldrb r1, [sp, #104]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #36]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #12]
; ARM6-NEXT:    ldrb r1, [sp, #100]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #32]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #11]
; ARM6-NEXT:    ldrb r1, [sp, #96]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #28]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #10]
; ARM6-NEXT:    ldrb r1, [sp, #92]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #24]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #9]
; ARM6-NEXT:    ldrb r1, [sp, #88]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #20]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #8]
; ARM6-NEXT:    ldrb r1, [sp, #84]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #16]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #7]
; ARM6-NEXT:    ldrb r1, [sp, #80]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #12]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #6]
; ARM6-NEXT:    ldrb r1, [sp, #76]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #8]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #5]
; ARM6-NEXT:    ldrb r1, [sp, #72]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp, #4]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #4]
; ARM6-NEXT:    ldrb r1, [sp, #68]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrb r12, [sp]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #3]
; ARM6-NEXT:    ldrb r1, [sp, #64]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #2]
; ARM6-NEXT:    ldrb r1, [sp, #60]
; ARM6-NEXT:    add r1, r1, r3
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0, #1]
; ARM6-NEXT:    ldrb r1, [sp, #56]
; ARM6-NEXT:    add r1, r1, r2
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strb r1, [r0]
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: vector_i128_i8:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    vmov d17, r2, r3
; ARM78-NEXT:    vmov d16, r0, r1
; ARM78-NEXT:    mov r0, sp
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vld1.64 {d18, d19}, [r0]
; ARM78-NEXT:    vsub.i8 q8, q9, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    vmov r2, r3, d17
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vector_i128_i8:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, lr}
; THUMB6-NEXT:    ldr r1, [sp, #60]
; THUMB6-NEXT:    ldr r4, [sp, #124]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #15]
; THUMB6-NEXT:    ldr r1, [sp, #56]
; THUMB6-NEXT:    ldr r4, [sp, #120]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #14]
; THUMB6-NEXT:    ldr r1, [sp, #52]
; THUMB6-NEXT:    ldr r4, [sp, #116]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #13]
; THUMB6-NEXT:    ldr r1, [sp, #48]
; THUMB6-NEXT:    ldr r4, [sp, #112]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #12]
; THUMB6-NEXT:    ldr r1, [sp, #44]
; THUMB6-NEXT:    ldr r4, [sp, #108]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #11]
; THUMB6-NEXT:    ldr r1, [sp, #40]
; THUMB6-NEXT:    ldr r4, [sp, #104]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #10]
; THUMB6-NEXT:    ldr r1, [sp, #36]
; THUMB6-NEXT:    ldr r4, [sp, #100]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #9]
; THUMB6-NEXT:    ldr r1, [sp, #32]
; THUMB6-NEXT:    ldr r4, [sp, #96]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #8]
; THUMB6-NEXT:    ldr r1, [sp, #28]
; THUMB6-NEXT:    ldr r4, [sp, #92]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #7]
; THUMB6-NEXT:    ldr r1, [sp, #24]
; THUMB6-NEXT:    ldr r4, [sp, #88]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #6]
; THUMB6-NEXT:    ldr r1, [sp, #20]
; THUMB6-NEXT:    ldr r4, [sp, #84]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #5]
; THUMB6-NEXT:    ldr r1, [sp, #16]
; THUMB6-NEXT:    ldr r4, [sp, #80]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #4]
; THUMB6-NEXT:    ldr r1, [sp, #12]
; THUMB6-NEXT:    ldr r4, [sp, #76]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #3]
; THUMB6-NEXT:    ldr r1, [sp, #8]
; THUMB6-NEXT:    ldr r4, [sp, #72]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #2]
; THUMB6-NEXT:    ldr r1, [sp, #68]
; THUMB6-NEXT:    adds r1, r1, r3
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0, #1]
; THUMB6-NEXT:    ldr r1, [sp, #64]
; THUMB6-NEXT:    adds r1, r1, r2
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strb r1, [r0]
; THUMB6-NEXT:    pop {r4, pc}
;
; THUMB78-LABEL: vector_i128_i8:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    vmov d17, r2, r3
; THUMB78-NEXT:    vmov d16, r0, r1
; THUMB78-NEXT:    mov r0, sp
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r0]
; THUMB78-NEXT:    vsub.i8 q8, q9, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    vmov r2, r3, d17
; THUMB78-NEXT:    bx lr
  %t0 = xor <16 x i8> %x, <i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>
  %t1 = sub <16 x i8> %y, %t0
  ret <16 x i8> %t1
}

define <8 x i16> @vector_i128_i16(<8 x i16> %x, <8 x i16> %y) nounwind {
; ARM6-LABEL: vector_i128_i16:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    ldrh r12, [sp, #20]
; ARM6-NEXT:    ldrh r1, [sp, #52]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrh r12, [sp, #16]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strh r1, [r0, #14]
; ARM6-NEXT:    ldrh r1, [sp, #48]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrh r12, [sp, #12]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strh r1, [r0, #12]
; ARM6-NEXT:    ldrh r1, [sp, #44]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrh r12, [sp, #8]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strh r1, [r0, #10]
; ARM6-NEXT:    ldrh r1, [sp, #40]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrh r12, [sp, #4]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strh r1, [r0, #8]
; ARM6-NEXT:    ldrh r1, [sp, #36]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    ldrh r12, [sp]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strh r1, [r0, #6]
; ARM6-NEXT:    ldrh r1, [sp, #32]
; ARM6-NEXT:    add r1, r1, r12
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strh r1, [r0, #4]
; ARM6-NEXT:    ldrh r1, [sp, #28]
; ARM6-NEXT:    add r1, r1, r3
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strh r1, [r0, #2]
; ARM6-NEXT:    ldrh r1, [sp, #24]
; ARM6-NEXT:    add r1, r1, r2
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    strh r1, [r0]
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: vector_i128_i16:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    vmov d17, r2, r3
; ARM78-NEXT:    vmov d16, r0, r1
; ARM78-NEXT:    mov r0, sp
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vld1.64 {d18, d19}, [r0]
; ARM78-NEXT:    vsub.i16 q8, q9, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    vmov r2, r3, d17
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vector_i128_i16:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, lr}
; THUMB6-NEXT:    ldr r1, [sp, #28]
; THUMB6-NEXT:    ldr r4, [sp, #60]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strh r1, [r0, #14]
; THUMB6-NEXT:    ldr r1, [sp, #24]
; THUMB6-NEXT:    ldr r4, [sp, #56]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strh r1, [r0, #12]
; THUMB6-NEXT:    ldr r1, [sp, #20]
; THUMB6-NEXT:    ldr r4, [sp, #52]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strh r1, [r0, #10]
; THUMB6-NEXT:    ldr r1, [sp, #16]
; THUMB6-NEXT:    ldr r4, [sp, #48]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strh r1, [r0, #8]
; THUMB6-NEXT:    ldr r1, [sp, #12]
; THUMB6-NEXT:    ldr r4, [sp, #44]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strh r1, [r0, #6]
; THUMB6-NEXT:    ldr r1, [sp, #8]
; THUMB6-NEXT:    ldr r4, [sp, #40]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strh r1, [r0, #4]
; THUMB6-NEXT:    ldr r1, [sp, #36]
; THUMB6-NEXT:    adds r1, r1, r3
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strh r1, [r0, #2]
; THUMB6-NEXT:    ldr r1, [sp, #32]
; THUMB6-NEXT:    adds r1, r1, r2
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    strh r1, [r0]
; THUMB6-NEXT:    pop {r4, pc}
;
; THUMB78-LABEL: vector_i128_i16:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    vmov d17, r2, r3
; THUMB78-NEXT:    vmov d16, r0, r1
; THUMB78-NEXT:    mov r0, sp
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r0]
; THUMB78-NEXT:    vsub.i16 q8, q9, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    vmov r2, r3, d17
; THUMB78-NEXT:    bx lr
  %t0 = xor <8 x i16> %x, <i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1, i16 -1>
  %t1 = sub <8 x i16> %y, %t0
  ret <8 x i16> %t1
}

define <4 x i32> @vector_i128_i32(<4 x i32> %x, <4 x i32> %y) nounwind {
; ARM6-LABEL: vector_i128_i32:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    ldr r12, [sp]
; ARM6-NEXT:    add r0, r12, r0
; ARM6-NEXT:    ldr r12, [sp, #4]
; ARM6-NEXT:    add r0, r0, #1
; ARM6-NEXT:    add r1, r12, r1
; ARM6-NEXT:    ldr r12, [sp, #8]
; ARM6-NEXT:    add r1, r1, #1
; ARM6-NEXT:    add r2, r12, r2
; ARM6-NEXT:    ldr r12, [sp, #12]
; ARM6-NEXT:    add r2, r2, #1
; ARM6-NEXT:    add r3, r12, r3
; ARM6-NEXT:    add r3, r3, #1
; ARM6-NEXT:    bx lr
;
; ARM78-LABEL: vector_i128_i32:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    vmov d17, r2, r3
; ARM78-NEXT:    vmov d16, r0, r1
; ARM78-NEXT:    mov r0, sp
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vld1.64 {d18, d19}, [r0]
; ARM78-NEXT:    vsub.i32 q8, q9, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    vmov r2, r3, d17
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vector_i128_i32:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, lr}
; THUMB6-NEXT:    ldr r4, [sp, #8]
; THUMB6-NEXT:    adds r0, r4, r0
; THUMB6-NEXT:    adds r0, r0, #1
; THUMB6-NEXT:    ldr r4, [sp, #12]
; THUMB6-NEXT:    adds r1, r4, r1
; THUMB6-NEXT:    adds r1, r1, #1
; THUMB6-NEXT:    ldr r4, [sp, #16]
; THUMB6-NEXT:    adds r2, r4, r2
; THUMB6-NEXT:    adds r2, r2, #1
; THUMB6-NEXT:    ldr r4, [sp, #20]
; THUMB6-NEXT:    adds r3, r4, r3
; THUMB6-NEXT:    adds r3, r3, #1
; THUMB6-NEXT:    pop {r4, pc}
;
; THUMB78-LABEL: vector_i128_i32:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    vmov d17, r2, r3
; THUMB78-NEXT:    vmov d16, r0, r1
; THUMB78-NEXT:    mov r0, sp
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r0]
; THUMB78-NEXT:    vsub.i32 q8, q9, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    vmov r2, r3, d17
; THUMB78-NEXT:    bx lr
  %t0 = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %t1 = sub <4 x i32> %y, %t0
  ret <4 x i32> %t1
}

define <2 x i64> @vector_i128_i64(<2 x i64> %x, <2 x i64> %y) nounwind {
; ARM6-LABEL: vector_i128_i64:
; ARM6:       @ %bb.0:
; ARM6-NEXT:    push {r11, lr}
; ARM6-NEXT:    ldr lr, [sp, #8]
; ARM6-NEXT:    ldr r12, [sp, #12]
; ARM6-NEXT:    adds r0, lr, r0
; ARM6-NEXT:    ldr lr, [sp, #16]
; ARM6-NEXT:    adc r1, r12, r1
; ARM6-NEXT:    adds r0, r0, #1
; ARM6-NEXT:    ldr r12, [sp, #20]
; ARM6-NEXT:    adc r1, r1, #0
; ARM6-NEXT:    adds r2, lr, r2
; ARM6-NEXT:    adc r3, r12, r3
; ARM6-NEXT:    adds r2, r2, #1
; ARM6-NEXT:    adc r3, r3, #0
; ARM6-NEXT:    pop {r11, pc}
;
; ARM78-LABEL: vector_i128_i64:
; ARM78:       @ %bb.0:
; ARM78-NEXT:    vmov d17, r2, r3
; ARM78-NEXT:    vmov d16, r0, r1
; ARM78-NEXT:    mov r0, sp
; ARM78-NEXT:    vmvn q8, q8
; ARM78-NEXT:    vld1.64 {d18, d19}, [r0]
; ARM78-NEXT:    vsub.i64 q8, q9, q8
; ARM78-NEXT:    vmov r0, r1, d16
; ARM78-NEXT:    vmov r2, r3, d17
; ARM78-NEXT:    bx lr
;
; THUMB6-LABEL: vector_i128_i64:
; THUMB6:       @ %bb.0:
; THUMB6-NEXT:    push {r4, r5, r7, lr}
; THUMB6-NEXT:    mvns r4, r1
; THUMB6-NEXT:    mvns r0, r0
; THUMB6-NEXT:    ldr r1, [sp, #20]
; THUMB6-NEXT:    ldr r5, [sp, #16]
; THUMB6-NEXT:    subs r0, r5, r0
; THUMB6-NEXT:    sbcs r1, r4
; THUMB6-NEXT:    mvns r4, r3
; THUMB6-NEXT:    mvns r2, r2
; THUMB6-NEXT:    ldr r3, [sp, #28]
; THUMB6-NEXT:    ldr r5, [sp, #24]
; THUMB6-NEXT:    subs r2, r5, r2
; THUMB6-NEXT:    sbcs r3, r4
; THUMB6-NEXT:    pop {r4, r5, r7, pc}
;
; THUMB78-LABEL: vector_i128_i64:
; THUMB78:       @ %bb.0:
; THUMB78-NEXT:    vmov d17, r2, r3
; THUMB78-NEXT:    vmov d16, r0, r1
; THUMB78-NEXT:    mov r0, sp
; THUMB78-NEXT:    vmvn q8, q8
; THUMB78-NEXT:    vld1.64 {d18, d19}, [r0]
; THUMB78-NEXT:    vsub.i64 q8, q9, q8
; THUMB78-NEXT:    vmov r0, r1, d16
; THUMB78-NEXT:    vmov r2, r3, d17
; THUMB78-NEXT:    bx lr
  %t0 = xor <2 x i64> %x, <i64 -1, i64 -1>
  %t1 = sub <2 x i64> %y, %t0
  ret <2 x i64> %t1
}
