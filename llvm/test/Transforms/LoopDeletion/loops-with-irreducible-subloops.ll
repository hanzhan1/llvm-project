; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-deletion -verify-dom-info -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64"

define void @irreducible_subloop_no_mustprogress(i1 %c1, i1 %c2, i1 %c3) {
; CHECK-LABEL: @irreducible_subloop_no_mustprogress(
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br label %loop1

loop1:
  br i1 %c1, label %loop1.bb1, label %irr.bb1

loop1.bb1:
  br label %irr.bb2

irr.bb1:
  br i1 %c2, label %loop1.latch, label %irr.bb2

irr.bb2:
  br i1 %c3, label %loop1.latch, label %irr.bb1

loop1.latch:
  br i1 false, label %loop1, label %exit

exit:
  ret void
}

define void @irreducible_subloop_with_mustprogress(i1 %c1, i1 %c2, i1 %c3) mustprogress {
; CHECK-LABEL: @irreducible_subloop_with_mustprogress(
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br label %loop1

loop1:
  br i1 %c1, label %loop1.bb1, label %irr.bb1

loop1.bb1:
  br label %irr.bb2

irr.bb1:
  br i1 %c2, label %loop1.latch, label %irr.bb2

irr.bb2:
  br i1 %c3, label %loop1.latch, label %irr.bb1

loop1.latch:
  br i1 false, label %loop1, label %exit

exit:
  ret void
}
