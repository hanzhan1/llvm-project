; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -jump-threading -S < %s | FileCheck %s

declare void @f()
declare void @g()
declare void @h()

define i32 @test(i1 %cond, i1 %a, i1 %b) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[A:%.*]], label [[C:%.*]]
; CHECK:       A:
; CHECK-NEXT:    call void @f()
; CHECK-NEXT:    br i1 [[A:%.*]], label [[EXIT1:%.*]], label [[EXIT2:%.*]]
; CHECK:       C:
; CHECK-NEXT:    call void @g()
; CHECK-NEXT:    br i1 [[B:%.*]], label [[EXIT1]], label [[EXIT2]]
; CHECK:       EXIT1:
; CHECK-NEXT:    ret i32 0
; CHECK:       EXIT2:
; CHECK-NEXT:    ret i32 1
;
  br i1 %cond, label %A, label %B
A:
  call void @f()
  br label %C
B:
  call void @g()
  br label %C
C:
  %p = phi i1 [%a, %A], [%b, %B] ; Check that this is removed
  br i1 %p, label %EXIT1, label %EXIT2
EXIT1:
  ret i32 0
EXIT2:
  ret i32 1
}

define i32 @test2(i1 %cond, i1 %a, i1 %b) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[A:%.*]], label [[C:%.*]]
; CHECK:       A:
; CHECK-NEXT:    call void @f()
; CHECK-NEXT:    [[P_FR1:%.*]] = freeze i1 [[A:%.*]]
; CHECK-NEXT:    br i1 [[P_FR1]], label [[EXIT1:%.*]], label [[EXIT2:%.*]]
; CHECK:       C:
; CHECK-NEXT:    call void @g()
; CHECK-NEXT:    [[P_FR:%.*]] = freeze i1 [[B:%.*]]
; CHECK-NEXT:    br i1 [[P_FR]], label [[EXIT1]], label [[EXIT2]]
; CHECK:       EXIT1:
; CHECK-NEXT:    ret i32 0
; CHECK:       EXIT2:
; CHECK-NEXT:    ret i32 1
;
  br i1 %cond, label %A, label %B
A:
  call void @f()
  br label %C
B:
  call void @g()
  br label %C
C:
  %p = phi i1 [%a, %A], [%b, %B] ; Check that this is removed
  %p.fr = freeze i1 %p
  br i1 %p.fr, label %EXIT1, label %EXIT2
EXIT1:
  ret i32 0
EXIT2:
  ret i32 1
}
