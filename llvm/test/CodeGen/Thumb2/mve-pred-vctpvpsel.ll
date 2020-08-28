; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp %s -verify-machineinstrs -o - | FileCheck %s

define void @arm_min_helium_f32(float* %pSrc, i32 %blockSize, float* nocapture %pResult, i32* nocapture %pIndex) {
; CHECK-LABEL: arm_min_helium_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    .save {r4, r6, r7, lr}
; CHECK-NEXT:    push {r4, r6, r7, lr}
; CHECK-NEXT:    .vsave {d8, d9}
; CHECK-NEXT:    vpush {d8, d9}
; CHECK-NEXT:    movs r6, #0
; CHECK-NEXT:    mov r12, r1
; CHECK-NEXT:    vidup.u32 q2, r6, #1
; CHECK-NEXT:    cmp r1, #4
; CHECK-NEXT:    it ge
; CHECK-NEXT:    movge.w r12, #4
; CHECK-NEXT:    sub.w r6, r1, r12
; CHECK-NEXT:    adds r6, #3
; CHECK-NEXT:    mov.w lr, #1
; CHECK-NEXT:    adr r4, .LCPI0_0
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    add.w lr, lr, r6, lsr #2
; CHECK-NEXT:    vldrw.u32 q1, [r4]
; CHECK-NEXT:    vmov.i32 q3, #0x4
; CHECK-NEXT:    mov r12, r1
; CHECK-NEXT:    dls lr, lr
; CHECK:  .LBB0_1: @ %do.body
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vctp.32 r12
; CHECK-NEXT:    sub.w r12, r12, #4
; CHECK-NEXT:    vpstttt
; CHECK-NEXT:    vldrwt.u32 q4, [r0], #16
; CHECK-NEXT:    vcmpt.f32 ge, q1, q4
; CHECK-NEXT:    vmovt q1, q4
; CHECK-NEXT:    vmovt q0, q2
; CHECK-NEXT:    vadd.i32 q2, q2, q3
; CHECK-NEXT:    le lr, .LBB0_1
; CHECK-NEXT:  @ %bb.2: @ %do.end
; CHECK-NEXT:    vldr s8, .LCPI0_1
; CHECK-NEXT:    vdup.32 q3, r1
; CHECK-NEXT:    vmov r0, s8
; CHECK-NEXT:    vminnmv.f32 r0, q1
; CHECK-NEXT:    vcmp.f32 le, q1, r0
; CHECK-NEXT:    vmov s8, r0
; CHECK-NEXT:    vpsel q0, q0, q3
; CHECK-NEXT:    vminv.u32 r1, q0
; CHECK-NEXT:    str r1, [r3]
; CHECK-NEXT:    vstr s8, [r2]
; CHECK-NEXT:    vpop {d8, d9}
; CHECK-NEXT:    pop {r4, r6, r7, pc}
entry:
  %0 = tail call { <4 x i32>, i32 } @llvm.arm.mve.vidup.v4i32(i32 0, i32 1)
  %1 = extractvalue { <4 x i32>, i32 } %0, 0
  br label %do.body

do.body:                                          ; preds = %do.body, %entry
  %curExtremValVec.0 = phi <4 x float> [ <float 0x426D1A94A0000000, float 0x426D1A94A0000000, float 0x426D1A94A0000000, float 0x426D1A94A0000000>, %entry ], [ %8, %do.body ]
  %indexVec.0 = phi <4 x i32> [ %1, %entry ], [ %11, %do.body ]
  %2 = phi <4 x float> [ zeroinitializer, %entry ], [ %10, %do.body ]
  %blkCnt.0 = phi i32 [ %blockSize, %entry ], [ %sub, %do.body ]
  %pSrc.addr.0 = phi float* [ %pSrc, %entry ], [ %add.ptr, %do.body ]
  %3 = tail call <4 x i1> @llvm.arm.mve.vctp32(i32 %blkCnt.0)
  %4 = bitcast float* %pSrc.addr.0 to <4 x float>*
  %5 = tail call fast <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>* %4, i32 4, <4 x i1> %3, <4 x float> zeroinitializer)
  %6 = fcmp fast ole <4 x float> %5, %curExtremValVec.0
  %7 = and <4 x i1> %6, %3
  %8 = select fast <4 x i1> %7, <4 x float> %5, <4 x float> %curExtremValVec.0
  %9 = bitcast <4 x i32> %indexVec.0 to <4 x float>
  %10 = select fast <4 x i1> %7, <4 x float> %9, <4 x float> %2
  %11 = add <4 x i32> %indexVec.0, <i32 4, i32 4, i32 4, i32 4>
  %add.ptr = getelementptr inbounds float, float* %pSrc.addr.0, i32 4
  %sub = add nsw i32 %blkCnt.0, -4
  %cmp = icmp sgt i32 %blkCnt.0, 4
  br i1 %cmp, label %do.body, label %do.end

do.end:                                           ; preds = %do.body
  %12 = bitcast <4 x float> %10 to <4 x i32>
  %13 = tail call fast float @llvm.arm.mve.minnmv.f32.v4f32(float 0x426D1A94A0000000, <4 x float> %8)
  %.splatinsert = insertelement <4 x float> undef, float %13, i32 0
  %.splat = shufflevector <4 x float> %.splatinsert, <4 x float> undef, <4 x i32> zeroinitializer
  %14 = fcmp fast ole <4 x float> %8, %.splat
  %.splatinsert1 = insertelement <4 x i32> undef, i32 %blockSize, i32 0
  %.splat2 = shufflevector <4 x i32> %.splatinsert1, <4 x i32> undef, <4 x i32> zeroinitializer
  %15 = select <4 x i1> %14, <4 x i32> %12, <4 x i32> %.splat2
  %16 = tail call i32 @llvm.arm.mve.minv.v4i32(i32 %blockSize, <4 x i32> %15, i32 1)
  store i32 %16, i32* %pIndex, align 4
  store float %13, float* %pResult, align 4
  ret void
}

declare { <4 x i32>, i32 } @llvm.arm.mve.vidup.v4i32(i32, i32) #1
declare <4 x i1> @llvm.arm.mve.vctp32(i32) #1
declare <4 x float> @llvm.masked.load.v4f32.p0v4f32(<4 x float>*, i32 immarg, <4 x i1>, <4 x float>) #2
declare float @llvm.arm.mve.minnmv.f32.v4f32(float, <4 x float>) #1
declare i32 @llvm.arm.mve.minv.v4i32(i32, <4 x i32>, i32) #1
