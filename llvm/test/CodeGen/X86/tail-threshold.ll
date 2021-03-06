; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-pc-linux-gnu -tail-merge-threshold 2 < %s | FileCheck %s

; Test that we still do some merging if a block has more than
; tail-merge-threshold predecessors.

declare void @bar()

define void @foo(i32 %xxx) nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    cmpl $3, %edi
; CHECK-NEXT:    ja .LBB0_4
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    jmpq *.LJTI0_0(,%rax,8)
; CHECK-NEXT:  .LBB0_3: # %bb3
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB0_4: # %bb4
; CHECK-NEXT:    callq bar@PLT
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    retq
  switch i32 %xxx, label %bb4 [
    i32 0, label %bb0
    i32 1, label %bb1
    i32 2, label %bb2
    i32 3, label %bb3
  ]

bb0:
  call void @bar()
  br label %bb5

bb1:
 call void @bar()
 br label %bb5

bb2:
  call void @bar()
  br label %bb5

bb3:
  call void @bar()
  br label %bb5

bb4:
  call void @bar()
  br label %bb5

bb5:
  ret void
}
