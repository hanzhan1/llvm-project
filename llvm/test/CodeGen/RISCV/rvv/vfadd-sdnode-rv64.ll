; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+d,+experimental-zfh,+experimental-v -target-abi=lp64d \
; RUN:     -verify-machineinstrs < %s | FileCheck %s

define <vscale x 1 x half> @vfadd_vv_nxv1f16(<vscale x 1 x half> %va, <vscale x 1 x half> %vb) {
; CHECK-LABEL: vfadd_vv_nxv1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v17
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 1 x half> %va, %vb
  ret <vscale x 1 x half> %vc
}

define <vscale x 1 x half> @vfadd_vf_nxv1f16(<vscale x 1 x half> %va, half %b) {
; CHECK-LABEL: vfadd_vf_nxv1f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,mf4,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 1 x half> %head, <vscale x 1 x half> undef, <vscale x 1 x i32> zeroinitializer
  %vc = fadd <vscale x 1 x half> %va, %splat
  ret <vscale x 1 x half> %vc
}

define <vscale x 2 x half> @vfadd_vv_nxv2f16(<vscale x 2 x half> %va, <vscale x 2 x half> %vb) {
; CHECK-LABEL: vfadd_vv_nxv2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v17
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 2 x half> %va, %vb
  ret <vscale x 2 x half> %vc
}

define <vscale x 2 x half> @vfadd_vf_nxv2f16(<vscale x 2 x half> %va, half %b) {
; CHECK-LABEL: vfadd_vf_nxv2f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,mf2,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 2 x half> %head, <vscale x 2 x half> undef, <vscale x 2 x i32> zeroinitializer
  %vc = fadd <vscale x 2 x half> %va, %splat
  ret <vscale x 2 x half> %vc
}

define <vscale x 4 x half> @vfadd_vv_nxv4f16(<vscale x 4 x half> %va, <vscale x 4 x half> %vb) {
; CHECK-LABEL: vfadd_vv_nxv4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v17
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 4 x half> %va, %vb
  ret <vscale x 4 x half> %vc
}

define <vscale x 4 x half> @vfadd_vf_nxv4f16(<vscale x 4 x half> %va, half %b) {
; CHECK-LABEL: vfadd_vf_nxv4f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m1,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 4 x half> %head, <vscale x 4 x half> undef, <vscale x 4 x i32> zeroinitializer
  %vc = fadd <vscale x 4 x half> %va, %splat
  ret <vscale x 4 x half> %vc
}

define <vscale x 8 x half> @vfadd_vv_nxv8f16(<vscale x 8 x half> %va, <vscale x 8 x half> %vb) {
; CHECK-LABEL: vfadd_vv_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v18
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 8 x half> %va, %vb
  ret <vscale x 8 x half> %vc
}

define <vscale x 8 x half> @vfadd_vf_nxv8f16(<vscale x 8 x half> %va, half %b) {
; CHECK-LABEL: vfadd_vf_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 8 x half> %head, <vscale x 8 x half> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fadd <vscale x 8 x half> %va, %splat
  ret <vscale x 8 x half> %vc
}

define <vscale x 8 x half> @vfadd_fv_nxv8f16(<vscale x 8 x half> %va, half %b) {
; CHECK-LABEL: vfadd_fv_nxv8f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m2,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 8 x half> %head, <vscale x 8 x half> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fadd <vscale x 8 x half> %splat, %va
  ret <vscale x 8 x half> %vc
}

define <vscale x 16 x half> @vfadd_vv_nxv16f16(<vscale x 16 x half> %va, <vscale x 16 x half> %vb) {
; CHECK-LABEL: vfadd_vv_nxv16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v20
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 16 x half> %va, %vb
  ret <vscale x 16 x half> %vc
}

define <vscale x 16 x half> @vfadd_vf_nxv16f16(<vscale x 16 x half> %va, half %b) {
; CHECK-LABEL: vfadd_vf_nxv16f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m4,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 16 x half> %head, <vscale x 16 x half> undef, <vscale x 16 x i32> zeroinitializer
  %vc = fadd <vscale x 16 x half> %va, %splat
  ret <vscale x 16 x half> %vc
}

define <vscale x 32 x half> @vfadd_vv_nxv32f16(<vscale x 32 x half> %va, <vscale x 32 x half> %vb) {
; CHECK-LABEL: vfadd_vv_nxv32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e16,m8,ta,mu
; CHECK-NEXT:    vle16.v v8, (a0)
; CHECK-NEXT:    vfadd.vv v16, v16, v8
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 32 x half> %va, %vb
  ret <vscale x 32 x half> %vc
}

define <vscale x 32 x half> @vfadd_vf_nxv32f16(<vscale x 32 x half> %va, half %b) {
; CHECK-LABEL: vfadd_vf_nxv32f16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $f10_h killed $f10_h def $f10_f
; CHECK-NEXT:    vsetvli a0, zero, e16,m8,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 32 x half> undef, half %b, i32 0
  %splat = shufflevector <vscale x 32 x half> %head, <vscale x 32 x half> undef, <vscale x 32 x i32> zeroinitializer
  %vc = fadd <vscale x 32 x half> %va, %splat
  ret <vscale x 32 x half> %vc
}

define <vscale x 1 x float> @vfadd_vv_nxv1f32(<vscale x 1 x float> %va, <vscale x 1 x float> %vb) {
; CHECK-LABEL: vfadd_vv_nxv1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v17
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 1 x float> %va, %vb
  ret <vscale x 1 x float> %vc
}

define <vscale x 1 x float> @vfadd_vf_nxv1f32(<vscale x 1 x float> %va, float %b) {
; CHECK-LABEL: vfadd_vf_nxv1f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,mf2,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 1 x float> %head, <vscale x 1 x float> undef, <vscale x 1 x i32> zeroinitializer
  %vc = fadd <vscale x 1 x float> %va, %splat
  ret <vscale x 1 x float> %vc
}

define <vscale x 2 x float> @vfadd_vv_nxv2f32(<vscale x 2 x float> %va, <vscale x 2 x float> %vb) {
; CHECK-LABEL: vfadd_vv_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v17
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 2 x float> %va, %vb
  ret <vscale x 2 x float> %vc
}

define <vscale x 2 x float> @vfadd_vf_nxv2f32(<vscale x 2 x float> %va, float %b) {
; CHECK-LABEL: vfadd_vf_nxv2f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m1,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 2 x float> %head, <vscale x 2 x float> undef, <vscale x 2 x i32> zeroinitializer
  %vc = fadd <vscale x 2 x float> %va, %splat
  ret <vscale x 2 x float> %vc
}

define <vscale x 4 x float> @vfadd_vv_nxv4f32(<vscale x 4 x float> %va, <vscale x 4 x float> %vb) {
; CHECK-LABEL: vfadd_vv_nxv4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v18
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 4 x float> %va, %vb
  ret <vscale x 4 x float> %vc
}

define <vscale x 4 x float> @vfadd_vf_nxv4f32(<vscale x 4 x float> %va, float %b) {
; CHECK-LABEL: vfadd_vf_nxv4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m2,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 4 x float> %head, <vscale x 4 x float> undef, <vscale x 4 x i32> zeroinitializer
  %vc = fadd <vscale x 4 x float> %va, %splat
  ret <vscale x 4 x float> %vc
}

define <vscale x 8 x float> @vfadd_vv_nxv8f32(<vscale x 8 x float> %va, <vscale x 8 x float> %vb) {
; CHECK-LABEL: vfadd_vv_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v20
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 8 x float> %va, %vb
  ret <vscale x 8 x float> %vc
}

define <vscale x 8 x float> @vfadd_vf_nxv8f32(<vscale x 8 x float> %va, float %b) {
; CHECK-LABEL: vfadd_vf_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 8 x float> %head, <vscale x 8 x float> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fadd <vscale x 8 x float> %va, %splat
  ret <vscale x 8 x float> %vc
}

define <vscale x 8 x float> @vfadd_fv_nxv8f32(<vscale x 8 x float> %va, float %b) {
; CHECK-LABEL: vfadd_fv_nxv8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m4,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 8 x float> %head, <vscale x 8 x float> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fadd <vscale x 8 x float> %splat, %va
  ret <vscale x 8 x float> %vc
}

define <vscale x 16 x float> @vfadd_vv_nxv16f32(<vscale x 16 x float> %va, <vscale x 16 x float> %vb) {
; CHECK-LABEL: vfadd_vv_nxv16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e32,m8,ta,mu
; CHECK-NEXT:    vle32.v v8, (a0)
; CHECK-NEXT:    vfadd.vv v16, v16, v8
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 16 x float> %va, %vb
  ret <vscale x 16 x float> %vc
}

define <vscale x 16 x float> @vfadd_vf_nxv16f32(<vscale x 16 x float> %va, float %b) {
; CHECK-LABEL: vfadd_vf_nxv16f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32,m8,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 16 x float> undef, float %b, i32 0
  %splat = shufflevector <vscale x 16 x float> %head, <vscale x 16 x float> undef, <vscale x 16 x i32> zeroinitializer
  %vc = fadd <vscale x 16 x float> %va, %splat
  ret <vscale x 16 x float> %vc
}

define <vscale x 1 x double> @vfadd_vv_nxv1f64(<vscale x 1 x double> %va, <vscale x 1 x double> %vb) {
; CHECK-LABEL: vfadd_vv_nxv1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v17
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 1 x double> %va, %vb
  ret <vscale x 1 x double> %vc
}

define <vscale x 1 x double> @vfadd_vf_nxv1f64(<vscale x 1 x double> %va, double %b) {
; CHECK-LABEL: vfadd_vf_nxv1f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m1,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 1 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 1 x double> %head, <vscale x 1 x double> undef, <vscale x 1 x i32> zeroinitializer
  %vc = fadd <vscale x 1 x double> %va, %splat
  ret <vscale x 1 x double> %vc
}

define <vscale x 2 x double> @vfadd_vv_nxv2f64(<vscale x 2 x double> %va, <vscale x 2 x double> %vb) {
; CHECK-LABEL: vfadd_vv_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v18
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 2 x double> %va, %vb
  ret <vscale x 2 x double> %vc
}

define <vscale x 2 x double> @vfadd_vf_nxv2f64(<vscale x 2 x double> %va, double %b) {
; CHECK-LABEL: vfadd_vf_nxv2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m2,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 2 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 2 x double> %head, <vscale x 2 x double> undef, <vscale x 2 x i32> zeroinitializer
  %vc = fadd <vscale x 2 x double> %va, %splat
  ret <vscale x 2 x double> %vc
}

define <vscale x 4 x double> @vfadd_vv_nxv4f64(<vscale x 4 x double> %va, <vscale x 4 x double> %vb) {
; CHECK-LABEL: vfadd_vv_nxv4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; CHECK-NEXT:    vfadd.vv v16, v16, v20
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 4 x double> %va, %vb
  ret <vscale x 4 x double> %vc
}

define <vscale x 4 x double> @vfadd_vf_nxv4f64(<vscale x 4 x double> %va, double %b) {
; CHECK-LABEL: vfadd_vf_nxv4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m4,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 4 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 4 x double> %head, <vscale x 4 x double> undef, <vscale x 4 x i32> zeroinitializer
  %vc = fadd <vscale x 4 x double> %va, %splat
  ret <vscale x 4 x double> %vc
}

define <vscale x 8 x double> @vfadd_vv_nxv8f64(<vscale x 8 x double> %va, <vscale x 8 x double> %vb) {
; CHECK-LABEL: vfadd_vv_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a1, zero, e64,m8,ta,mu
; CHECK-NEXT:    vle64.v v8, (a0)
; CHECK-NEXT:    vfadd.vv v16, v16, v8
; CHECK-NEXT:    ret
  %vc = fadd <vscale x 8 x double> %va, %vb
  ret <vscale x 8 x double> %vc
}

define <vscale x 8 x double> @vfadd_vf_nxv8f64(<vscale x 8 x double> %va, double %b) {
; CHECK-LABEL: vfadd_vf_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 8 x double> %head, <vscale x 8 x double> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fadd <vscale x 8 x double> %va, %splat
  ret <vscale x 8 x double> %vc
}

define <vscale x 8 x double> @vfadd_fv_nxv8f64(<vscale x 8 x double> %va, double %b) {
; CHECK-LABEL: vfadd_fv_nxv8f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64,m8,ta,mu
; CHECK-NEXT:    vfadd.vf v16, v16, fa0
; CHECK-NEXT:    ret
  %head = insertelement <vscale x 8 x double> undef, double %b, i32 0
  %splat = shufflevector <vscale x 8 x double> %head, <vscale x 8 x double> undef, <vscale x 8 x i32> zeroinitializer
  %vc = fadd <vscale x 8 x double> %splat, %va
  ret <vscale x 8 x double> %vc
}

