; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -dse -enable-dse-memoryssa -S %s | FileCheck %s

declare i1 @cond() readnone

define i32 @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[M0:%.*]] = alloca [4 x i32], align 16
; CHECK-NEXT:    br label [[LOOP_1:%.*]]
; CHECK:       loop.1:
; CHECK-NEXT:    br label [[LOOP_2:%.*]]
; CHECK:       loop.2:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[LOOP_1]] ], [ [[IV_NEXT:%.*]], [[LOOP_2]] ]
; CHECK-NEXT:    [[PTR_1:%.*]] = getelementptr inbounds [4 x i32], [4 x i32]* [[M0]], i64 3, i64 [[IV]]
; CHECK-NEXT:    [[PTR_2:%.*]] = getelementptr inbounds [4 x i32], [4 x i32]* [[M0]], i64 0, i64 [[IV]]
; CHECK-NEXT:    store i32 20, i32* [[PTR_2]], align 4
; CHECK-NEXT:    store i32 30, i32* [[PTR_1]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[C_3:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_3]], label [[LOOP_1_LATCH:%.*]], label [[LOOP_2]]
; CHECK:       loop.1.latch:
; CHECK-NEXT:    [[C_2:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[C_2]], label [[EXIT:%.*]], label [[LOOP_1]]
; CHECK:       exit:
; CHECK-NEXT:    [[PTR_3:%.*]] = getelementptr inbounds [4 x i32], [4 x i32]* [[M0]], i64 0, i64 1
; CHECK-NEXT:    [[LV:%.*]] = load i32, i32* [[PTR_3]], align 16
; CHECK-NEXT:    ret i32 [[LV]]
;
entry:
  %M0 = alloca [4 x i32], align 16
  br label %loop.1

loop.1:
  br label %loop.2

loop.2:
  %iv = phi i64 [ 0, %loop.1 ], [ %iv.next, %loop.2 ]
  %ptr.1 = getelementptr inbounds [4 x i32], [4 x i32]* %M0, i64 3, i64 %iv
  store i32 10, i32* %ptr.1, align 4
  %ptr.2 = getelementptr inbounds [4 x i32], [4 x i32]* %M0, i64 0, i64 %iv
  store i32 20, i32* %ptr.2, align 4
  store i32 30, i32* %ptr.1, align 4
  %iv.next = add nuw nsw i64 %iv, 1
  %c.3 = call i1 @cond()
  br i1 %c.3, label %loop.1.latch, label %loop.2

loop.1.latch:
  %c.2 = call i1 @cond()
  br i1 %c.2, label %exit, label %loop.1

exit:
  %ptr.3 = getelementptr inbounds [4 x i32], [4 x i32]* %M0, i64 0, i64 1
  %lv = load i32, i32* %ptr.3, align 16
  ret i32 %lv


}
