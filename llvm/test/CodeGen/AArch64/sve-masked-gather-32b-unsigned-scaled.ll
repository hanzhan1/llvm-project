; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64--linux-gnu -mattr=+sve -aarch64-enable-mgather-combine=0 < %s | FileCheck %s

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; unscaled unpacked 32-bit offsets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define <vscale x 2 x i64> @masked_gather_nxv2i16(i16* %base, <vscale x 2 x i32> %offsets, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, #0xffffffff
; CHECK-NEXT:    ld1h { z0.d }, p0/z, [x0, z0.d, sxtw #1]
; CHECK-NEXT:    and z0.d, z0.d, #0xffff
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 2 x i32> %offsets to <vscale x 2 x i64>
  %ptrs = getelementptr i16, i16* %base, <vscale x 2 x i64> %offsets.zext
  %vals = call <vscale x 2 x i16> @llvm.masked.gather.nxv2i16(<vscale x 2 x i16*> %ptrs, i32 2, <vscale x 2 x i1> %mask, <vscale x 2 x i16> undef)
  %vals.zext = zext <vscale x 2 x i16> %vals to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %vals.zext
}

define <vscale x 2 x i64> @masked_gather_nxv2i32(i32* %base, <vscale x 2 x i32> %offsets, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, #0xffffffff
; CHECK-NEXT:    ld1w { z0.d }, p0/z, [x0, z0.d, sxtw #2]
; CHECK-NEXT:    and z0.d, z0.d, #0xffffffff
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 2 x i32> %offsets to <vscale x 2 x i64>
  %ptrs = getelementptr i32, i32* %base, <vscale x 2 x i64> %offsets.zext
  %vals = call <vscale x 2 x i32> @llvm.masked.gather.nxv2i32(<vscale x 2 x i32*> %ptrs, i32 4, <vscale x 2 x i1> %mask, <vscale x 2 x i32> undef)
  %vals.zext = zext <vscale x 2 x i32> %vals to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %vals.zext
}

define <vscale x 2 x i64> @masked_gather_nxv2i64(i64* %base, <vscale x 2 x i32> %offsets, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, #0xffffffff
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0, z0.d, sxtw #3]
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 2 x i32> %offsets to <vscale x 2 x i64>
  %ptrs = getelementptr i64, i64* %base, <vscale x 2 x i64> %offsets.zext
  %vals = call <vscale x 2 x i64> @llvm.masked.gather.nxv2i64(<vscale x 2 x i64*> %ptrs, i32 8, <vscale x 2 x i1> %mask, <vscale x 2 x i64> undef)
  ret <vscale x 2 x i64> %vals
}

define <vscale x 2 x half> @masked_gather_nxv2f16(half* %base, <vscale x 2 x i32> %offsets, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, #0xffffffff
; CHECK-NEXT:    ld1h { z0.d }, p0/z, [x0, z0.d, sxtw #1]
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 2 x i32> %offsets to <vscale x 2 x i64>
  %ptrs = getelementptr half, half* %base, <vscale x 2 x i64> %offsets.zext
  %vals = call <vscale x 2 x half> @llvm.masked.gather.nxv2f16(<vscale x 2 x half*> %ptrs, i32 2, <vscale x 2 x i1> %mask, <vscale x 2 x half> undef)
  ret <vscale x 2 x half> %vals
}

define <vscale x 2 x float> @masked_gather_nxv2f32(float* %base, <vscale x 2 x i32> %offsets, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, #0xffffffff
; CHECK-NEXT:    ld1w { z0.d }, p0/z, [x0, z0.d, sxtw #2]
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 2 x i32> %offsets to <vscale x 2 x i64>
  %ptrs = getelementptr float, float* %base, <vscale x 2 x i64> %offsets.zext
  %vals = call <vscale x 2 x float> @llvm.masked.gather.nxv2f32(<vscale x 2 x float*> %ptrs, i32 4, <vscale x 2 x i1> %mask, <vscale x 2 x float> undef)
  ret <vscale x 2 x float> %vals
}

define <vscale x 2 x double> @masked_gather_nxv2f64(double* %base, <vscale x 2 x i32> %offsets, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv2f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, #0xffffffff
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x0, z0.d, sxtw #3]
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 2 x i32> %offsets to <vscale x 2 x i64>
  %ptrs = getelementptr double, double* %base, <vscale x 2 x i64> %offsets.zext
  %vals = call <vscale x 2 x double> @llvm.masked.gather.nxv2f64(<vscale x 2 x double*> %ptrs, i32 8, <vscale x 2 x i1> %mask, <vscale x 2 x double> undef)
  ret <vscale x 2 x double> %vals
}

define <vscale x 2 x i64> @masked_sgather_nxv2i16(i16* %base, <vscale x 2 x i32> %offsets, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_sgather_nxv2i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, #0xffffffff
; CHECK-NEXT:    ld1h { z0.d }, p0/z, [x0, z0.d, sxtw #1]
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    sxth z0.d, p0/m, z0.d
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 2 x i32> %offsets to <vscale x 2 x i64>
  %ptrs = getelementptr i16, i16* %base, <vscale x 2 x i64> %offsets.zext
  %vals = call <vscale x 2 x i16> @llvm.masked.gather.nxv2i16(<vscale x 2 x i16*> %ptrs, i32 2, <vscale x 2 x i1> %mask, <vscale x 2 x i16> undef)
  %vals.sext = sext <vscale x 2 x i16> %vals to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %vals.sext
}

define <vscale x 2 x i64> @masked_sgather_nxv2i32(i32* %base, <vscale x 2 x i32> %offsets, <vscale x 2 x i1> %mask) {
; CHECK-LABEL: masked_sgather_nxv2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and z0.d, z0.d, #0xffffffff
; CHECK-NEXT:    ld1w { z0.d }, p0/z, [x0, z0.d, sxtw #2]
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    sxtw z0.d, p0/m, z0.d
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 2 x i32> %offsets to <vscale x 2 x i64>
  %ptrs = getelementptr i32, i32* %base, <vscale x 2 x i64> %offsets.zext
  %vals = call <vscale x 2 x i32> @llvm.masked.gather.nxv2i32(<vscale x 2 x i32*> %ptrs, i32 4, <vscale x 2 x i1> %mask, <vscale x 2 x i32> undef)
  %vals.sext = sext <vscale x 2 x i32> %vals to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %vals.sext
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; unscaled packed 32-bit offsets
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define <vscale x 4 x i32> @masked_gather_nxv4i16(i16* %base, <vscale x 4 x i32> %offsets, <vscale x 4 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p1.b
; CHECK-NEXT:    uunpklo z1.d, z0.s
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    zip2 p2.s, p0.s, p1.s
; CHECK-NEXT:    zip1 p0.s, p0.s, p1.s
; CHECK-NEXT:    ld1h { z0.d }, p2/z, [x0, z0.d, sxtw #1]
; CHECK-NEXT:    ld1h { z1.d }, p0/z, [x0, z1.d, sxtw #1]
; CHECK-NEXT:    uzp1 z0.s, z1.s, z0.s
; CHECK-NEXT:    and z0.s, z0.s, #0xffff
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 4 x i32> %offsets to <vscale x 4 x i64>
  %ptrs = getelementptr i16, i16* %base, <vscale x 4 x i64> %offsets.zext
  %vals = call <vscale x 4 x i16> @llvm.masked.gather.nxv4i16(<vscale x 4 x i16*> %ptrs, i32 2, <vscale x 4 x i1> %mask, <vscale x 4 x i16> undef)
  %vals.zext = zext <vscale x 4 x i16> %vals to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %vals.zext
}

define <vscale x 4 x i32> @masked_gather_nxv4i32(i32* %base, <vscale x 4 x i32> %offsets, <vscale x 4 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p1.b
; CHECK-NEXT:    uunpklo z1.d, z0.s
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    zip2 p2.s, p0.s, p1.s
; CHECK-NEXT:    zip1 p0.s, p0.s, p1.s
; CHECK-NEXT:    ld1w { z0.d }, p2/z, [x0, z0.d, sxtw #2]
; CHECK-NEXT:    ld1w { z1.d }, p0/z, [x0, z1.d, sxtw #2]
; CHECK-NEXT:    uzp1 z0.s, z1.s, z0.s
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 4 x i32> %offsets to <vscale x 4 x i64>
  %ptrs = getelementptr i32, i32* %base, <vscale x 4 x i64> %offsets.zext
  %vals = call <vscale x 4 x i32> @llvm.masked.gather.nxv4i32(<vscale x 4 x i32*> %ptrs, i32 4, <vscale x 4 x i1> %mask, <vscale x 4 x i32> undef)
  ret <vscale x 4 x i32> %vals
}

define <vscale x 4 x half> @masked_gather_nxv4f16(half* %base, <vscale x 4 x i32> %offsets, <vscale x 4 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv4f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p1.b
; CHECK-NEXT:    uunpklo z1.d, z0.s
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    zip2 p2.s, p0.s, p1.s
; CHECK-NEXT:    zip1 p0.s, p0.s, p1.s
; CHECK-NEXT:    ld1h { z0.d }, p2/z, [x0, z0.d, sxtw #1]
; CHECK-NEXT:    ld1h { z1.d }, p0/z, [x0, z1.d, sxtw #1]
; CHECK-NEXT:    uzp1 z0.s, z1.s, z0.s
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 4 x i32> %offsets to <vscale x 4 x i64>
  %ptrs = getelementptr half, half* %base, <vscale x 4 x i64> %offsets.zext
  %vals = call <vscale x 4 x half> @llvm.masked.gather.nxv4f16(<vscale x 4 x half*> %ptrs, i32 2, <vscale x 4 x i1> %mask, <vscale x 4 x half> undef)
  ret <vscale x 4 x half> %vals
}

define <vscale x 4 x float> @masked_gather_nxv4f32(float* %base, <vscale x 4 x i32> %offsets, <vscale x 4 x i1> %mask) {
; CHECK-LABEL: masked_gather_nxv4f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p1.b
; CHECK-NEXT:    uunpklo z1.d, z0.s
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    zip2 p2.s, p0.s, p1.s
; CHECK-NEXT:    zip1 p0.s, p0.s, p1.s
; CHECK-NEXT:    ld1w { z0.d }, p2/z, [x0, z0.d, sxtw #2]
; CHECK-NEXT:    ld1w { z1.d }, p0/z, [x0, z1.d, sxtw #2]
; CHECK-NEXT:    uzp1 z0.s, z1.s, z0.s
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 4 x i32> %offsets to <vscale x 4 x i64>
  %ptrs = getelementptr float, float* %base, <vscale x 4 x i64> %offsets.zext
  %vals = call <vscale x 4 x float> @llvm.masked.gather.nxv4f32(<vscale x 4 x float*> %ptrs, i32 4, <vscale x 4 x i1> %mask, <vscale x 4 x float> undef)
  ret <vscale x 4 x float> %vals
}

define <vscale x 4 x i32> @masked_sgather_nxv4i16(i16* %base, <vscale x 4 x i32> %offsets, <vscale x 4 x i1> %mask) {
; CHECK-LABEL: masked_sgather_nxv4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    pfalse p1.b
; CHECK-NEXT:    uunpklo z1.d, z0.s
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    zip2 p2.s, p0.s, p1.s
; CHECK-NEXT:    zip1 p0.s, p0.s, p1.s
; CHECK-NEXT:    ld1h { z0.d }, p2/z, [x0, z0.d, sxtw #1]
; CHECK-NEXT:    ld1h { z1.d }, p0/z, [x0, z1.d, sxtw #1]
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    uzp1 z0.s, z1.s, z0.s
; CHECK-NEXT:    sxth z0.s, p0/m, z0.s
; CHECK-NEXT:    ret
  %offsets.zext = zext <vscale x 4 x i32> %offsets to <vscale x 4 x i64>
  %ptrs = getelementptr i16, i16* %base, <vscale x 4 x i64> %offsets.zext
  %vals = call <vscale x 4 x i16> @llvm.masked.gather.nxv4i16(<vscale x 4 x i16*> %ptrs, i32 2, <vscale x 4 x i1> %mask, <vscale x 4 x i16> undef)
  %vals.sext = sext <vscale x 4 x i16> %vals to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %vals.sext
}

declare <vscale x 2 x i16> @llvm.masked.gather.nxv2i16(<vscale x 2 x i16*>, i32, <vscale x 2 x i1>, <vscale x 2 x i16>)
declare <vscale x 2 x i32> @llvm.masked.gather.nxv2i32(<vscale x 2 x i32*>, i32, <vscale x 2 x i1>, <vscale x 2 x i32>)
declare <vscale x 2 x i64> @llvm.masked.gather.nxv2i64(<vscale x 2 x i64*>, i32, <vscale x 2 x i1>, <vscale x 2 x i64>)
declare <vscale x 2 x half> @llvm.masked.gather.nxv2f16(<vscale x 2 x half*>, i32, <vscale x 2 x i1>, <vscale x 2 x half>)
declare <vscale x 2 x float> @llvm.masked.gather.nxv2f32(<vscale x 2 x float*>, i32, <vscale x 2 x i1>, <vscale x 2 x float>)
declare <vscale x 2 x double> @llvm.masked.gather.nxv2f64(<vscale x 2 x double*>, i32, <vscale x 2 x i1>, <vscale x 2 x double>)

declare <vscale x 4 x i16> @llvm.masked.gather.nxv4i16(<vscale x 4 x i16*>, i32, <vscale x 4 x i1>, <vscale x 4 x i16>)
declare <vscale x 4 x i32> @llvm.masked.gather.nxv4i32(<vscale x 4 x i32*>, i32, <vscale x 4 x i1>, <vscale x 4 x i32>)
declare <vscale x 4 x half> @llvm.masked.gather.nxv4f16(<vscale x 4 x half*>, i32, <vscale x 4 x i1>, <vscale x 4 x half>)
declare <vscale x 4 x float> @llvm.masked.gather.nxv4f32(<vscale x 4 x float*>, i32, <vscale x 4 x i1>, <vscale x 4 x float>)
