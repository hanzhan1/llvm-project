; RUN: opt -S -loop-vectorize -force-vector-width=4 -force-vector-interleave=1 < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; PR39417
; Check that the need for overflow check prevents vectorizing a loop with tiny
; trip count (which implies opt for size).
; CHECK-LABEL: @func_34
; CHECK-NOT: vector.scevcheck
; CHECK-NOT: vector.body:
; CHECK-LABEL: bb67:
define void @func_34() {
bb1:
  br label %bb67

bb67:
  %storemerge2 = phi i32 [ 0, %bb1 ], [ %_tmp2300, %bb67 ]
  %sext = shl i32 %storemerge2, 16
  %_tmp2299 = ashr exact i32 %sext, 16
  %_tmp2300 = add nsw i32 %_tmp2299, 1
  %_tmp2310 = trunc i32 %_tmp2300 to i16
  %_tmp2312 = icmp slt i16 %_tmp2310, 3
  br i1 %_tmp2312, label %bb67, label %bb68

bb68:
  ret void
}

; Check that a loop under opt-for-size is vectorized, w/o checking for
; stride==1.
; NOTE: Some assertions have been autogenerated by utils/update_test_checks.py
define void @scev4stride1(i32* noalias nocapture %a, i32* noalias nocapture readonly %b, i32 %k) #0 {
; CHECK-LABEL: @scev4stride1(
; CHECK-NEXT:  for.body.preheader:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i32> poison, i32 [[K:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <4 x i32> [ <i32 0, i32 1, i32 2, i32 3>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[INDEX]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[INDEX]], 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[INDEX]], 3
; CHECK-NEXT:    [[TMP4:%.*]] = mul nsw <4 x i32> [[VEC_IND]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x i32> [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds i32, i32* [[B:%.*]], i32 [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = extractelement <4 x i32> [[TMP4]], i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[TMP7]]
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <4 x i32> [[TMP4]], i32 2
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <4 x i32> [[TMP4]], i32 3
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i32, i32* [[B]], i32 [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = load i32, i32* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP14:%.*]] = load i32, i32* [[TMP8]], align 4
; CHECK-NEXT:    [[TMP15:%.*]] = load i32, i32* [[TMP10]], align 4
; CHECK-NEXT:    [[TMP16:%.*]] = load i32, i32* [[TMP12]], align 4
; CHECK-NEXT:    [[TMP17:%.*]] = insertelement <4 x i32> poison, i32 [[TMP13]], i32 0
; CHECK-NEXT:    [[TMP18:%.*]] = insertelement <4 x i32> [[TMP17]], i32 [[TMP14]], i32 1
; CHECK-NEXT:    [[TMP19:%.*]] = insertelement <4 x i32> [[TMP18]], i32 [[TMP15]], i32 2
; CHECK-NEXT:    [[TMP20:%.*]] = insertelement <4 x i32> [[TMP19]], i32 [[TMP16]], i32 3
; CHECK-NEXT:    [[TMP21:%.*]] = getelementptr inbounds i32, i32* [[A:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP22:%.*]] = getelementptr inbounds i32, i32* [[TMP21]], i32 0
; CHECK-NEXT:    [[TMP23:%.*]] = bitcast i32* [[TMP22]] to <4 x i32>*
; CHECK-NEXT:    store <4 x i32> [[TMP20]], <4 x i32>* [[TMP23]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 4
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <4 x i32> [[VEC_IND]], <i32 4, i32 4, i32 4, i32 4>
; CHECK-NEXT:    [[TMP24:%.*]] = icmp eq i32 [[INDEX_NEXT]], 1024
; CHECK-NEXT:    br i1 [[TMP24]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !0
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 1024, 1024
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END_LOOPEXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK:       for.body:
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    ret void
;
for.body.preheader:
  br label %for.body

for.body:
  %i.07 = phi i32 [ %inc, %for.body ], [ 0, %for.body.preheader ]
  %mul = mul nsw i32 %i.07, %k
  %arrayidx = getelementptr inbounds i32, i32* %b, i32 %mul
  %0 = load i32, i32* %arrayidx, align 4
  %arrayidx1 = getelementptr inbounds i32, i32* %a, i32 %i.07
  store i32 %0, i32* %arrayidx1, align 4
  %inc = add nuw nsw i32 %i.07, 1
  %exitcond = icmp eq i32 %inc, 1024
  br i1 %exitcond, label %for.end.loopexit, label %for.body

for.end.loopexit:
  ret void
}

attributes #0 = { optsize }
