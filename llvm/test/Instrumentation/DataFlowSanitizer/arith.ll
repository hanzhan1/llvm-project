; RUN: opt < %s -dfsan -S | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; CHECK: @__dfsan_shadow_width_bits = weak_odr constant i32 [[#SBITS:]]
; CHECK: @__dfsan_shadow_width_bytes = weak_odr constant i32 [[#SBYTES:]]

define i8 @add(i8 %a, i8 %b) {
  ; CHECK: @"dfs$add"
  ; CHECK-DAG: %[[#ALABEL:]] = load i[[#SBITS]], i[[#SBITS]]* bitcast ([[ARGTLSTYPE:\[100 x i64\]]]* @__dfsan_arg_tls to i[[#SBITS]]*), align [[ALIGN:2]]
  ; CHECK-DAG: %[[#BLABEL:]] = load i[[#SBITS]], i[[#SBITS]]* inttoptr (i64 add (i64 ptrtoint ([[ARGTLSTYPE]]* @__dfsan_arg_tls to i64), i64 2) to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK: %[[#UNION:]] = or i[[#SBITS]] %[[#ALABEL]], %[[#BLABEL]]
  ; CHECK: %c = add i8 %a, %b
  ; CHECK: store i[[#SBITS]] %[[#UNION]], i[[#SBITS]]* bitcast ([100 x i64]* @__dfsan_retval_tls to i[[#SBITS]]*), align [[ALIGN]]
  ; CHECK: ret i8 %c
  %c = add i8 %a, %b
  ret i8 %c
}

define i8 @sub(i8 %a, i8 %b) {
  ; CHECK: @"dfs$sub"
  ; CHECK: load{{.*}}__dfsan_arg_tls
  ; CHECK: load{{.*}}__dfsan_arg_tls
  ; CHECK: or i[[#SBITS]]
  ; CHECK: %c = sub i8 %a, %b
  ; CHECK: store{{.*}}__dfsan_retval_tls
  ; CHECK: ret i8 %c
  %c = sub i8 %a, %b
  ret i8 %c
}

define i8 @mul(i8 %a, i8 %b) {
  ; CHECK: @"dfs$mul"
  ; CHECK: load{{.*}}__dfsan_arg_tls
  ; CHECK: load{{.*}}__dfsan_arg_tls
  ; CHECK: or i[[#SBITS]]
  ; CHECK: %c = mul i8 %a, %b
  ; CHECK: store{{.*}}__dfsan_retval_tls
  ; CHECK: ret i8 %c
  %c = mul i8 %a, %b
  ret i8 %c
}

define i8 @sdiv(i8 %a, i8 %b) {
  ; CHECK: @"dfs$sdiv"
  ; CHECK: load{{.*}}__dfsan_arg_tls
  ; CHECK: load{{.*}}__dfsan_arg_tls
  ; CHECK: or i[[#SBITS]]
  ; CHECK: %c = sdiv i8 %a, %b
  ; CHECK: store{{.*}}__dfsan_retval_tls
  ; CHECK: ret i8 %c
  %c = sdiv i8 %a, %b
  ret i8 %c
}

define i8 @udiv(i8 %a, i8 %b) {
  ; CHECK: @"dfs$udiv"
  ; CHECK: load{{.*}}__dfsan_arg_tls
  ; CHECK: load{{.*}}__dfsan_arg_tls
  ; CHECK: or i[[#SBITS]]
  ; CHECK: %c = udiv i8 %a, %b
  ; CHECK: store{{.*}}__dfsan_retval_tls
  ; CHECK: ret i8 %c
  %c = udiv i8 %a, %b
  ret i8 %c
}

define double @fneg(double %a) {
  ; CHECK: @"dfs$fneg"
  ; CHECK: load{{.*}}__dfsan_arg_tls
  ; CHECK: %c = fneg double %a
  ; CHECK: store{{.*}}__dfsan_retval_tls
  ; CHECK: ret double %c
  %c = fneg double %a
  ret double %c
}
