; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -early-cse -earlycse-debug-hash -S < %s | FileCheck %s
; RUN: opt -basic-aa -early-cse-memssa -S < %s | FileCheck %s

define i32 @test_01(i32 %a, i32 %b) {
; CHECK-LABEL: @test_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    ret i32 [[A]]
; CHECK:       if.false:
; CHECK-NEXT:    ret i32 [[B]]
;
entry:
  %cond = icmp slt i32 %a, %b
  br i1 %cond, label %if.true, label %if.false

if.true:
  %cond2 = icmp slt i32 %a, %b
  %x = select i1 %cond2, i32 %a, i32 %b
  ret i32 %x

if.false:
  %cond3 = icmp slt i32 %a, %b
  %y = select i1 %cond3, i32 %a, i32 %b
  ret i32 %y
}

define i32 @test_02(i32 %a, i32 %b, i1 %c) {
; CHECK-LABEL: @test_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND_COND:%.*]] = and i1 [[COND]], [[C:%.*]]
; CHECK-NEXT:    br i1 [[AND_COND]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    ret i32 [[A]]
; CHECK:       if.false:
; CHECK-NEXT:    [[Y:%.*]] = select i1 [[COND]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    ret i32 [[Y]]
;
entry:
  %cond = icmp slt i32 %a, %b
  %and.cond = and i1 %cond, %c
  br i1 %and.cond, label %if.true, label %if.false

if.true:
  %cond2 = icmp slt i32 %a, %b
  %x = select i1 %cond2, i32 %a, i32 %b
  ret i32 %x

if.false:
  %cond3 = icmp slt i32 %a, %b
  %y = select i1 %cond3, i32 %a, i32 %b
  ret i32 %y
}

define i32 @test_03(i32 %a, i32 %b, i1 %c) {
; CHECK-LABEL: @test_03(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[OR_COND:%.*]] = or i1 [[COND]], [[C:%.*]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    [[X:%.*]] = select i1 [[COND]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    ret i32 [[X]]
; CHECK:       if.false:
; CHECK-NEXT:    ret i32 [[B]]
;
entry:
  %cond = icmp slt i32 %a, %b
  %or.cond = or i1 %cond, %c
  br i1 %or.cond, label %if.true, label %if.false

if.true:
  %cond2 = icmp slt i32 %a, %b
  %x = select i1 %cond2, i32 %a, i32 %b
  ret i32 %x

if.false:
  %cond3 = icmp slt i32 %a, %b
  %y = select i1 %cond3, i32 %a, i32 %b
  ret i32 %y
}

define i32 @test_04(i32 %a, i32 %b, i1 %c1, i1 %c2) {
; CHECK-LABEL: @test_04(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND_COND1:%.*]] = and i1 [[COND]], [[C1:%.*]]
; CHECK-NEXT:    [[AND_COND2:%.*]] = and i1 [[AND_COND1]], [[C2:%.*]]
; CHECK-NEXT:    br i1 [[AND_COND2]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    ret i32 [[A]]
; CHECK:       if.false:
; CHECK-NEXT:    [[Y:%.*]] = select i1 [[COND]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    ret i32 [[Y]]
;
entry:
  %cond = icmp slt i32 %a, %b
  %and.cond1 = and i1 %cond, %c1
  %and.cond2 = and i1 %and.cond1, %c2
  br i1 %and.cond2, label %if.true, label %if.false

if.true:
  %cond2 = icmp slt i32 %a, %b
  %x = select i1 %cond2, i32 %a, i32 %b
  ret i32 %x

if.false:
  %cond3 = icmp slt i32 %a, %b
  %y = select i1 %cond3, i32 %a, i32 %b
  ret i32 %y
}

define i32 @test_05(i32 %a, i32 %b, i1 %c1, i1 %c2) {
; CHECK-LABEL: @test_05(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[OR_COND1:%.*]] = or i1 [[COND]], [[C1:%.*]]
; CHECK-NEXT:    [[OR_COND2:%.*]] = or i1 [[OR_COND1]], [[C2:%.*]]
; CHECK-NEXT:    br i1 [[OR_COND2]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    [[X:%.*]] = select i1 [[COND]], i32 [[A]], i32 [[B]]
; CHECK-NEXT:    ret i32 [[X]]
; CHECK:       if.false:
; CHECK-NEXT:    ret i32 [[B]]
;
entry:
  %cond = icmp slt i32 %a, %b
  %or.cond1 = or i1 %cond, %c1
  %or.cond2 = or i1 %or.cond1, %c2
  br i1 %or.cond2, label %if.true, label %if.false

if.true:
  %cond2 = icmp slt i32 %a, %b
  %x = select i1 %cond2, i32 %a, i32 %b
  ret i32 %x

if.false:
  %cond3 = icmp slt i32 %a, %b
  %y = select i1 %cond3, i32 %a, i32 %b
  ret i32 %y
}
