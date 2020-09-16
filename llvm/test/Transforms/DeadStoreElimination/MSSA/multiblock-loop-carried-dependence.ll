; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; RUN: opt -dse -enable-dse-memoryssa -S %s | FileCheck %s

target datalayout = "e-m:e-i64:64-n32:64-v256:256:256-v512:512:512"

declare void @use(i32)

; Test cases with a loop carried dependence in %loop.2, where %l.2 reads the
; value stored by the previous iteration. Hence, the store in %loop.2 is not
; dead at the end of the function or after the call to lifetime.end().

define void @test.1() {
; CHECK-LABEL: @test.1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [100 x i32], align 4
; CHECK-NEXT:    br label [[LOOP_1:%.*]]
; CHECK:       loop.1:
; CHECK-NEXT:    [[IV_1:%.*]] = phi i64 [ 1, [[ENTRY:%.*]] ], [ [[IV_1_NEXT:%.*]], [[LOOP_1]] ]
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* [[A]], i64 0, i64 [[IV_1]]
; CHECK-NEXT:    store i32 0, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    [[IV_1_NEXT]] = add nsw i64 [[IV_1]], 1
; CHECK-NEXT:    [[C_1:%.*]] = icmp slt i64 [[IV_1_NEXT]], 100
; CHECK-NEXT:    br i1 [[C_1]], label [[LOOP_1]], label [[LOOP_2_PH:%.*]]
; CHECK:       loop.2.ph:
; CHECK-NEXT:    br label [[LOOP_2:%.*]]
; CHECK:       loop.2:
; CHECK-NEXT:    [[IV_2:%.*]] = phi i64 [ [[IV_2_NEXT:%.*]], [[LOOP_2]] ], [ 0, [[LOOP_2_PH]] ]
; CHECK-NEXT:    [[PTR_IV_2:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* [[A]], i64 0, i64 [[IV_2]]
; CHECK-NEXT:    [[L_0:%.*]] = load i32, i32* [[PTR_IV_2]], align 4
; CHECK-NEXT:    call void @use(i32 [[L_0]])
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[IV_2]], 1
; CHECK-NEXT:    [[PTR_IV_2_ADD_1:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* [[A]], i64 0, i64 [[ADD]]
; CHECK-NEXT:    store i32 10, i32* [[PTR_IV_2_ADD_1]], align 4
; CHECK-NEXT:    [[L_1:%.*]] = load i32, i32* [[PTR_IV_2]], align 4
; CHECK-NEXT:    call void @use(i32 [[L_1]])
; CHECK-NEXT:    [[IV_2_NEXT]] = add nsw i64 [[IV_2]], 1
; CHECK-NEXT:    [[C_2:%.*]] = icmp slt i64 [[IV_2_NEXT]], 100
; CHECK-NEXT:    br i1 [[C_2]], label [[LOOP_2]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %A = alloca [100 x i32], align 4
  br label %loop.1

loop.1:
  %iv.1 = phi i64 [ 1, %entry ], [ %iv.1.next, %loop.1 ]
  %arrayidx1 = getelementptr inbounds [100 x i32], [100 x i32]* %A, i64 0, i64 %iv.1
  store i32 0, i32* %arrayidx1, align 4
  %iv.1.next = add nsw i64 %iv.1, 1
  %c.1 = icmp slt i64 %iv.1.next, 100
  br i1 %c.1, label %loop.1, label %loop.2.ph

loop.2.ph:
  br label %loop.2

loop.2:
  %iv.2 = phi i64 [ %iv.2.next, %loop.2 ], [ 0, %loop.2.ph ]
  %ptr.iv.2 = getelementptr inbounds [100 x i32], [100 x i32]* %A, i64 0, i64 %iv.2
  %l.0 = load i32, i32* %ptr.iv.2, align 4
  call void @use(i32 %l.0)
  %add = add nsw i64 %iv.2, 1
  %ptr.iv.2.add.1 = getelementptr inbounds [100 x i32], [100 x i32]* %A, i64 0, i64 %add
  store i32 10, i32* %ptr.iv.2.add.1, align 4
  %l.1 = load i32, i32* %ptr.iv.2, align 4
  call void @use(i32 %l.1)
  %iv.2.next = add nsw i64 %iv.2, 1
  %c.2 = icmp slt i64 %iv.2.next, 100
  br i1 %c.2, label %loop.2, label %exit

exit:
  ret void
}

define void @test.2() {
; CHECK-LABEL: @test.2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [100 x i32], align 4
; CHECK-NEXT:    [[A_CAST:%.*]] = bitcast [100 x i32]* [[A]] to i8*
; CHECK-NEXT:    br label [[LOOP_1:%.*]]
; CHECK:       loop.1:
; CHECK-NEXT:    [[IV_1:%.*]] = phi i64 [ 1, [[ENTRY:%.*]] ], [ [[IV_1_NEXT:%.*]], [[LOOP_1]] ]
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* [[A]], i64 0, i64 [[IV_1]]
; CHECK-NEXT:    store i32 0, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    [[IV_1_NEXT]] = add nsw i64 [[IV_1]], 1
; CHECK-NEXT:    [[C_1:%.*]] = icmp slt i64 [[IV_1_NEXT]], 100
; CHECK-NEXT:    br i1 [[C_1]], label [[LOOP_1]], label [[LOOP_2_PH:%.*]]
; CHECK:       loop.2.ph:
; CHECK-NEXT:    br label [[LOOP_2:%.*]]
; CHECK:       loop.2:
; CHECK-NEXT:    [[IV_2:%.*]] = phi i64 [ [[IV_2_NEXT:%.*]], [[LOOP_2]] ], [ 0, [[LOOP_2_PH]] ]
; CHECK-NEXT:    [[PTR_IV_2:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* [[A]], i64 0, i64 [[IV_2]]
; CHECK-NEXT:    [[L_0:%.*]] = load i32, i32* [[PTR_IV_2]], align 4
; CHECK-NEXT:    call void @use(i32 [[L_0]])
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i64 [[IV_2]], 1
; CHECK-NEXT:    [[PTR_IV_2_ADD_1:%.*]] = getelementptr inbounds [100 x i32], [100 x i32]* [[A]], i64 0, i64 [[ADD]]
; CHECK-NEXT:    store i32 10, i32* [[PTR_IV_2_ADD_1]], align 4
; CHECK-NEXT:    [[L_1:%.*]] = load i32, i32* [[PTR_IV_2]], align 4
; CHECK-NEXT:    call void @use(i32 [[L_1]])
; CHECK-NEXT:    [[IV_2_NEXT]] = add nsw i64 [[IV_2]], 1
; CHECK-NEXT:    [[C_2:%.*]] = icmp slt i64 [[IV_2_NEXT]], 100
; CHECK-NEXT:    br i1 [[C_2]], label [[LOOP_2]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 400, i8* nonnull [[A_CAST]])
; CHECK-NEXT:    ret void
;
entry:
  %A = alloca [100 x i32], align 4
  %A.cast = bitcast [100 x i32]* %A to i8*
  br label %loop.1

loop.1:
  %iv.1 = phi i64 [ 1, %entry ], [ %iv.1.next, %loop.1 ]
  %arrayidx1 = getelementptr inbounds [100 x i32], [100 x i32]* %A, i64 0, i64 %iv.1
  store i32 0, i32* %arrayidx1, align 4
  %iv.1.next = add nsw i64 %iv.1, 1
  %c.1 = icmp slt i64 %iv.1.next, 100
  br i1 %c.1, label %loop.1, label %loop.2.ph

loop.2.ph:
  br label %loop.2

loop.2:
  %iv.2 = phi i64 [ %iv.2.next, %loop.2 ], [ 0, %loop.2.ph ]
  %ptr.iv.2 = getelementptr inbounds [100 x i32], [100 x i32]* %A, i64 0, i64 %iv.2
  %l.0 = load i32, i32* %ptr.iv.2, align 4
  call void @use(i32 %l.0)
  %add = add nsw i64 %iv.2, 1
  %ptr.iv.2.add.1 = getelementptr inbounds [100 x i32], [100 x i32]* %A, i64 0, i64 %add
  store i32 10, i32* %ptr.iv.2.add.1, align 4
  %l.1 = load i32, i32* %ptr.iv.2, align 4
  call void @use(i32 %l.1)
  %iv.2.next = add nsw i64 %iv.2, 1
  %c.2 = icmp slt i64 %iv.2.next, 100
  br i1 %c.2, label %loop.2, label %exit

exit:
  call void @llvm.lifetime.end.p0i8(i64 400, i8* nonnull %A.cast) #5
  ret void
}

declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)

; Make sure `store i32 10, i32* %ptr.2` in %cond.store is not removed. The
; stored value may be read by `%use = load i32, i32* %ptr.1` in a future
; iteration.
define void@test.3() {
; CHECK-LABEL: @test.3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NODESTACK:%.*]] = alloca [12 x i32], align 4
; CHECK-NEXT:    [[NODESTACK_CAST:%.*]] = bitcast [12 x i32]* [[NODESTACK]] to i8*
; CHECK-NEXT:    [[C_1:%.*]] = call i1 @cond(i32 1)
; CHECK-NEXT:    br i1 [[C_1]], label [[CLEANUP:%.*]], label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[DEPTH_1:%.*]] = phi i32 [ [[DEPTH_1_BE:%.*]], [[LOOP_LATCH:%.*]] ], [ 3, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[DEPTH_1]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_READ:%.*]], label [[COND_STORE:%.*]]
; CHECK:       cond.read:
; CHECK-NEXT:    [[SUB:%.*]] = add nsw i32 [[DEPTH_1]], -3
; CHECK-NEXT:    [[PTR_1:%.*]] = getelementptr inbounds [12 x i32], [12 x i32]* [[NODESTACK]], i32 0, i32 [[SUB]]
; CHECK-NEXT:    [[USE:%.*]] = load i32, i32* [[PTR_1]], align 4
; CHECK-NEXT:    [[C_2:%.*]] = call i1 @cond(i32 [[USE]])
; CHECK-NEXT:    br i1 [[C_2]], label [[LOOP_LATCH]], label [[COND_STORE]]
; CHECK:       cond.store:
; CHECK-NEXT:    [[PTR_2:%.*]] = getelementptr inbounds [12 x i32], [12 x i32]* [[NODESTACK]], i32 0, i32 [[DEPTH_1]]
; CHECK-NEXT:    store i32 10, i32* [[PTR_2]], align 4
; CHECK-NEXT:    [[INC:%.*]] = add nsw i32 [[DEPTH_1]], 1
; CHECK-NEXT:    [[C_3:%.*]] = call i1 @cond(i32 20)
; CHECK-NEXT:    br i1 [[C_3]], label [[CLEANUP]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[DEPTH_1_BE]] = phi i32 [ [[SUB]], [[COND_READ]] ], [ [[INC]], [[COND_STORE]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER]]
; CHECK:       cleanup:
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull [[NODESTACK_CAST]])
; CHECK-NEXT:    ret void
;
entry:
  %nodeStack = alloca [12 x i32], align 4
  %nodeStack.cast = bitcast [12 x i32]* %nodeStack to i8*
  %c.1 = call i1 @cond(i32 1)
  br i1 %c.1, label %cleanup, label %loop.header

loop.header:                                       ; preds = %entry, %while.cond.backedge
  %depth.1 = phi i32 [ %depth.1.be, %loop.latch ], [ 3, %entry ]
  %cmp = icmp sgt i32 %depth.1, 0
  br i1 %cmp, label %cond.read, label %cond.store

cond.read:                                        ; preds = %while.cond
  %sub = add nsw i32 %depth.1, -3
  %ptr.1 = getelementptr inbounds [12 x i32], [12 x i32]* %nodeStack, i32 0, i32 %sub
  %use = load i32, i32* %ptr.1, align 4
  %c.2 = call i1 @cond(i32 %use)
  br i1 %c.2, label %loop.latch, label %cond.store

cond.store:
  %ptr.2 = getelementptr inbounds [12 x i32], [12 x i32]* %nodeStack, i32 0, i32 %depth.1
  store i32 10, i32* %ptr.2, align 4
  %inc = add nsw i32 %depth.1, 1
  %c.3 = call i1 @cond(i32 20)
  br i1 %c.3, label %cleanup, label %loop.latch

loop.latch:
  %depth.1.be = phi i32 [ %sub, %cond.read ], [ %inc, %cond.store ]
  br label %loop.header

cleanup:                                          ; preds = %while.body, %while.end, %entry
  call void @llvm.lifetime.end.p0i8(i64 48, i8* nonnull %nodeStack.cast) #3
  ret void
}

declare i1 @cond(i32)
