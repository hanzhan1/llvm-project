; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 -o - %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -o - %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_ps <4 x float> @load_mip_1d(<8 x i32> inreg %rsrc, i32 %s) {
; GFX9-LABEL: load_mip_1d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_load v[0:3], v0, s[0:7] dmask:0xf unorm
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: load_mip_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_load v[0:3], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_1D unorm
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.load.mip.1d.v4f32.i32(i32 15, i32 %s, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @load_mip_2d(<8 x i32> inreg %rsrc, i32 %s, i32 %t) {
; GFX9-LABEL: load_mip_2d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_load v[0:3], v[0:1], s[0:7] dmask:0xf unorm
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: load_mip_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_load v[0:3], v[0:1], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.load.mip.2d.v4f32.i32(i32 15, i32 %s, i32 %t, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @load_mip_3d(<8 x i32> inreg %rsrc, i32 %s, i32 %t, i32 %u) {
; GFX9-LABEL: load_mip_3d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_load v[0:3], v[0:2], s[0:7] dmask:0xf unorm
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: load_mip_3d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_load v[0:3], v[0:2], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_3D unorm
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.load.mip.3d.v4f32.i32(i32 15, i32 %s, i32 %t, i32 %u, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @load_mip_1darray(<8 x i32> inreg %rsrc, i32 %s, i32 %t) {
; GFX9-LABEL: load_mip_1darray:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_load v[0:3], v[0:1], s[0:7] dmask:0xf unorm da
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: load_mip_1darray:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_load v[0:3], v[0:1], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_1D_ARRAY unorm
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.load.mip.1darray.v4f32.i32(i32 15, i32 %s, i32 %t, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @load_mip_2darray(<8 x i32> inreg %rsrc, i32 %s, i32 %t, i32 %u) {
; GFX9-LABEL: load_mip_2darray:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_load v[0:3], v[0:2], s[0:7] dmask:0xf unorm da
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: load_mip_2darray:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_load v[0:3], v[0:2], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D_ARRAY unorm
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.load.mip.2darray.v4f32.i32(i32 15, i32 %s, i32 %t, i32 %u, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @load_mip_cube(<8 x i32> inreg %rsrc, i32 %s, i32 %t, i32 %u) {
; GFX9-LABEL: load_mip_cube:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_load v[0:3], v[0:2], s[0:7] dmask:0xf unorm da
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: load_mip_cube:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_load v[0:3], v[0:2], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_CUBE unorm
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.load.mip.cube.v4f32.i32(i32 15, i32 %s, i32 %t, i32 %u, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps void @store_mip_1d(<8 x i32> inreg %rsrc, <4 x float> %vdata, i32 %s) {
; GFX9-LABEL: store_mip_1d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_store v[0:3], v4, s[0:7] dmask:0xf unorm
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_mip_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[0:3], v4, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_1D unorm
; GFX10-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.image.store.mip.1d.v4f32.i32(<4 x float> %vdata, i32 15, i32 %s, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_mip_2d(<8 x i32> inreg %rsrc, <4 x float> %vdata, i32 %s, i32 %t) {
; GFX9-LABEL: store_mip_2d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_store v[0:3], v[4:5], s[0:7] dmask:0xf unorm
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_mip_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[0:3], v[4:5], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.image.store.mip.2d.v4f32.i32(<4 x float> %vdata, i32 15, i32 %s, i32 %t, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_mip_3d(<8 x i32> inreg %rsrc, <4 x float> %vdata, i32 %s, i32 %t, i32 %u) {
; GFX9-LABEL: store_mip_3d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_store v[0:3], v[4:6], s[0:7] dmask:0xf unorm
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_mip_3d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[0:3], v[4:6], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_3D unorm
; GFX10-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.image.store.mip.3d.v4f32.i32(<4 x float> %vdata, i32 15, i32 %s, i32 %t, i32 %u, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_mip_1darray(<8 x i32> inreg %rsrc, <4 x float> %vdata, i32 %s, i32 %t) {
; GFX9-LABEL: store_mip_1darray:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_store v[0:3], v[4:5], s[0:7] dmask:0xf unorm da
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_mip_1darray:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[0:3], v[4:5], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_1D_ARRAY unorm
; GFX10-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.image.store.mip.1darray.v4f32.i32(<4 x float> %vdata, i32 15, i32 %s, i32 %t, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_mip_2darray(<8 x i32> inreg %rsrc, <4 x float> %vdata, i32 %s, i32 %t, i32 %u) {
; GFX9-LABEL: store_mip_2darray:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_store v[0:3], v[4:6], s[0:7] dmask:0xf unorm da
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_mip_2darray:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[0:3], v[4:6], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D_ARRAY unorm
; GFX10-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.image.store.mip.2darray.v4f32.i32(<4 x float> %vdata, i32 15, i32 %s, i32 %t, i32 %u, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_mip_cube(<8 x i32> inreg %rsrc, <4 x float> %vdata, i32 %s, i32 %t, i32 %u) {
; GFX9-LABEL: store_mip_cube:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    image_store v[0:3], v[4:6], s[0:7] dmask:0xf unorm da
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_mip_cube:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[0:3], v[4:6], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_CUBE unorm
; GFX10-NEXT:    s_endpgm
main_body:
  call void @llvm.amdgcn.image.store.mip.cube.v4f32.i32(<4 x float> %vdata, i32 15, i32 %s, i32 %t, i32 %u, i32 0, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

declare <4 x float> @llvm.amdgcn.image.load.mip.1d.v4f32.i32(i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.load.mip.2d.v4f32.i32(i32 immarg, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.load.mip.3d.v4f32.i32(i32 immarg, i32, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.load.mip.1darray.v4f32.i32(i32 immarg, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.load.mip.2darray.v4f32.i32(i32 immarg, i32, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.load.mip.cube.v4f32.i32(i32 immarg, i32, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare void @llvm.amdgcn.image.store.mip.1d.v4f32.i32(<4 x float>, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare void @llvm.amdgcn.image.store.mip.2d.v4f32.i32(<4 x float>, i32 immarg, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare void @llvm.amdgcn.image.store.mip.3d.v4f32.i32(<4 x float>, i32 immarg, i32, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare void @llvm.amdgcn.image.store.mip.cube.v4f32.i32(<4 x float>, i32 immarg, i32, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare void @llvm.amdgcn.image.store.mip.1darray.v4f32.i32(<4 x float>, i32 immarg, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare void @llvm.amdgcn.image.store.mip.2darray.v4f32.i32(<4 x float>, i32 immarg, i32, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #1

attributes #0 = { nounwind readonly }
attributes #1 = { nounwind writeonly }
