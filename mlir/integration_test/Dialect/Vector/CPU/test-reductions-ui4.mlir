// RUN: mlir-opt %s -convert-scf-to-std -convert-vector-to-llvm -convert-std-to-llvm | \
// RUN: mlir-cpu-runner -e entry -entry-point-result=void  \
// RUN:   -shared-libs=%mlir_integration_test_dir/libmlir_c_runner_utils%shlibext | \
// RUN: FileCheck %s

func @entry() {
  %v = std.constant dense<[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]> : vector<16xui4>
  vector.print %v : vector<16xui4>
  //
  // Test vector:
  //
  // CHECK: ( 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 )

  %0 = vector.reduction "add", %v : vector<16xui4> into ui4
  vector.print %0 : ui4
  // CHECK: 8

  %1 = vector.reduction "mul", %v : vector<16xui4> into ui4
  vector.print %1 : ui4
  // CHECK: 0

  %2 = vector.reduction "min", %v : vector<16xui4> into ui4
  vector.print %2 : ui4
  // CHECK: 0

  %3 = vector.reduction "max", %v : vector<16xui4> into ui4
  vector.print %3 : ui4
  // CHECK: 15

  %4 = vector.reduction "and", %v : vector<16xui4> into ui4
  vector.print %4 : ui4
  // CHECK: 0

  %5 = vector.reduction "or", %v : vector<16xui4> into ui4
  vector.print %5 : ui4
  // CHECK: 15

  %6 = vector.reduction "xor", %v : vector<16xui4> into ui4
  vector.print %6 : ui4
  // CHECK: 0

  return
}
