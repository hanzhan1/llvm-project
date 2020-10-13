; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

define <4 x i32> @test_FoldShiftByConstant_CreateSHL(<4 x i32> %in) {
; CHECK-LABEL: @test_FoldShiftByConstant_CreateSHL(
; CHECK-NEXT:    [[VSHL_N:%.*]] = mul <4 x i32> [[IN:%.*]], <i32 0, i32 -32, i32 0, i32 -32>
; CHECK-NEXT:    ret <4 x i32> [[VSHL_N]]
;
  %mul.i = mul <4 x i32> %in, <i32 0, i32 -1, i32 0, i32 -1>
  %vshl_n = shl <4 x i32> %mul.i, <i32 5, i32 5, i32 5, i32 5>
  ret <4 x i32> %vshl_n
}

define <8 x i16> @test_FoldShiftByConstant_CreateSHL2(<8 x i16> %in) {
; CHECK-LABEL: @test_FoldShiftByConstant_CreateSHL2(
; CHECK-NEXT:    [[VSHL_N:%.*]] = mul <8 x i16> [[IN:%.*]], <i16 0, i16 -32, i16 0, i16 -32, i16 0, i16 -32, i16 0, i16 -32>
; CHECK-NEXT:    ret <8 x i16> [[VSHL_N]]
;
  %mul.i = mul <8 x i16> %in, <i16 0, i16 -1, i16 0, i16 -1, i16 0, i16 -1, i16 0, i16 -1>
  %vshl_n = shl <8 x i16> %mul.i, <i16 5, i16 5, i16 5, i16 5, i16 5, i16 5, i16 5, i16 5>
  ret <8 x i16> %vshl_n
}

define <16 x i8> @test_FoldShiftByConstant_CreateAnd(<16 x i8> %in0) {
; CHECK-LABEL: @test_FoldShiftByConstant_CreateAnd(
; CHECK-NEXT:    [[TMP1:%.*]] = mul <16 x i8> [[IN0:%.*]], <i8 33, i8 33, i8 33, i8 33, i8 33, i8 33, i8 33, i8 33, i8 33, i8 33, i8 33, i8 33, i8 33, i8 33, i8 33, i8 33>
; CHECK-NEXT:    [[VSHL_N:%.*]] = and <16 x i8> [[TMP1]], <i8 -32, i8 -32, i8 -32, i8 -32, i8 -32, i8 -32, i8 -32, i8 -32, i8 -32, i8 -32, i8 -32, i8 -32, i8 -32, i8 -32, i8 -32, i8 -32>
; CHECK-NEXT:    ret <16 x i8> [[VSHL_N]]
;
  %vsra_n = ashr <16 x i8> %in0, <i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5>
  %tmp = add <16 x i8> %in0, %vsra_n
  %vshl_n = shl <16 x i8> %tmp, <i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5, i8 5>
  ret <16 x i8> %vshl_n
}

define i32 @lshr_add_shl(i32 %x, i32 %y) {
; CHECK-LABEL: @lshr_add_shl(
; CHECK-NEXT:    [[B1:%.*]] = shl i32 [[Y:%.*]], 4
; CHECK-NEXT:    [[A2:%.*]] = add i32 [[B1]], [[X:%.*]]
; CHECK-NEXT:    [[C:%.*]] = and i32 [[A2]], -16
; CHECK-NEXT:    ret i32 [[C]]
;
  %a = lshr i32 %x, 4
  %b = add i32 %a, %y
  %c = shl i32 %b, 4
  ret i32 %c
}

define <2 x i32> @lshr_add_shl_v2i32(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @lshr_add_shl_v2i32(
; CHECK-NEXT:    [[B1:%.*]] = shl <2 x i32> [[Y:%.*]], <i32 5, i32 5>
; CHECK-NEXT:    [[A2:%.*]] = add <2 x i32> [[B1]], [[X:%.*]]
; CHECK-NEXT:    [[C:%.*]] = and <2 x i32> [[A2]], <i32 -32, i32 -32>
; CHECK-NEXT:    ret <2 x i32> [[C]]
;
  %a = lshr <2 x i32> %x, <i32 5, i32 5>
  %b = add <2 x i32> %a, %y
  %c = shl <2 x i32> %b, <i32 5, i32 5>
  ret <2 x i32> %c
}

define <2 x i32> @lshr_add_shl_v2i32_undef(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @lshr_add_shl_v2i32_undef(
; CHECK-NEXT:    [[A:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 5, i32 undef>
; CHECK-NEXT:    [[B:%.*]] = add <2 x i32> [[A]], [[Y:%.*]]
; CHECK-NEXT:    [[C:%.*]] = shl <2 x i32> [[B]], <i32 undef, i32 5>
; CHECK-NEXT:    ret <2 x i32> [[C]]
;
  %a = lshr <2 x i32> %x, <i32 5, i32 undef>
  %b = add <2 x i32> %a, %y
  %c = shl <2 x i32> %b, <i32 undef, i32 5>
  ret <2 x i32> %c
}

define <2 x i32> @lshr_add_shl_v2i32_nonuniform(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @lshr_add_shl_v2i32_nonuniform(
; CHECK-NEXT:    [[A:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 5, i32 6>
; CHECK-NEXT:    [[B:%.*]] = add <2 x i32> [[A]], [[Y:%.*]]
; CHECK-NEXT:    [[C:%.*]] = shl <2 x i32> [[B]], <i32 5, i32 6>
; CHECK-NEXT:    ret <2 x i32> [[C]]
;
  %a = lshr <2 x i32> %x, <i32 5, i32 6>
  %b = add <2 x i32> %a, %y
  %c = shl <2 x i32> %b, <i32 5, i32 6>
  ret <2 x i32> %c
}

define i32 @lshr_add_and_shl(i32 %x, i32 %y)  {
; CHECK-LABEL: @lshr_add_and_shl(
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 [[Y:%.*]], 5
; CHECK-NEXT:    [[X_MASK:%.*]] = and i32 [[X:%.*]], 4064
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[X_MASK]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %1 = lshr i32 %x, 5
  %2 = and i32 %1, 127
  %3 = add i32 %y, %2
  %4 = shl i32 %3, 5
  ret i32 %4
}

define <2 x i32> @lshr_add_and_shl_v2i32(<2 x i32> %x, <2 x i32> %y)  {
; CHECK-LABEL: @lshr_add_and_shl_v2i32(
; CHECK-NEXT:    [[TMP1:%.*]] = shl <2 x i32> [[Y:%.*]], <i32 5, i32 5>
; CHECK-NEXT:    [[X_MASK:%.*]] = and <2 x i32> [[X:%.*]], <i32 4064, i32 4064>
; CHECK-NEXT:    [[TMP2:%.*]] = add <2 x i32> [[X_MASK]], [[TMP1]]
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %1 = lshr <2 x i32> %x, <i32 5, i32 5>
  %2 = and <2 x i32> %1, <i32 127, i32 127>
  %3 = add <2 x i32> %y, %2
  %4 = shl <2 x i32> %3, <i32 5, i32 5>
  ret <2 x i32> %4
}

define <2 x i32> @lshr_add_and_shl_v2i32_undef(<2 x i32> %x, <2 x i32> %y)  {
; CHECK-LABEL: @lshr_add_and_shl_v2i32_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 undef, i32 5>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP1]], <i32 127, i32 127>
; CHECK-NEXT:    [[TMP3:%.*]] = add <2 x i32> [[TMP2]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = shl <2 x i32> [[TMP3]], <i32 5, i32 undef>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %1 = lshr <2 x i32> %x, <i32 undef, i32 5>
  %2 = and <2 x i32> %1, <i32 127, i32 127>
  %3 = add <2 x i32> %y, %2
  %4 = shl <2 x i32> %3, <i32 5, i32 undef>
  ret <2 x i32> %4
}

define <2 x i32> @lshr_add_and_shl_v2i32_nonuniform(<2 x i32> %x, <2 x i32> %y)  {
; CHECK-LABEL: @lshr_add_and_shl_v2i32_nonuniform(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 5, i32 6>
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP1]], <i32 127, i32 255>
; CHECK-NEXT:    [[TMP3:%.*]] = add <2 x i32> [[TMP2]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = shl <2 x i32> [[TMP3]], <i32 5, i32 6>
; CHECK-NEXT:    ret <2 x i32> [[TMP4]]
;
  %1 = lshr <2 x i32> %x, <i32 5, i32 6>
  %2 = and <2 x i32> %1, <i32 127, i32 255>
  %3 = add <2 x i32> %y, %2
  %4 = shl <2 x i32> %3, <i32 5, i32 6>
  ret <2 x i32> %4
}

define i32 @shl_add_and_lshr(i32 %x, i32 %y) {
; CHECK-LABEL: @shl_add_and_lshr(
; CHECK-NEXT:    [[C1:%.*]] = shl i32 [[Y:%.*]], 4
; CHECK-NEXT:    [[X_MASK:%.*]] = and i32 [[X:%.*]], 128
; CHECK-NEXT:    [[D:%.*]] = add i32 [[X_MASK]], [[C1]]
; CHECK-NEXT:    ret i32 [[D]]
;
  %a = lshr i32 %x, 4
  %b = and i32 %a, 8
  %c = add i32 %b, %y
  %d = shl i32 %c, 4
  ret i32 %d
}

define <2 x i32> @shl_add_and_lshr_v2i32(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @shl_add_and_lshr_v2i32(
; CHECK-NEXT:    [[C1:%.*]] = shl <2 x i32> [[Y:%.*]], <i32 4, i32 4>
; CHECK-NEXT:    [[X_MASK:%.*]] = and <2 x i32> [[X:%.*]], <i32 128, i32 128>
; CHECK-NEXT:    [[D:%.*]] = add <2 x i32> [[X_MASK]], [[C1]]
; CHECK-NEXT:    ret <2 x i32> [[D]]
;
  %a = lshr <2 x i32> %x, <i32 4, i32 4>
  %b = and <2 x i32> %a, <i32 8, i32 8>
  %c = add <2 x i32> %b, %y
  %d = shl <2 x i32> %c, <i32 4, i32 4>
  ret <2 x i32> %d
}

define <2 x i32> @shl_add_and_lshr_v2i32_undef(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @shl_add_and_lshr_v2i32_undef(
; CHECK-NEXT:    [[A:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 4, i32 undef>
; CHECK-NEXT:    [[B:%.*]] = and <2 x i32> [[A]], <i32 8, i32 undef>
; CHECK-NEXT:    [[C:%.*]] = add <2 x i32> [[B]], [[Y:%.*]]
; CHECK-NEXT:    [[D:%.*]] = shl <2 x i32> [[C]], <i32 4, i32 undef>
; CHECK-NEXT:    ret <2 x i32> [[D]]
;
  %a = lshr <2 x i32> %x, <i32 4, i32 undef>
  %b = and <2 x i32> %a, <i32 8, i32 undef>
  %c = add <2 x i32> %b, %y
  %d = shl <2 x i32> %c, <i32 4, i32 undef>
  ret <2 x i32> %d
}

define <2 x i32> @shl_add_and_lshr_v2i32_nonuniform(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @shl_add_and_lshr_v2i32_nonuniform(
; CHECK-NEXT:    [[A:%.*]] = lshr <2 x i32> [[X:%.*]], <i32 4, i32 5>
; CHECK-NEXT:    [[B:%.*]] = and <2 x i32> [[A]], <i32 8, i32 9>
; CHECK-NEXT:    [[C:%.*]] = add <2 x i32> [[B]], [[Y:%.*]]
; CHECK-NEXT:    [[D:%.*]] = shl <2 x i32> [[C]], <i32 4, i32 5>
; CHECK-NEXT:    ret <2 x i32> [[D]]
;
  %a = lshr <2 x i32> %x, <i32 4, i32 5>
  %b = and <2 x i32> %a, <i32 8, i32 9>
  %c = add <2 x i32> %b, %y
  %d = shl <2 x i32> %c, <i32 4, i32 5>
  ret <2 x i32> %d
}
