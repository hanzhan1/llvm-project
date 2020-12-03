// RUN: mlir-opt %s -affine-super-vectorizer-test -vector-shape-ratio 4 -vector-shape-ratio 8 2>&1 | FileCheck %s
// RUN: mlir-opt %s -affine-super-vectorizer-test -vector-shape-ratio 2 -vector-shape-ratio 5 -vector-shape-ratio 2 2>&1 | FileCheck %s -check-prefix=TEST-3x4x5x8
// RUN: mlir-opt %s -affine-super-vectorizer-test -vectorize-affine-loop-nest 2>&1 | FileCheck %s -check-prefix=VECNEST

func @vector_add_2d(%arg0: index, %arg1: index) -> f32 {
  // Nothing should be matched in this first block.
  // CHECK-NOT:matched: {{.*}} = alloc{{.*}}
  // CHECK-NOT:matched: {{.*}} = constant 0{{.*}}
  // CHECK-NOT:matched: {{.*}} = constant 1{{.*}}
  %0 = alloc(%arg0, %arg1) : memref<?x?xf32>
  %1 = alloc(%arg0, %arg1) : memref<?x?xf32>
  %2 = alloc(%arg0, %arg1) : memref<?x?xf32>
  %c0 = constant 0 : index
  %cst = constant 1.000000e+00 : f32

  // CHECK:matched: {{.*}} constant dense{{.*}} with shape ratio: 2, 32
  %cst_1 = constant dense<1.000000e+00> : vector<8x256xf32>
  // CHECK:matched: {{.*}} constant dense{{.*}} with shape ratio: 1, 3, 7, 2, 1
  %cst_a = constant dense<1.000000e+00> : vector<1x3x7x8x8xf32>
  // CHECK-NOT:matched: {{.*}} constant dense{{.*}} with shape ratio: 1, 3, 7, 1{{.*}}
  %cst_b = constant dense<1.000000e+00> : vector<1x3x7x4x4xf32>
  // TEST-3x4x5x8:matched: {{.*}} constant dense{{.*}} with shape ratio: 3, 2, 1, 4
  %cst_c = constant dense<1.000000e+00> : vector<3x4x5x8xf32>
  // TEST-3x4x4x8-NOT:matched: {{.*}} constant dense{{.*}} with shape ratio{{.*}}
  %cst_d = constant dense<1.000000e+00> : vector<3x4x4x8xf32>
  // TEST-3x4x4x8:matched: {{.*}} constant dense{{.*}} with shape ratio: 1, 1, 2, 16
  %cst_e = constant dense<1.000000e+00> : vector<1x2x10x32xf32>

  // Nothing should be matched in this last block.
  // CHECK-NOT:matched: {{.*}} = constant 7{{.*}}
  // CHECK-NOT:matched: {{.*}} = constant 42{{.*}}
  // CHECK-NOT:matched: {{.*}} = load{{.*}}
  // CHECK-NOT:matched: return {{.*}}
  %c7 = constant 7 : index
  %c42 = constant 42 : index
  %9 = load %2[%c7, %c42] : memref<?x?xf32>
  return %9 : f32
}

// VECNEST-LABEL: func @double_loop_nest
func @double_loop_nest(%a: memref<20x30xf32>, %b: memref<20xf32>) {

  affine.for %i = 0 to 20 {
    %b_ld = affine.load %b[%i] : memref<20xf32>
    affine.for %j = 0 to 30 {
      %a_ld = affine.load %a[%i, %j] : memref<20x30xf32>
      affine.store %a_ld, %a[%i, %j] : memref<20x30xf32>
    }
    affine.store %b_ld, %b[%i] : memref<20xf32>
  }

  return
}

// VECNEST:       affine.for %{{.*}} = 0 to 20 step 4 {
// VECNEST:         vector.transfer_read
// VECNEST-NEXT:    affine.for %{{.*}} = 0 to 30 {
// VECNEST:           vector.transfer_read
// VECNEST-NEXT:      vector.transfer_write %{{.*}}, %{{.*}}[%{{.*}}, %{{.*}}] {permutation_map = #{{.*}}}
// VECNEST-NEXT:    }
// VECNEST-NEXT:    vector.transfer_write
// VECNEST:       }
