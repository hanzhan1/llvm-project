; RUN: llc -mtriple=aarch64--linux-gnu -mattr=+sve %s -o - | FileCheck %s

;
; Compares
;

define i32 @cmphi_nxv16i8(<vscale x 16 x i1> %pg, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b) {
; CHECK-LABEL: cmphi_nxv16i8:
; CHECK: cmphi p0.b, p0/z, z0.b, z1.b
; CHECK-NEXT: cset w0, ne
; CHECK-NEXT: ret
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.cmphi.nxv16i8(<vscale x 16 x i1> %pg, <vscale x 16 x i8> %a, <vscale x 16 x i8> %b)
  %2 = tail call i1 @llvm.aarch64.sve.ptest.any(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %1)
  %conv = zext i1 %2 to i32
  ret i32 %conv
}

;
; Immediate Compares
;

define i32 @cmphi_imm_nxv16i8(<vscale x 16 x i1> %pg, <vscale x 16 x i8> %a) {
; CHECK-LABEL: cmphi_imm_nxv16i8:
; CHECK: cmphi p0.b, p0/z, z0.b, #0
; CHECK-NEXT: cset w0, ne
; CHECK-NEXT: ret
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.cmphi.nxv16i8(<vscale x 16 x i1> %pg, <vscale x 16 x i8> %a, <vscale x 16 x i8> zeroinitializer)
  %2 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32 31)
  %3 = tail call i1 @llvm.aarch64.sve.ptest.any(<vscale x 16 x i1> %2, <vscale x 16 x i1> %1)
  %conv = zext i1 %3 to i32
  ret i32 %conv
}

;
; Wide Compares
;

define i32 @cmphi_wide_nxv16i8(<vscale x 16 x i1> %pg, <vscale x 16 x i8> %a, <vscale x 2 x i64> %b) {
; CHECK-LABEL: cmphi_wide_nxv16i8:
; CHECK: cmphi p0.b, p0/z, z0.b, z1.d
; CHECK-NEXT: cset w0, ne
; CHECK-NEXT: ret
  %1 = tail call <vscale x 16 x i1> @llvm.aarch64.sve.cmphi.wide.nxv16i8(<vscale x 16 x i1> %pg, <vscale x 16 x i8> %a, <vscale x 2 x i64> %b)
  %2 = tail call i1 @llvm.aarch64.sve.ptest.any(<vscale x 16 x i1> %pg, <vscale x 16 x i1> %1)
  %conv = zext i1 %2 to i32
  ret i32 %conv
}

declare <vscale x 16 x i1> @llvm.aarch64.sve.cmphi.nxv16i8(<vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 16 x i8>)
declare <vscale x 16 x i1> @llvm.aarch64.sve.cmphi.wide.nxv16i8(<vscale x 16 x i1>, <vscale x 16 x i8>, <vscale x 2 x i64>)

declare i1 @llvm.aarch64.sve.ptest.any(<vscale x 16 x i1>, <vscale x 16 x i1>)

declare <vscale x 16 x i1> @llvm.aarch64.sve.ptrue.nxv16i1(i32)
