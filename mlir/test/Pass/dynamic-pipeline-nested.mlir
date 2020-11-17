// RUN: mlir-opt %s -pass-pipeline='module(test-dynamic-pipeline{op-name=inner_mod1 dynamic-pipeline=cse})'  --mlir-disable-threading  -print-ir-before-all 2>&1 | FileCheck %s --check-prefix=NOTNESTED --check-prefix=CHECK
// RUN: mlir-opt %s -pass-pipeline='module(test-dynamic-pipeline{op-name=inner_mod1 run-on-nested-operations=1 dynamic-pipeline=cse})'  --mlir-disable-threading  -print-ir-before-all 2>&1 | FileCheck %s --check-prefix=NESTED --check-prefix=CHECK


// Verify that we can schedule a dynamic pipeline on a nested operation

func @f() {
  return
}

// CHECK: IR Dump Before
// CHECK-SAME: TestDynamicPipelinePass
// CHECK-NEXT: module @inner_mod1
module @inner_mod1 {
// We use the print-ir-after-all dumps to check the granularity of the
// scheduling: if we are nesting we expect to see to individual "Dump Before
// CSE" output: one for each of the function. If we don't nest, then we expect
// the CSE pass to run on the `inner_mod1` module directly.

// CHECK: Dump Before CSE
// NOTNESTED-NEXT: @inner_mod1
// NESTED-NEXT: @foo
  func private @foo()
// Only in the nested case we have a second run of the pass here.
// NESTED: Dump Before CSE
// NESTED-NEXT: @baz
  func private @baz()
}
