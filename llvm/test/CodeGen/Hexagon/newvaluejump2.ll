; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon -mcpu=hexagonv5 -disable-hexagon-misched < %s \
; RUN:    | FileCheck %s
; Check that we generate new value jump, both registers, with one
; of the registers as new.

@Reg = common global i32 0, align 4
define i32 @main() nounwind {
; CHECK-LABEL: main:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    {
; CHECK-NEXT:     r1 = memw(gp+#Reg)
; CHECK-NEXT:     allocframe(r29,#8):raw
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = memw(r29+#4)
; CHECK-NEXT:     if (!cmp.gt(r0.new,r1)) jump:nt .LBB0_1
; CHECK-NEXT:    }
; CHECK-NEXT:  // %bb.2: // %if.else
; CHECK-NEXT:    {
; CHECK-NEXT:     call baz
; CHECK-NEXT:     r1:0 = combine(#20,#10)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #0
; CHECK-NEXT:     dealloc_return
; CHECK-NEXT:    }
; CHECK-NEXT:  .LBB0_1: // %if.then
; CHECK-NEXT:    {
; CHECK-NEXT:     call bar
; CHECK-NEXT:     r1:0 = combine(#2,#1)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #0
; CHECK-NEXT:     dealloc_return
; CHECK-NEXT:    }
entry:
  %Reg2 = alloca i32, align 4
  %0 = load i32, i32* %Reg2, align 4
  %1 = load i32, i32* @Reg, align 4
  %tobool = icmp sle i32 %0, %1
  br i1 %tobool, label %if.then, label %if.else

if.then:
  call void @bar(i32 1, i32 2)
  br label %if.end

if.else:
  call void @baz(i32 10, i32 20)
  br label %if.end

if.end:
  ret i32 0
}

declare void @bar(i32, i32)
declare void @baz(i32, i32)
