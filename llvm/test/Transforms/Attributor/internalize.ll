; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-attributes
; Deep Wrapper disabled

; RUN: opt -attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=5 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM,CHECK_DISABLED,NOT_CGSCC_NPM_DISABLED,NOT_CGSCC_OPM_DISABLED,NOT_TUNIT_NPM_DISABLED,IS__TUNIT_____DISABLED,IS________OPM_DISABLED,IS__TUNIT_OPM_DISABLED
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=5  -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM,CHECK_DISABLED,NOT_CGSCC_OPM_DISABLED,NOT_CGSCC_NPM_DISABLED,NOT_TUNIT_OPM_DISABLED,IS__TUNIT_____DISABLED,IS________NPM_DISABLED,IS__TUNIT_NPM_DISABLED
; RUN: opt -attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM,CHECK_DISABLED,NOT_TUNIT_NPM_DISABLED,NOT_TUNIT_OPM_DISABLED,NOT_CGSCC_NPM_DISABLED,IS__CGSCC_____DISABLED,IS________OPM_DISABLED,IS__CGSCC_OPM_DISABLED
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM,CHECK_DISABLED,NOT_TUNIT_NPM_DISABLED,NOT_TUNIT_OPM_DISABLED,NOT_CGSCC_OPM_DISABLED,IS__CGSCC_____DISABLED,IS________NPM_DISABLED,IS__CGSCC_NPM_DISABLED

; Deep Wrapper enabled

; RUN: opt -attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=8 -attributor-allow-deep-wrappers -disable-inlining -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM,CHECK_ENABLED,NOT_CGSCC_NPM_ENABLED,NOT_CGSCC_OPM_ENABLED,NOT_TUNIT_NPM_ENABLED,IS__TUNIT_____ENABLED,IS________OPM_ENABLED,IS__TUNIT_OPM_ENABLED
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=8 -attributor-allow-deep-wrappers -disable-inlining -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM,CHECK_ENABLED,NOT_CGSCC_OPM_ENABLED,NOT_CGSCC_NPM_ENABLED,NOT_TUNIT_OPM_ENABLED,IS__TUNIT_____ENABLED,IS________NPM_ENABLED,IS__TUNIT_NPM_ENABLED
; RUN: opt -attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -attributor-allow-deep-wrappers -disable-inlining -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM,CHECK_ENABLED,NOT_TUNIT_NPM_ENABLED,NOT_TUNIT_OPM_ENABLED,NOT_CGSCC_NPM_ENABLED,IS__CGSCC_____ENABLED,IS________OPM_ENABLED,IS__CGSCC_OPM_ENABLED
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -attributor-allow-deep-wrappers -disable-inlining -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM,CHECK_ENABLED,NOT_TUNIT_NPM_ENABLED,NOT_TUNIT_OPM_ENABLED,NOT_CGSCC_OPM_ENABLED,IS__CGSCC_____ENABLED,IS________NPM_ENABLED,IS__CGSCC_NPM_ENABLED

; TEST 1: This function is of linkage `linkonce`, we cannot internalize this
;         function and use information derived from it
;
; CHECK-NOT: inner1.internalized
define linkonce i32 @inner1(i32 %a, i32 %b) {
; CHECK-LABEL: define {{[^@]+}}@inner1
; CHECK-SAME: (i32 [[A:%.*]], i32 [[B:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[C]]
;
entry:
  %c = add i32 %a, %b
  ret i32 %c
}

; TEST 2: This function is of linkage `weak`, we cannot internalize this function and
;         use information derived from it
;
; CHECK-NOT: inner2.internalized
define weak i32 @inner2(i32 %a, i32 %b) {
; CHECK-LABEL: define {{[^@]+}}@inner2
; CHECK-SAME: (i32 [[A:%.*]], i32 [[B:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[C]]
;
entry:
  %c = add i32 %a, %b
  ret i32 %c
}

; TEST 3: This function is of linkage `linkonce_odr`, which can be internalized using the
;         deep wrapper, and the IP information derived from this function can be used
;
define linkonce_odr i32 @inner3(i32 %a, i32 %b) {
; CHECK_DISABLED-LABEL: define {{[^@]+}}@inner3
; CHECK_DISABLED-SAME: (i32 [[A:%.*]], i32 [[B:%.*]]) {
; CHECK_DISABLED-NEXT:  entry:
; CHECK_DISABLED-NEXT:    [[C:%.*]] = add i32 [[A]], [[B]]
; CHECK_DISABLED-NEXT:    ret i32 [[C]]
;
entry:
  %c = add i32 %a, %b
  ret i32 %c
}

; TEST 4: This function is of linkage `weak_odr`, which can be internalized using the deep
;         wrapper
;
define weak_odr i32 @inner4(i32 %a, i32 %b) {
; CHECK_DISABLED-LABEL: define {{[^@]+}}@inner4
; CHECK_DISABLED-SAME: (i32 [[A:%.*]], i32 [[B:%.*]]) {
; CHECK_DISABLED-NEXT:  entry:
; CHECK_DISABLED-NEXT:    [[C:%.*]] = add i32 [[A]], [[B]]
; CHECK_DISABLED-NEXT:    ret i32 [[C]]
;
entry:
  %c = add i32 %a, %b
  ret i32 %c
}

; TEST 5: This function has linkage `linkonce_odr` but is never called (num of use = 0), so there
;         is no need to internalize this
;
; CHECK-NOT: inner5.internalized
define linkonce_odr i32 @inner5(i32 %a, i32 %b) {
; CHECK-LABEL: define {{[^@]+}}@inner5
; CHECK-SAME: (i32 [[A:%.*]], i32 [[B:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    ret i32 [[C]]
;
entry:
  %c = add i32 %a, %b
  ret i32 %c
}

; Since the inner1 cannot be internalized, there should be no change to its callsite
; Since the inner2 cannot be internalized, there should be no change to its callsite
; Since the inner3 is internalized, the use of the original function should be replaced by the
;  copied one
;
define i32 @outer1() {
; CHECK_DISABLED-LABEL: define {{[^@]+}}@outer1() {
; CHECK_DISABLED-NEXT:  entry:
; CHECK_DISABLED-NEXT:    [[RET1:%.*]] = call i32 @inner1(i32 noundef 1, i32 noundef 2)
; CHECK_DISABLED-NEXT:    [[RET2:%.*]] = call i32 @inner2(i32 noundef 1, i32 noundef 2)
; CHECK_DISABLED-NEXT:    [[RET3:%.*]] = call i32 @inner3(i32 [[RET1]], i32 [[RET2]])
; CHECK_DISABLED-NEXT:    [[RET4:%.*]] = call i32 @inner4(i32 [[RET3]], i32 [[RET3]])
; CHECK_DISABLED-NEXT:    ret i32 [[RET4]]
;
; CHECK_ENABLED-LABEL: define {{[^@]+}}@outer1() {
; CHECK_ENABLED-NEXT:  entry:
; CHECK_ENABLED-NEXT:    [[RET1:%.*]] = call i32 @inner1(i32 noundef 1, i32 noundef 2)
; CHECK_ENABLED-NEXT:    [[RET2:%.*]] = call i32 @inner2(i32 noundef 1, i32 noundef 2)
; CHECK_ENABLED-NEXT:    [[RET3:%.*]] = call i32 @inner3.internalized(i32 [[RET1]], i32 [[RET2]])
; CHECK_ENABLED-NEXT:    [[RET4:%.*]] = call i32 @inner4.internalized(i32 [[RET3]], i32 [[RET3]])
; CHECK_ENABLED-NEXT:    ret i32 [[RET4]]
;
entry:
  %ret1 = call i32 @inner1(i32 1, i32 2)
  %ret2 = call i32 @inner2(i32 1, i32 2)
  %ret3 = call i32 @inner3(i32 %ret1, i32 %ret2)
  %ret4 = call i32 @inner4(i32 %ret3, i32 %ret3)
  ret i32 %ret4
}


define linkonce_odr void @unused_arg(i8) {
; CHECK_DISABLED-LABEL: define {{[^@]+}}@unused_arg
; CHECK_DISABLED-SAME: (i8 [[TMP0:%.*]]) {
; CHECK_DISABLED-NEXT:    unreachable
;
  unreachable
}

define void @unused_arg_caller() {
; CHECK_DISABLED-LABEL: define {{[^@]+}}@unused_arg_caller() {
; CHECK_DISABLED-NEXT:    call void @unused_arg(i8 noundef 0)
; CHECK_DISABLED-NEXT:    ret void
;
; IS__TUNIT_____ENABLED: Function Attrs: nofree noreturn nosync nounwind readnone willreturn
; IS__TUNIT_____ENABLED-LABEL: define {{[^@]+}}@unused_arg_caller
; IS__TUNIT_____ENABLED-SAME: () [[ATTR1:#.*]] {
; IS__TUNIT_____ENABLED-NEXT:    unreachable
;
; IS__CGSCC_____ENABLED: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; IS__CGSCC_____ENABLED-LABEL: define {{[^@]+}}@unused_arg_caller
; IS__CGSCC_____ENABLED-SAME: () [[ATTR2:#.*]] {
; IS__CGSCC_____ENABLED-NEXT:    unreachable
;
  call void @unused_arg(i8 0)
  ret void
}

; Don't crash on linkonce_odr hidden functions
define linkonce_odr hidden void @__clang_call_terminate() {
; CHECK_DISABLED-LABEL: define {{[^@]+}}@__clang_call_terminate() {
; CHECK_DISABLED-NEXT:    call void @__clang_call_terminate()
; CHECK_DISABLED-NEXT:    unreachable
;
  call void @__clang_call_terminate()
  unreachable
}

