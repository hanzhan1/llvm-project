// RUN: mlir-opt %s -test-vector-transfer-unrolling-patterns --split-input-file | FileCheck %s

// CHECK-LABEL: func @transfer_read_unroll
//       CHECK-DAG:   %[[C2:.*]] = constant 2 : index
//       CHECK-DAG:   %[[C0:.*]] = constant 0 : index
//       CHECK:   %[[VTR0:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]]], %{{.*}} : memref<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR1:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C2]]], %{{.*}} : memref<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR2:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C0]]], %{{.*}} : memref<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR3:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C2]]], %{{.*}} : memref<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[TUPL:.*]] = vector.tuple %[[VTR0]], %[[VTR1]], %[[VTR2]], %[[VTR3]] : vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VEC:.*]] = vector.insert_slices %[[TUPL]], [2, 2], [1, 1] : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>> into vector<4x4xf32>
//  CHECK-NEXT:   return %[[VEC]] : vector<4x4xf32>

func @transfer_read_unroll(%arg0 : memref<4x4xf32>) -> vector<4x4xf32> {
  %c0 = constant 0 : index
  %cf0 = constant 0.0 : f32
  %0 = vector.transfer_read %arg0[%c0, %c0], %cf0 : memref<4x4xf32>, vector<4x4xf32>
  return %0 : vector<4x4xf32>
}

// CHECK-LABEL: func @transfer_write_unroll
//       CHECK-DAG:   %[[C2:.*]] = constant 2 : index
//       CHECK-DAG:   %[[C0:.*]] = constant 0 : index
//       CHECK:   %[[TUPL:.*]] = vector.extract_slices {{.*}}, [2, 2], [1, 1] : vector<4x4xf32> into tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>>
//  CHECK-NEXT:   %[[T0:.*]] = vector.tuple_get %[[TUPL]], 0 : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>>
//  CHECK-NEXT:   vector.transfer_write %[[T0]], {{.*}}[%[[C0]], %[[C0]]] {{.*}} : vector<2x2xf32>, memref<4x4xf32>
//  CHECK-NEXT:   %[[T1:.*]] = vector.tuple_get %[[TUPL]], 1 : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>>
//  CHECK-NEXT:   vector.transfer_write %[[T1]], {{.*}}[%[[C0]], %[[C2]]] {{.*}} : vector<2x2xf32>, memref<4x4xf32>
//  CHECK-NEXT:   %[[T2:.*]] = vector.tuple_get %[[TUPL]], 2 : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>>
//  CHECK-NEXT:   vector.transfer_write %[[T2]], {{.*}}[%[[C2]], %[[C0]]] {{.*}} : vector<2x2xf32>, memref<4x4xf32>
//  CHECK-NEXT:   %[[T3:.*]] = vector.tuple_get %[[TUPL]], 3 : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>>
//  CHECK-NEXT:   vector.transfer_write %[[T3]], {{.*}}[%[[C2]], %[[C2]]] {{.*}} : vector<2x2xf32>, memref<4x4xf32>
//  CHECK-NEXT:   return

func @transfer_write_unroll(%arg0 : memref<4x4xf32>, %arg1 : vector<4x4xf32>) {
  %c0 = constant 0 : index
  vector.transfer_write %arg1, %arg0[%c0, %c0] : vector<4x4xf32>, memref<4x4xf32>
  return
}

// CHECK-LABEL: func @transfer_readwrite_unroll
//       CHECK-DAG:   %[[C2:.*]] = constant 2 : index
//       CHECK-DAG:   %[[C0:.*]] = constant 0 : index
//       CHECK:   %[[VTR0:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]]], %{{.*}} : memref<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR1:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C2]]], %{{.*}} : memref<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR2:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C0]]], %{{.*}} : memref<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR3:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C2]]], %{{.*}} : memref<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   vector.transfer_write %[[VTR0]], {{.*}}[%[[C0]], %[[C0]]] {{.*}} : vector<2x2xf32>, memref<4x4xf32>
//  CHECK-NEXT:   vector.transfer_write %[[VTR1]], {{.*}}[%[[C0]], %[[C2]]] {{.*}} : vector<2x2xf32>, memref<4x4xf32>
//  CHECK-NEXT:   vector.transfer_write %[[VTR2]], {{.*}}[%[[C2]], %[[C0]]] {{.*}} : vector<2x2xf32>, memref<4x4xf32>
//  CHECK-NEXT:   vector.transfer_write %[[VTR3]], {{.*}}[%[[C2]], %[[C2]]] {{.*}} : vector<2x2xf32>, memref<4x4xf32>
//  CHECK-NEXT:   return

func @transfer_readwrite_unroll(%arg0 : memref<4x4xf32>) {
  %c0 = constant 0 : index
  %cf0 = constant 0.0 : f32
  %0 = vector.transfer_read %arg0[%c0, %c0], %cf0 : memref<4x4xf32>, vector<4x4xf32>
  vector.transfer_write %0, %arg0[%c0, %c0] : vector<4x4xf32>, memref<4x4xf32>
  return
}

// CHECK-LABEL: func @transfer_read_unroll_tensor
//       CHECK-DAG:   %[[C2:.*]] = constant 2 : index
//       CHECK-DAG:   %[[C0:.*]] = constant 0 : index
//       CHECK:   %[[VTR0:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]]], %{{.*}} : tensor<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR1:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C2]]], %{{.*}} : tensor<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR2:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C0]]], %{{.*}} : tensor<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR3:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C2]]], %{{.*}} : tensor<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[TUPL:.*]] = vector.tuple %[[VTR0]], %[[VTR1]], %[[VTR2]], %[[VTR3]] : vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VEC:.*]] = vector.insert_slices %[[TUPL]], [2, 2], [1, 1] : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>> into vector<4x4xf32>
//  CHECK-NEXT:   return %[[VEC]] : vector<4x4xf32>

func @transfer_read_unroll_tensor(%arg0 : tensor<4x4xf32>) -> vector<4x4xf32> {
  %c0 = constant 0 : index
  %cf0 = constant 0.0 : f32
  %0 = vector.transfer_read %arg0[%c0, %c0], %cf0 : tensor<4x4xf32>, vector<4x4xf32>
  return %0 : vector<4x4xf32>
}

// CHECK-LABEL: func @transfer_write_unroll_tensor
//       CHECK-DAG:   %[[C2:.*]] = constant 2 : index
//       CHECK-DAG:   %[[C0:.*]] = constant 0 : index
//       CHECK:   %[[TUPL:.*]] = vector.extract_slices {{.*}}, [2, 2], [1, 1] : vector<4x4xf32> into tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>>
//  CHECK-NEXT:   %[[T0:.*]] = vector.tuple_get %[[TUPL]], 0 : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>>
//  CHECK-NEXT:   %[[VTW0:.*]] = vector.transfer_write %[[T0]], {{.*}}[%[[C0]], %[[C0]]] {{.*}} : vector<2x2xf32>, tensor<4x4xf32>
//  CHECK-NEXT:   %[[T1:.*]] = vector.tuple_get %[[TUPL]], 1 : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>>
//  CHECK-NEXT:   %[[VTW1:.*]] = vector.transfer_write %[[T1]], %[[VTW0]][%[[C0]], %[[C2]]] {{.*}} : vector<2x2xf32>, tensor<4x4xf32>
//  CHECK-NEXT:   %[[T2:.*]] = vector.tuple_get %[[TUPL]], 2 : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>>
//  CHECK-NEXT:   %[[VTW2:.*]] = vector.transfer_write %[[T2]], %[[VTW1]][%[[C2]], %[[C0]]] {{.*}} : vector<2x2xf32>, tensor<4x4xf32>
//  CHECK-NEXT:   %[[T3:.*]] = vector.tuple_get %[[TUPL]], 3 : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>>
//  CHECK-NEXT:   %[[VTW3:.*]] = vector.transfer_write %[[T3]], %[[VTW2]][%[[C2]], %[[C2]]] {{.*}} : vector<2x2xf32>, tensor<4x4xf32>
//  CHECK-NEXT:   return %[[VTW3]] : tensor<4x4xf32>

func @transfer_write_unroll_tensor(%arg0 : tensor<4x4xf32>,
  %arg1 : vector<4x4xf32>) -> tensor<4x4xf32> {
  %c0 = constant 0 : index
  %r = vector.transfer_write %arg1, %arg0[%c0, %c0] :
    vector<4x4xf32>, tensor<4x4xf32>
  return %r: tensor<4x4xf32>
}

// CHECK-LABEL: func @transfer_readwrite_unroll_tensor
//       CHECK-DAG:   %[[C2:.*]] = constant 2 : index
//       CHECK-DAG:   %[[C0:.*]] = constant 0 : index
//       CHECK:   %[[VTR0:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]]], %{{.*}} : tensor<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR1:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C2]]], %{{.*}} : tensor<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR2:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C0]]], %{{.*}} : tensor<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR3:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C2]]], %{{.*}} : tensor<4x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTW0:.*]] = vector.transfer_write %[[VTR0]], {{.*}}[%[[C0]], %[[C0]]] {{.*}} : vector<2x2xf32>, tensor<4x4xf32>
//  CHECK-NEXT:   %[[VTW1:.*]] = vector.transfer_write %[[VTR1]], %[[VTW0]][%[[C0]], %[[C2]]] {{.*}} : vector<2x2xf32>, tensor<4x4xf32>
//  CHECK-NEXT:   %[[VTW2:.*]] = vector.transfer_write %[[VTR2]], %[[VTW1]][%[[C2]], %[[C0]]] {{.*}} : vector<2x2xf32>, tensor<4x4xf32>
//  CHECK-NEXT:   %[[VTW3:.*]] = vector.transfer_write %[[VTR3]], %[[VTW2]][%[[C2]], %[[C2]]] {{.*}} : vector<2x2xf32>, tensor<4x4xf32>
//  CHECK-NEXT:   return %[[VTW3]] : tensor<4x4xf32>

func @transfer_readwrite_unroll_tensor(%arg0 : tensor<4x4xf32>, %arg1 : tensor<4x4xf32>) ->
  tensor<4x4xf32> {
  %c0 = constant 0 : index
  %cf0 = constant 0.0 : f32
  %0 = vector.transfer_read %arg0[%c0, %c0], %cf0 : tensor<4x4xf32>, vector<4x4xf32>
  %r = vector.transfer_write %0, %arg1[%c0, %c0] : vector<4x4xf32>, tensor<4x4xf32>
  return %r: tensor<4x4xf32>
}

// -----

// CHECK-LABEL: func @transfer_read_unroll_permutation
//       CHECK-DAG:   %[[C4:.*]] = constant 4 : index
//       CHECK-DAG:   %[[C2:.*]] = constant 2 : index
//       CHECK-DAG:   %[[C0:.*]] = constant 0 : index
//       CHECK:   %[[VTR0:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR1:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR2:.*]] = vector.transfer_read {{.*}}[%[[C4]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR3:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C2]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR4:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C2]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR5:.*]] = vector.transfer_read {{.*}}[%[[C4]], %[[C2]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[TUPL:.*]] = vector.tuple %[[VTR0]], %[[VTR1]], %[[VTR2]], %[[VTR3]], %[[VTR4]], %[[VTR5]] : vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VEC:.*]] = vector.insert_slices %[[TUPL]], [2, 2], [1, 1] : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>> into vector<4x6xf32>
//  CHECK-NEXT:   return %[[VEC]] : vector<4x6xf32>
#map0 = affine_map<(d0, d1) -> (d1, d0)>
func @transfer_read_unroll_permutation(%arg0 : memref<6x4xf32>) -> vector<4x6xf32> {
  %c0 = constant 0 : index
  %cf0 = constant 0.0 : f32
  %0 = vector.transfer_read %arg0[%c0, %c0], %cf0 {permutation_map = #map0} : memref<6x4xf32>, vector<4x6xf32>
  return %0 : vector<4x6xf32>
}

// -----

// CHECK-LABEL: func @transfer_read_unroll_broadcast
//       CHECK-DAG:   %[[C2:.*]] = constant 2 : index
//       CHECK-DAG:   %[[C0:.*]] = constant 0 : index
//       CHECK:   %[[VTR0:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR1:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C2]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR2:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR3:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C2]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR4:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR5:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C2]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[TUPL:.*]] = vector.tuple %[[VTR0]], %[[VTR1]], %[[VTR2]], %[[VTR3]], %[[VTR4]], %[[VTR5]] : vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VEC:.*]] = vector.insert_slices %[[TUPL]], [2, 2], [1, 1] : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>> into vector<6x4xf32>
//  CHECK-NEXT:   return %[[VEC]] : vector<6x4xf32>
#map0 = affine_map<(d0, d1) -> (0, d1)>
func @transfer_read_unroll_broadcast(%arg0 : memref<6x4xf32>) -> vector<6x4xf32> {
  %c0 = constant 0 : index
  %cf0 = constant 0.0 : f32
  %0 = vector.transfer_read %arg0[%c0, %c0], %cf0 {permutation_map = #map0} : memref<6x4xf32>, vector<6x4xf32>
  return %0 : vector<6x4xf32>
}

// -----

// CHECK-LABEL: func @transfer_read_unroll_broadcast_permuation
//       CHECK-DAG:   %[[C4:.*]] = constant 4 : index
//       CHECK-DAG:   %[[C2:.*]] = constant 2 : index
//       CHECK-DAG:   %[[C0:.*]] = constant 0 : index
//       CHECK:   %[[VTR0:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR1:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR2:.*]] = vector.transfer_read {{.*}}[%[[C4]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR3:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR4:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR5:.*]] = vector.transfer_read {{.*}}[%[[C4]], %[[C0]]], %{{.*}} : memref<6x4xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[TUPL:.*]] = vector.tuple %[[VTR0]], %[[VTR1]], %[[VTR2]], %[[VTR3]], %[[VTR4]], %[[VTR5]] : vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VEC:.*]] = vector.insert_slices %[[TUPL]], [2, 2], [1, 1] : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>> into vector<4x6xf32>
//  CHECK-NEXT:   return %[[VEC]] : vector<4x6xf32>
#map0 = affine_map<(d0, d1) -> (0, d0)>
func @transfer_read_unroll_broadcast_permuation(%arg0 : memref<6x4xf32>) -> vector<4x6xf32> {
  %c0 = constant 0 : index
  %cf0 = constant 0.0 : f32
  %0 = vector.transfer_read %arg0[%c0, %c0], %cf0 {permutation_map = #map0} : memref<6x4xf32>, vector<4x6xf32>
  return %0 : vector<4x6xf32>
}

// -----

// CHECK-LABEL: func @transfer_read_unroll_different_rank
//       CHECK-DAG:   %[[C4:.*]] = constant 4 : index
//       CHECK-DAG:   %[[C2:.*]] = constant 2 : index
//       CHECK-DAG:   %[[C0:.*]] = constant 0 : index
//       CHECK:   %[[VTR0:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]], %[[C0]]], %{{.*}} : memref<?x?x?xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR1:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C0]], %[[C0]]], %{{.*}} : memref<?x?x?xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR2:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]], %[[C2]]], %{{.*}} : memref<?x?x?xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR3:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C0]], %[[C2]]], %{{.*}} : memref<?x?x?xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR4:.*]] = vector.transfer_read {{.*}}[%[[C0]], %[[C0]], %[[C4]]], %{{.*}} : memref<?x?x?xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VTR5:.*]] = vector.transfer_read {{.*}}[%[[C2]], %[[C0]], %[[C4]]], %{{.*}} : memref<?x?x?xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[TUPL:.*]] = vector.tuple %[[VTR0]], %[[VTR1]], %[[VTR2]], %[[VTR3]], %[[VTR4]], %[[VTR5]] : vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>
//  CHECK-NEXT:   %[[VEC:.*]] = vector.insert_slices %[[TUPL]], [2, 2], [1, 1] : tuple<vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>, vector<2x2xf32>> into vector<6x4xf32>
//  CHECK-NEXT:   return %[[VEC]] : vector<6x4xf32>
#map0 = affine_map<(d0, d1, d2) -> (d2, d0)>
func @transfer_read_unroll_different_rank(%arg0 : memref<?x?x?xf32>) -> vector<6x4xf32> {
  %c0 = constant 0 : index
  %cf0 = constant 0.0 : f32
  %0 = vector.transfer_read %arg0[%c0, %c0, %c0], %cf0 {permutation_map = #map0} : memref<?x?x?xf32>, vector<6x4xf32>
  return %0 : vector<6x4xf32>
}
