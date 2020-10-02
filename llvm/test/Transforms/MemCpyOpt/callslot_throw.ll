; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -memcpyopt < %s | FileCheck %s
declare void @may_throw(i32* nocapture %x)

define void @test1(i32* nocapture noalias dereferenceable(4) %x) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[T:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @may_throw(i32* nonnull [[T]])
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[T]], align 4
; CHECK-NEXT:    store i32 [[LOAD]], i32* [[X:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %t = alloca i32, align 4
  call void @may_throw(i32* nonnull %t)
  %load = load i32, i32* %t, align 4
  store i32 %load, i32* %x, align 4
  ret void
}

declare void @always_throws()

define void @test2(i32* nocapture noalias dereferenceable(4) %x) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[T:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @may_throw(i32* nonnull [[T]]) [[ATTR0:#.*]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i32, i32* [[T]], align 4
; CHECK-NEXT:    call void @always_throws()
; CHECK-NEXT:    store i32 [[LOAD]], i32* [[X:%.*]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %t = alloca i32, align 4
  call void @may_throw(i32* nonnull %t) nounwind
  %load = load i32, i32* %t, align 4
  call void @always_throws()
  store i32 %load, i32* %x, align 4
  ret void
}
