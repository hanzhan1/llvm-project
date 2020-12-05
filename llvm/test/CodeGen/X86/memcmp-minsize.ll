; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=cmov | FileCheck %s --check-prefix=X86 --check-prefix=X86-NOSSE
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X86 --check-prefix=X86-SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=X64 --check-prefix=X64-SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx | FileCheck %s --check-prefix=X64 --check-prefix=X64-AVX --check-prefix=X64-AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2 | FileCheck %s --check-prefix=X64 --check-prefix=X64-AVX --check-prefix=X64-AVX2

; This tests codegen time inlining/optimization of memcmp
; rdar://6480398

@.str = private constant [65 x i8] c"0123456789012345678901234567890123456789012345678901234567890123\00", align 1

declare dso_local i32 @memcmp(i8*, i8*, i64)

define i32 @length2(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length2:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $2
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
;
; X64-LABEL: length2:
; X64:       # %bb.0:
; X64-NEXT:    pushq $2
; X64-NEXT:    popq %rdx
; X64-NEXT:    jmp memcmp # TAILCALL
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 2) nounwind
  ret i32 %m
}

define i1 @length2_eq(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length2_eq:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movzwl (%ecx), %ecx
; X86-NEXT:    cmpw (%eax), %cx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: length2_eq:
; X64:       # %bb.0:
; X64-NEXT:    movzwl (%rdi), %eax
; X64-NEXT:    cmpw (%rsi), %ax
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 2) nounwind
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

define i1 @length2_eq_const(i8* %X) nounwind minsize {
; X86-LABEL: length2_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    cmpw $12849, (%eax) # imm = 0x3231
; X86-NEXT:    setne %al
; X86-NEXT:    retl
;
; X64-LABEL: length2_eq_const:
; X64:       # %bb.0:
; X64-NEXT:    cmpw $12849, (%rdi) # imm = 0x3231
; X64-NEXT:    setne %al
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* getelementptr inbounds ([65 x i8], [65 x i8]* @.str, i32 0, i32 1), i64 2) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i1 @length2_eq_nobuiltin_attr(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length2_eq_nobuiltin_attr:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $2
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: length2_eq_nobuiltin_attr:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    pushq $2
; X64-NEXT:    popq %rdx
; X64-NEXT:    callq memcmp
; X64-NEXT:    testl %eax, %eax
; X64-NEXT:    sete %al
; X64-NEXT:    popq %rcx
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 2) nounwind nobuiltin
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

define i32 @length3(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length3:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $3
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
;
; X64-LABEL: length3:
; X64:       # %bb.0:
; X64-NEXT:    pushq $3
; X64-NEXT:    popq %rdx
; X64-NEXT:    jmp memcmp # TAILCALL
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 3) nounwind
  ret i32 %m
}

define i1 @length3_eq(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length3_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $3
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
;
; X64-LABEL: length3_eq:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    pushq $3
; X64-NEXT:    popq %rdx
; X64-NEXT:    callq memcmp
; X64-NEXT:    testl %eax, %eax
; X64-NEXT:    setne %al
; X64-NEXT:    popq %rcx
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 3) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i32 @length4(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length4:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $4
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
;
; X64-LABEL: length4:
; X64:       # %bb.0:
; X64-NEXT:    pushq $4
; X64-NEXT:    popq %rdx
; X64-NEXT:    jmp memcmp # TAILCALL
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 4) nounwind
  ret i32 %m
}

define i1 @length4_eq(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length4_eq:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl (%ecx), %ecx
; X86-NEXT:    cmpl (%eax), %ecx
; X86-NEXT:    setne %al
; X86-NEXT:    retl
;
; X64-LABEL: length4_eq:
; X64:       # %bb.0:
; X64-NEXT:    movl (%rdi), %eax
; X64-NEXT:    cmpl (%rsi), %eax
; X64-NEXT:    setne %al
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 4) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i1 @length4_eq_const(i8* %X) nounwind minsize {
; X86-LABEL: length4_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    cmpl $875770417, (%eax) # imm = 0x34333231
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: length4_eq_const:
; X64:       # %bb.0:
; X64-NEXT:    cmpl $875770417, (%rdi) # imm = 0x34333231
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* getelementptr inbounds ([65 x i8], [65 x i8]* @.str, i32 0, i32 1), i64 4) nounwind
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

define i32 @length5(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length5:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $5
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
;
; X64-LABEL: length5:
; X64:       # %bb.0:
; X64-NEXT:    pushq $5
; X64-NEXT:    popq %rdx
; X64-NEXT:    jmp memcmp # TAILCALL
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 5) nounwind
  ret i32 %m
}

define i1 @length5_eq(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length5_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $5
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
;
; X64-LABEL: length5_eq:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    pushq $5
; X64-NEXT:    popq %rdx
; X64-NEXT:    callq memcmp
; X64-NEXT:    testl %eax, %eax
; X64-NEXT:    setne %al
; X64-NEXT:    popq %rcx
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 5) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i32 @length8(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length8:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $8
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
;
; X64-LABEL: length8:
; X64:       # %bb.0:
; X64-NEXT:    pushq $8
; X64-NEXT:    popq %rdx
; X64-NEXT:    jmp memcmp # TAILCALL
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 8) nounwind
  ret i32 %m
}

define i1 @length8_eq(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length8_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $8
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: length8_eq:
; X64:       # %bb.0:
; X64-NEXT:    movq (%rdi), %rax
; X64-NEXT:    cmpq (%rsi), %rax
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 8) nounwind
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

define i1 @length8_eq_const(i8* %X) nounwind minsize {
; X86-LABEL: length8_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $8
; X86-NEXT:    pushl $.L.str
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
;
; X64-LABEL: length8_eq_const:
; X64:       # %bb.0:
; X64-NEXT:    movabsq $3978425819141910832, %rax # imm = 0x3736353433323130
; X64-NEXT:    cmpq %rax, (%rdi)
; X64-NEXT:    setne %al
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* getelementptr inbounds ([65 x i8], [65 x i8]* @.str, i32 0, i32 0), i64 8) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i1 @length12_eq(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length12_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $12
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
;
; X64-LABEL: length12_eq:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    pushq $12
; X64-NEXT:    popq %rdx
; X64-NEXT:    callq memcmp
; X64-NEXT:    testl %eax, %eax
; X64-NEXT:    setne %al
; X64-NEXT:    popq %rcx
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 12) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i32 @length12(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length12:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $12
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
;
; X64-LABEL: length12:
; X64:       # %bb.0:
; X64-NEXT:    pushq $12
; X64-NEXT:    popq %rdx
; X64-NEXT:    jmp memcmp # TAILCALL
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 12) nounwind
  ret i32 %m
}

; PR33329 - https://bugs.llvm.org/show_bug.cgi?id=33329

define i32 @length16(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length16:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $16
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
;
; X64-LABEL: length16:
; X64:       # %bb.0:
; X64-NEXT:    pushq $16
; X64-NEXT:    popq %rdx
; X64-NEXT:    jmp memcmp # TAILCALL
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 16) nounwind
  ret i32 %m
}

define i1 @length16_eq(i8* %x, i8* %y) nounwind minsize {
; X86-NOSSE-LABEL: length16_eq:
; X86-NOSSE:       # %bb.0:
; X86-NOSSE-NEXT:    pushl $0
; X86-NOSSE-NEXT:    pushl $16
; X86-NOSSE-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NOSSE-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NOSSE-NEXT:    calll memcmp
; X86-NOSSE-NEXT:    addl $16, %esp
; X86-NOSSE-NEXT:    testl %eax, %eax
; X86-NOSSE-NEXT:    setne %al
; X86-NOSSE-NEXT:    retl
;
; X86-SSE2-LABEL: length16_eq:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SSE2-NEXT:    movdqu (%ecx), %xmm0
; X86-SSE2-NEXT:    movdqu (%eax), %xmm1
; X86-SSE2-NEXT:    pcmpeqb %xmm0, %xmm1
; X86-SSE2-NEXT:    pmovmskb %xmm1, %eax
; X86-SSE2-NEXT:    cmpl $65535, %eax # imm = 0xFFFF
; X86-SSE2-NEXT:    setne %al
; X86-SSE2-NEXT:    retl
;
; X64-SSE2-LABEL: length16_eq:
; X64-SSE2:       # %bb.0:
; X64-SSE2-NEXT:    movdqu (%rsi), %xmm0
; X64-SSE2-NEXT:    movdqu (%rdi), %xmm1
; X64-SSE2-NEXT:    pcmpeqb %xmm0, %xmm1
; X64-SSE2-NEXT:    pmovmskb %xmm1, %eax
; X64-SSE2-NEXT:    cmpl $65535, %eax # imm = 0xFFFF
; X64-SSE2-NEXT:    setne %al
; X64-SSE2-NEXT:    retq
;
; X64-AVX-LABEL: length16_eq:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqu (%rdi), %xmm0
; X64-AVX-NEXT:    vpxor (%rsi), %xmm0, %xmm0
; X64-AVX-NEXT:    vptest %xmm0, %xmm0
; X64-AVX-NEXT:    setne %al
; X64-AVX-NEXT:    retq
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 16) nounwind
  %cmp = icmp ne i32 %call, 0
  ret i1 %cmp
}

define i1 @length16_eq_const(i8* %X) nounwind minsize {
; X86-NOSSE-LABEL: length16_eq_const:
; X86-NOSSE:       # %bb.0:
; X86-NOSSE-NEXT:    pushl $0
; X86-NOSSE-NEXT:    pushl $16
; X86-NOSSE-NEXT:    pushl $.L.str
; X86-NOSSE-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NOSSE-NEXT:    calll memcmp
; X86-NOSSE-NEXT:    addl $16, %esp
; X86-NOSSE-NEXT:    testl %eax, %eax
; X86-NOSSE-NEXT:    sete %al
; X86-NOSSE-NEXT:    retl
;
; X86-SSE2-LABEL: length16_eq_const:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    movdqu (%eax), %xmm0
; X86-SSE2-NEXT:    pcmpeqb {{\.LCPI.*}}, %xmm0
; X86-SSE2-NEXT:    pmovmskb %xmm0, %eax
; X86-SSE2-NEXT:    cmpl $65535, %eax # imm = 0xFFFF
; X86-SSE2-NEXT:    sete %al
; X86-SSE2-NEXT:    retl
;
; X64-SSE2-LABEL: length16_eq_const:
; X64-SSE2:       # %bb.0:
; X64-SSE2-NEXT:    movdqu (%rdi), %xmm0
; X64-SSE2-NEXT:    pcmpeqb {{.*}}(%rip), %xmm0
; X64-SSE2-NEXT:    pmovmskb %xmm0, %eax
; X64-SSE2-NEXT:    cmpl $65535, %eax # imm = 0xFFFF
; X64-SSE2-NEXT:    sete %al
; X64-SSE2-NEXT:    retq
;
; X64-AVX-LABEL: length16_eq_const:
; X64-AVX:       # %bb.0:
; X64-AVX-NEXT:    vmovdqu (%rdi), %xmm0
; X64-AVX-NEXT:    vpxor {{.*}}(%rip), %xmm0, %xmm0
; X64-AVX-NEXT:    vptest %xmm0, %xmm0
; X64-AVX-NEXT:    sete %al
; X64-AVX-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* getelementptr inbounds ([65 x i8], [65 x i8]* @.str, i32 0, i32 0), i64 16) nounwind
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

; PR33914 - https://bugs.llvm.org/show_bug.cgi?id=33914

define i32 @length24(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length24:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $24
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
;
; X64-LABEL: length24:
; X64:       # %bb.0:
; X64-NEXT:    pushq $24
; X64-NEXT:    popq %rdx
; X64-NEXT:    jmp memcmp # TAILCALL
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 24) nounwind
  ret i32 %m
}

define i1 @length24_eq(i8* %x, i8* %y) nounwind minsize {
; X86-LABEL: length24_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $24
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: length24_eq:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    pushq $24
; X64-NEXT:    popq %rdx
; X64-NEXT:    callq memcmp
; X64-NEXT:    testl %eax, %eax
; X64-NEXT:    sete %al
; X64-NEXT:    popq %rcx
; X64-NEXT:    retq
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 24) nounwind
  %cmp = icmp eq i32 %call, 0
  ret i1 %cmp
}

define i1 @length24_eq_const(i8* %X) nounwind minsize {
; X86-LABEL: length24_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $24
; X86-NEXT:    pushl $.L.str
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
;
; X64-LABEL: length24_eq_const:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    pushq $24
; X64-NEXT:    popq %rdx
; X64-NEXT:    movl $.L.str, %esi
; X64-NEXT:    callq memcmp
; X64-NEXT:    testl %eax, %eax
; X64-NEXT:    setne %al
; X64-NEXT:    popq %rcx
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* getelementptr inbounds ([65 x i8], [65 x i8]* @.str, i32 0, i32 0), i64 24) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i32 @length32(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length32:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $32
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
;
; X64-LABEL: length32:
; X64:       # %bb.0:
; X64-NEXT:    pushq $32
; X64-NEXT:    popq %rdx
; X64-NEXT:    jmp memcmp # TAILCALL
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 32) nounwind
  ret i32 %m
}

; PR33325 - https://bugs.llvm.org/show_bug.cgi?id=33325

define i1 @length32_eq(i8* %x, i8* %y) nounwind minsize {
; X86-LABEL: length32_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $32
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-SSE2-LABEL: length32_eq:
; X64-SSE2:       # %bb.0:
; X64-SSE2-NEXT:    pushq %rax
; X64-SSE2-NEXT:    pushq $32
; X64-SSE2-NEXT:    popq %rdx
; X64-SSE2-NEXT:    callq memcmp
; X64-SSE2-NEXT:    testl %eax, %eax
; X64-SSE2-NEXT:    sete %al
; X64-SSE2-NEXT:    popq %rcx
; X64-SSE2-NEXT:    retq
;
; X64-AVX1-LABEL: length32_eq:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vmovups (%rdi), %ymm0
; X64-AVX1-NEXT:    vxorps (%rsi), %ymm0, %ymm0
; X64-AVX1-NEXT:    vptest %ymm0, %ymm0
; X64-AVX1-NEXT:    sete %al
; X64-AVX1-NEXT:    vzeroupper
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: length32_eq:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vmovdqu (%rdi), %ymm0
; X64-AVX2-NEXT:    vpxor (%rsi), %ymm0, %ymm0
; X64-AVX2-NEXT:    vptest %ymm0, %ymm0
; X64-AVX2-NEXT:    sete %al
; X64-AVX2-NEXT:    vzeroupper
; X64-AVX2-NEXT:    retq
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 32) nounwind
  %cmp = icmp eq i32 %call, 0
  ret i1 %cmp
}

define i1 @length32_eq_const(i8* %X) nounwind minsize {
; X86-LABEL: length32_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $32
; X86-NEXT:    pushl $.L.str
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
;
; X64-SSE2-LABEL: length32_eq_const:
; X64-SSE2:       # %bb.0:
; X64-SSE2-NEXT:    pushq %rax
; X64-SSE2-NEXT:    pushq $32
; X64-SSE2-NEXT:    popq %rdx
; X64-SSE2-NEXT:    movl $.L.str, %esi
; X64-SSE2-NEXT:    callq memcmp
; X64-SSE2-NEXT:    testl %eax, %eax
; X64-SSE2-NEXT:    setne %al
; X64-SSE2-NEXT:    popq %rcx
; X64-SSE2-NEXT:    retq
;
; X64-AVX1-LABEL: length32_eq_const:
; X64-AVX1:       # %bb.0:
; X64-AVX1-NEXT:    vmovups (%rdi), %ymm0
; X64-AVX1-NEXT:    vxorps {{.*}}(%rip), %ymm0, %ymm0
; X64-AVX1-NEXT:    vptest %ymm0, %ymm0
; X64-AVX1-NEXT:    setne %al
; X64-AVX1-NEXT:    vzeroupper
; X64-AVX1-NEXT:    retq
;
; X64-AVX2-LABEL: length32_eq_const:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vmovdqu (%rdi), %ymm0
; X64-AVX2-NEXT:    vpxor {{.*}}(%rip), %ymm0, %ymm0
; X64-AVX2-NEXT:    vptest %ymm0, %ymm0
; X64-AVX2-NEXT:    setne %al
; X64-AVX2-NEXT:    vzeroupper
; X64-AVX2-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* getelementptr inbounds ([65 x i8], [65 x i8]* @.str, i32 0, i32 0), i64 32) nounwind
  %c = icmp ne i32 %m, 0
  ret i1 %c
}

define i32 @length64(i8* %X, i8* %Y) nounwind minsize {
; X86-LABEL: length64:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $64
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
;
; X64-LABEL: length64:
; X64:       # %bb.0:
; X64-NEXT:    pushq $64
; X64-NEXT:    popq %rdx
; X64-NEXT:    jmp memcmp # TAILCALL
  %m = tail call i32 @memcmp(i8* %X, i8* %Y, i64 64) nounwind
  ret i32 %m
}

define i1 @length64_eq(i8* %x, i8* %y) nounwind minsize {
; X86-LABEL: length64_eq:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $64
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    setne %al
; X86-NEXT:    retl
;
; X64-LABEL: length64_eq:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    pushq $64
; X64-NEXT:    popq %rdx
; X64-NEXT:    callq memcmp
; X64-NEXT:    testl %eax, %eax
; X64-NEXT:    setne %al
; X64-NEXT:    popq %rcx
; X64-NEXT:    retq
  %call = tail call i32 @memcmp(i8* %x, i8* %y, i64 64) nounwind
  %cmp = icmp ne i32 %call, 0
  ret i1 %cmp
}

define i1 @length64_eq_const(i8* %X) nounwind minsize {
; X86-LABEL: length64_eq_const:
; X86:       # %bb.0:
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $64
; X86-NEXT:    pushl $.L.str
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll memcmp
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    testl %eax, %eax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: length64_eq_const:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    pushq $64
; X64-NEXT:    popq %rdx
; X64-NEXT:    movl $.L.str, %esi
; X64-NEXT:    callq memcmp
; X64-NEXT:    testl %eax, %eax
; X64-NEXT:    sete %al
; X64-NEXT:    popq %rcx
; X64-NEXT:    retq
  %m = tail call i32 @memcmp(i8* %X, i8* getelementptr inbounds ([65 x i8], [65 x i8]* @.str, i32 0, i32 0), i64 64) nounwind
  %c = icmp eq i32 %m, 0
  ret i1 %c
}

