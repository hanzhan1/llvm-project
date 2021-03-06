; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s
; PR1356

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64"
target triple = "i686-apple-darwin8"

define i32 @main() {
; CHECK-LABEL: main:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    ## InlineAsm Start
; CHECK-NEXT:    bsrl {{\.?LCPI[0-9]+_[0-9]+}}, %eax
; CHECK-NEXT:    ## InlineAsm End
; CHECK-NEXT:    retl
entry:
        %tmp4 = tail call i32 asm "bsrl  $1, $0", "=r,ro,~{dirflag},~{fpsr},~{flags},~{cc}"( i32 10 )           ; <i32> [#uses=1]
        ret i32 %tmp4
}

