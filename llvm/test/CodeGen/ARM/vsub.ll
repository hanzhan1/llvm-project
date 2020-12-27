; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv7a-eabi -mattr=+neon -float-abi=hard %s -o - | FileCheck %s

define <8 x i8> @vsubi8(<8 x i8> %A, <8 x i8> %B) {
; CHECK-LABEL: vsubi8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i8 d0, d0, d1
; CHECK-NEXT:    bx lr
  %tmp3 = sub <8 x i8> %A, %B
  ret <8 x i8> %tmp3
}

define <4 x i16> @vsubi16(<4 x i16> %A, <4 x i16> %B) {
; CHECK-LABEL: vsubi16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i16 d0, d0, d1
; CHECK-NEXT:    bx lr
  %tmp3 = sub <4 x i16> %A, %B
  ret <4 x i16> %tmp3
}

define <2 x i32> @vsubi32(<2 x i32> %A, <2 x i32> %B) {
; CHECK-LABEL: vsubi32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i32 d0, d0, d1
; CHECK-NEXT:    bx lr
  %tmp3 = sub <2 x i32> %A, %B
  ret <2 x i32> %tmp3
}

define <1 x i64> @vsubi64(<1 x i64> %A, <1 x i64> %B) {
; CHECK-LABEL: vsubi64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i64 d0, d0, d1
; CHECK-NEXT:    bx lr
  %tmp3 = sub <1 x i64> %A, %B
  ret <1 x i64> %tmp3
}

define <2 x float> @vsubf32(<2 x float> %A, <2 x float> %B) {
; CHECK-LABEL: vsubf32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.f32 d0, d0, d1
; CHECK-NEXT:    bx lr
  %tmp3 = fsub <2 x float> %A, %B
  ret <2 x float> %tmp3
}

define <16 x i8> @vsubQi8(<16 x i8> %A, <16 x i8> %B) {
; CHECK-LABEL: vsubQi8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %tmp3 = sub <16 x i8> %A, %B
  ret <16 x i8> %tmp3
}

define <8 x i16> @vsubQi16(<8 x i16> %A, <8 x i16> %B) {
; CHECK-LABEL: vsubQi16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %tmp3 = sub <8 x i16> %A, %B
  ret <8 x i16> %tmp3
}

define <4 x i32> @vsubQi32(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: vsubQi32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %tmp3 = sub <4 x i32> %A, %B
  ret <4 x i32> %tmp3
}

define <2 x i64> @vsubQi64(<2 x i64> %A, <2 x i64> %B) {
; CHECK-LABEL: vsubQi64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i64 q0, q0, q1
; CHECK-NEXT:    bx lr
  %tmp3 = sub <2 x i64> %A, %B
  ret <2 x i64> %tmp3
}

define <4 x float> @vsubQf32(<4 x float> %A, <4 x float> %B) {
; CHECK-LABEL: vsubQf32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.f32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %tmp3 = fsub <4 x float> %A, %B
  ret <4 x float> %tmp3
}

define <8 x i8> @vrsubhni16(<8 x i16> %A, <8 x i16> %B) {
; CHECK-LABEL: vrsubhni16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vrsubhn.i16 d0, q0, q1
; CHECK-NEXT:    bx lr
  %tmp3 = call <8 x i8> @llvm.arm.neon.vrsubhn.v8i8(<8 x i16> %A, <8 x i16> %B)
  ret <8 x i8> %tmp3
}

define <4 x i16> @vrsubhni32(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: vrsubhni32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vrsubhn.i32 d0, q0, q1
; CHECK-NEXT:    bx lr
  %tmp3 = call <4 x i16> @llvm.arm.neon.vrsubhn.v4i16(<4 x i32> %A, <4 x i32> %B)
  ret <4 x i16> %tmp3
}

define <2 x i32> @vrsubhni64(<2 x i64> %A, <2 x i64> %B) {
; CHECK-LABEL: vrsubhni64:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vrsubhn.i64 d0, q0, q1
; CHECK-NEXT:    bx lr
  %tmp3 = call <2 x i32> @llvm.arm.neon.vrsubhn.v2i32(<2 x i64> %A, <2 x i64> %B)
  ret <2 x i32> %tmp3
}

declare <8 x i8>  @llvm.arm.neon.vrsubhn.v8i8(<8 x i16>, <8 x i16>) readnone
declare <4 x i16> @llvm.arm.neon.vrsubhn.v4i16(<4 x i32>, <4 x i32>) readnone
declare <2 x i32> @llvm.arm.neon.vrsubhn.v2i32(<2 x i64>, <2 x i64>) readnone

define <8 x i8> @vsubhni16_natural(<8 x i16> %A, <8 x i16> %B) {
; CHECK-LABEL: vsubhni16_natural:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubhn.i16 d0, q0, q1
; CHECK-NEXT:    bx lr
  %sum = sub <8 x i16> %A, %B
  %shift = lshr <8 x i16> %sum, <i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8, i16 8>
  %trunc = trunc <8 x i16> %shift to <8 x i8>
  ret <8 x i8> %trunc
}

define <4 x i16> @vsubhni32_natural(<4 x i32> %A, <4 x i32> %B) {
; CHECK-LABEL: vsubhni32_natural:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubhn.i32 d0, q0, q1
; CHECK-NEXT:    bx lr
  %sum = sub <4 x i32> %A, %B
  %shift = lshr <4 x i32> %sum, <i32 16, i32 16, i32 16, i32 16>
  %trunc = trunc <4 x i32> %shift to <4 x i16>
  ret <4 x i16> %trunc
}

define <2 x i32> @vsubhni64_natural(<2 x i64> %A, <2 x i64> %B) {
; CHECK-LABEL: vsubhni64_natural:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubhn.i64 d0, q0, q1
; CHECK-NEXT:    bx lr
  %sum = sub <2 x i64> %A, %B
  %shift = lshr <2 x i64> %sum, <i64 32, i64 32>
  %trunc = trunc <2 x i64> %shift to <2 x i32>
  ret <2 x i32> %trunc
}

define <8 x i16> @vsubls8(<8 x i8> %A, <8 x i8> %B) {
; CHECK-LABEL: vsubls8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubl.s8 q0, d0, d1
; CHECK-NEXT:    bx lr
  %tmp3 = sext <8 x i8> %A to <8 x i16>
  %tmp4 = sext <8 x i8> %B to <8 x i16>
  %tmp5 = sub <8 x i16> %tmp3, %tmp4
  ret <8 x i16> %tmp5
}

define <4 x i32> @vsubls16(<4 x i16> %A, <4 x i16> %B) {
; CHECK-LABEL: vsubls16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubl.s16 q0, d0, d1
; CHECK-NEXT:    bx lr
  %tmp3 = sext <4 x i16> %A to <4 x i32>
  %tmp4 = sext <4 x i16> %B to <4 x i32>
  %tmp5 = sub <4 x i32> %tmp3, %tmp4
  ret <4 x i32> %tmp5
}

define <2 x i64> @vsubls32(<2 x i32> %A, <2 x i32> %B) {
; CHECK-LABEL: vsubls32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubl.s32 q0, d0, d1
; CHECK-NEXT:    bx lr
  %tmp3 = sext <2 x i32> %A to <2 x i64>
  %tmp4 = sext <2 x i32> %B to <2 x i64>
  %tmp5 = sub <2 x i64> %tmp3, %tmp4
  ret <2 x i64> %tmp5
}

define <8 x i16> @vsublu8(<8 x i8> %A, <8 x i8> %B) {
; CHECK-LABEL: vsublu8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubl.u8 q0, d0, d1
; CHECK-NEXT:    bx lr
  %tmp3 = zext <8 x i8> %A to <8 x i16>
  %tmp4 = zext <8 x i8> %B to <8 x i16>
  %tmp5 = sub <8 x i16> %tmp3, %tmp4
  ret <8 x i16> %tmp5
}

define <4 x i32> @vsublu16(<4 x i16> %A, <4 x i16> %B) {
; CHECK-LABEL: vsublu16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubl.u16 q0, d0, d1
; CHECK-NEXT:    bx lr
  %tmp3 = zext <4 x i16> %A to <4 x i32>
  %tmp4 = zext <4 x i16> %B to <4 x i32>
  %tmp5 = sub <4 x i32> %tmp3, %tmp4
  ret <4 x i32> %tmp5
}

define <2 x i64> @vsublu32(<2 x i32> %A, <2 x i32> %B) {
; CHECK-LABEL: vsublu32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubl.u32 q0, d0, d1
; CHECK-NEXT:    bx lr
  %tmp3 = zext <2 x i32> %A to <2 x i64>
  %tmp4 = zext <2 x i32> %B to <2 x i64>
  %tmp5 = sub <2 x i64> %tmp3, %tmp4
  ret <2 x i64> %tmp5
}

define <8 x i16> @vsubla8(<8 x i8> %A, <8 x i8> %B) {
; CHECK-LABEL: vsubla8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmovl.u8 q8, d1
; CHECK-NEXT:    vmovl.u8 q9, d0
; CHECK-NEXT:    vsub.i16 q0, q9, q8
; CHECK-NEXT:    vbic.i16 q0, #0xff00
; CHECK-NEXT:    bx lr
  %tmp3 = zext <8 x i8> %A to <8 x i16>
  %tmp4 = zext <8 x i8> %B to <8 x i16>
  %tmp5 = sub <8 x i16> %tmp3, %tmp4
  %and = and <8 x i16> %tmp5, <i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255>
  ret <8 x i16> %and
}

define <4 x i32> @vsubla16(<4 x i16> %A, <4 x i16> %B) {
; CHECK-LABEL: vsubla16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmovl.u16 q8, d1
; CHECK-NEXT:    vmovl.u16 q9, d0
; CHECK-NEXT:    vmov.i32 q10, #0xffff
; CHECK-NEXT:    vsub.i32 q8, q9, q8
; CHECK-NEXT:    vand q0, q8, q10
; CHECK-NEXT:    bx lr
  %tmp3 = zext <4 x i16> %A to <4 x i32>
  %tmp4 = zext <4 x i16> %B to <4 x i32>
  %tmp5 = sub <4 x i32> %tmp3, %tmp4
  %and = and <4 x i32> %tmp5, <i32 65535, i32 65535, i32 65535, i32 65535>
  ret <4 x i32> %and
}

define <2 x i64> @vsubla32(<2 x i32> %A, <2 x i32> %B) {
; CHECK-LABEL: vsubla32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmovl.u32 q8, d1
; CHECK-NEXT:    vmovl.u32 q9, d0
; CHECK-NEXT:    vmov.i64 q10, #0xffffffff
; CHECK-NEXT:    vsub.i64 q8, q9, q8
; CHECK-NEXT:    vand q0, q8, q10
; CHECK-NEXT:    bx lr
  %tmp3 = zext <2 x i32> %A to <2 x i64>
  %tmp4 = zext <2 x i32> %B to <2 x i64>
  %tmp5 = sub <2 x i64> %tmp3, %tmp4
  %and = and <2 x i64> %tmp5, <i64 4294967295, i64 4294967295>
  ret <2 x i64> %and
}

define <8 x i16> @vsubws8(<8 x i16> %A, <8 x i8> %B) {
; CHECK-LABEL: vsubws8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubw.s8 q0, q0, d2
; CHECK-NEXT:    bx lr
  %tmp3 = sext <8 x i8> %B to <8 x i16>
  %tmp4 = sub <8 x i16> %A, %tmp3
  ret <8 x i16> %tmp4
}

define <4 x i32> @vsubws16(<4 x i32> %A, <4 x i16> %B) {
; CHECK-LABEL: vsubws16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubw.s16 q0, q0, d2
; CHECK-NEXT:    bx lr
  %tmp3 = sext <4 x i16> %B to <4 x i32>
  %tmp4 = sub <4 x i32> %A, %tmp3
  ret <4 x i32> %tmp4
}

define <2 x i64> @vsubws32(<2 x i64> %A, <2 x i32> %B) {
; CHECK-LABEL: vsubws32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubw.s32 q0, q0, d2
; CHECK-NEXT:    bx lr
  %tmp3 = sext <2 x i32> %B to <2 x i64>
  %tmp4 = sub <2 x i64> %A, %tmp3
  ret <2 x i64> %tmp4
}

define <8 x i16> @vsubwu8(<8 x i16> %A, <8 x i8> %B) {
; CHECK-LABEL: vsubwu8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubw.u8 q0, q0, d2
; CHECK-NEXT:    bx lr
  %tmp3 = zext <8 x i8> %B to <8 x i16>
  %tmp4 = sub <8 x i16> %A, %tmp3
  ret <8 x i16> %tmp4
}

define <4 x i32> @vsubwu16(<4 x i32> %A, <4 x i16> %B) {
; CHECK-LABEL: vsubwu16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubw.u16 q0, q0, d2
; CHECK-NEXT:    bx lr
  %tmp3 = zext <4 x i16> %B to <4 x i32>
  %tmp4 = sub <4 x i32> %A, %tmp3
  ret <4 x i32> %tmp4
}

define <2 x i64> @vsubwu32(<2 x i64> %A, <2 x i32> %B) {
; CHECK-LABEL: vsubwu32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsubw.u32 q0, q0, d2
; CHECK-NEXT:    bx lr
  %tmp3 = zext <2 x i32> %B to <2 x i64>
  %tmp4 = sub <2 x i64> %A, %tmp3
  ret <2 x i64> %tmp4
}

define <8 x i16> @vsubwa8(<8 x i16> %A, <8 x i8> %B) {
; CHECK-LABEL: vsubwa8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmovl.u8 q8, d2
; CHECK-NEXT:    vsub.i16 q0, q0, q8
; CHECK-NEXT:    vbic.i16 q0, #0xff00
; CHECK-NEXT:    bx lr
  %tmp3 = zext <8 x i8> %B to <8 x i16>
  %tmp4 = sub <8 x i16> %A, %tmp3
  %and = and <8 x i16> %tmp4, <i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255>
  ret <8 x i16> %and
}

define <4 x i32> @vsubwa16(<4 x i32> %A, <4 x i16> %B) {
; CHECK-LABEL: vsubwa16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmovl.u16 q8, d2
; CHECK-NEXT:    vmov.i32 q9, #0xffff
; CHECK-NEXT:    vsub.i32 q8, q0, q8
; CHECK-NEXT:    vand q0, q8, q9
; CHECK-NEXT:    bx lr
  %tmp3 = zext <4 x i16> %B to <4 x i32>
  %tmp4 = sub <4 x i32> %A, %tmp3
  %and = and <4 x i32> %tmp4, <i32 65535, i32 65535, i32 65535, i32 65535>
  ret <4 x i32> %and
}

define <2 x i64> @vsubwa32(<2 x i64> %A, <2 x i32> %B) {
; CHECK-LABEL: vsubwa32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmovl.u32 q8, d2
; CHECK-NEXT:    vmov.i64 q9, #0xffffffff
; CHECK-NEXT:    vsub.i64 q8, q0, q8
; CHECK-NEXT:    vand q0, q8, q9
; CHECK-NEXT:    bx lr
  %tmp3 = zext <2 x i32> %B to <2 x i64>
  %tmp4 = sub <2 x i64> %A, %tmp3
  %and = and <2 x i64> %tmp4, <i64 4294967295, i64 4294967295>
  ret <2 x i64> %and
}
