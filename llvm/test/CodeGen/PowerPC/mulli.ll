; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mcpu=pwr9 -mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck %s

define i64 @test1(i64 %x) {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulli 3, 3, 625
; CHECK-NEXT:    sldi 3, 3, 36
; CHECK-NEXT:    blr
  %y = mul i64 %x, 42949672960000
  ret i64 %y
}

define i64 @test2(i64 %x) {
; CHECK-LABEL: test2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulli 3, 3, -625
; CHECK-NEXT:    sldi 3, 3, 36
; CHECK-NEXT:    blr
  %y = mul i64 %x, -42949672960000
  ret i64 %y
}

define i64 @test3(i64 %x) {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulli 3, 3, 297
; CHECK-NEXT:    sldi 3, 3, 14
; CHECK-NEXT:    blr
  %y = mul i64 %x, 4866048
  ret i64 %y
}

define i64 @test4(i64 %x) {
; CHECK-LABEL: test4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mulli 3, 3, -297
; CHECK-NEXT:    sldi 3, 3, 14
; CHECK-NEXT:    blr
  %y = mul i64 %x, -4866048
  ret i64 %y
}

define i64 @test5(i64 %x) {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sldi 4, 3, 12
; CHECK-NEXT:    sldi 3, 3, 32
; CHECK-NEXT:    add 3, 3, 4
; CHECK-NEXT:    blr
  %y = mul i64 %x, 4294971392
  ret i64 %y
}

define i64 @test6(i64 %x) {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sldi 4, 3, 12
; CHECK-NEXT:    sldi 3, 3, 32
; CHECK-NEXT:    add 3, 3, 4
; CHECK-NEXT:    neg 3, 3
; CHECK-NEXT:    blr
  %y = mul i64 %x, -4294971392
  ret i64 %y
}

define i64 @test7(i64 %x) {
; CHECK-LABEL: test7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sldi 4, 3, 34
; CHECK-NEXT:    sldi 3, 3, 13
; CHECK-NEXT:    sub 3, 4, 3
; CHECK-NEXT:    blr
  %y = mul i64 %x, 17179860992
  ret i64 %y
}

define i64 @test8(i64 %x) {
; CHECK-LABEL: test8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sldi 4, 3, 13
; CHECK-NEXT:    sldi 3, 3, 34
; CHECK-NEXT:    sub 3, 4, 3
; CHECK-NEXT:    blr
  %y = mul i64 %x, -17179860992
  ret i64 %y
}

define i64 @test9(i64 %x) {
; CHECK-LABEL: test9:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sldi 4, 3, 12
; CHECK-NEXT:    sldi 5, 3, 32
; CHECK-NEXT:    add 4, 5, 4
; CHECK-NEXT:    mulli 3, 3, 8193
; CHECK-NEXT:    sldi 3, 3, 19
; CHECK-NEXT:    sub 3, 4, 3
; CHECK-NEXT:    blr
  %y = mul i64 %x, 4294971392
  %z = mul i64 %x, 4295491584
  %res = sub i64 %y, %z
  ret i64 %res
}

define i64 @test10(i64 %x) {
; CHECK-LABEL: test10:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sldi 4, 3, 34
; CHECK-NEXT:    sldi 3, 3, 30
; CHECK-NEXT:    sub 3, 4, 3
; CHECK-NEXT:    blr
  %y = mul i64 %x, 17179860992
  %z = mul i64 %x, 1073733632
  %res = sub i64 %y, %z
  ret i64 %res
}

