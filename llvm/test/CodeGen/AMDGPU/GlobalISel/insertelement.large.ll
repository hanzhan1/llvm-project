; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

define amdgpu_kernel void @v_insert_v64i32_37(<64 x i32> addrspace(1)* %ptr.in, <64 x i32> addrspace(1)* %ptr.out) #0 {
; GCN-LABEL: v_insert_v64i32_37:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[4:5], 0x0
; GCN-NEXT:    v_lshlrev_b32_e32 v64, 8, v0
; GCN-NEXT:    s_movk_i32 s4, 0x80
; GCN-NEXT:    s_mov_b32 s5, 0
; GCN-NEXT:    v_mov_b32_e32 v2, s4
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    v_mov_b32_e32 v1, s1
; GCN-NEXT:    v_add_co_u32_e32 v6, vcc, v0, v64
; GCN-NEXT:    v_addc_co_u32_e32 v7, vcc, 0, v1, vcc
; GCN-NEXT:    v_add_co_u32_e32 v0, vcc, 64, v6
; GCN-NEXT:    v_addc_co_u32_e32 v1, vcc, 0, v7, vcc
; GCN-NEXT:    v_mov_b32_e32 v3, s5
; GCN-NEXT:    v_add_co_u32_e32 v2, vcc, v6, v2
; GCN-NEXT:    s_movk_i32 s4, 0xc0
; GCN-NEXT:    v_mov_b32_e32 v4, s4
; GCN-NEXT:    v_addc_co_u32_e32 v3, vcc, v7, v3, vcc
; GCN-NEXT:    v_mov_b32_e32 v5, s5
; GCN-NEXT:    v_add_co_u32_e32 v16, vcc, v6, v4
; GCN-NEXT:    v_addc_co_u32_e32 v17, vcc, v7, v5, vcc
; GCN-NEXT:    global_load_dwordx4 v[4:7], v[2:3], off offset:16
; GCN-NEXT:    global_load_dwordx4 v[8:11], v[2:3], off offset:32
; GCN-NEXT:    global_load_dwordx4 v[32:35], v[0:1], off offset:16
; GCN-NEXT:    global_load_dwordx4 v[36:39], v[0:1], off offset:32
; GCN-NEXT:    global_load_dwordx4 v[40:43], v[0:1], off offset:48
; GCN-NEXT:    global_load_dwordx4 v[44:47], v64, s[0:1]
; GCN-NEXT:    global_load_dwordx4 v[48:51], v64, s[0:1] offset:16
; GCN-NEXT:    global_load_dwordx4 v[52:55], v64, s[0:1] offset:32
; GCN-NEXT:    global_load_dwordx4 v[56:59], v64, s[0:1] offset:48
; GCN-NEXT:    global_load_dwordx4 v[60:63], v64, s[0:1] offset:64
; GCN-NEXT:    global_load_dwordx4 v[12:15], v[2:3], off offset:48
; GCN-NEXT:    global_load_dwordx4 v[20:23], v[16:17], off offset:16
; GCN-NEXT:    global_load_dwordx4 v[24:27], v[16:17], off offset:32
; GCN-NEXT:    global_load_dwordx4 v[28:31], v[16:17], off offset:48
; GCN-NEXT:    global_load_dwordx4 v[0:3], v64, s[0:1] offset:128
; GCN-NEXT:    global_load_dwordx4 v[16:19], v64, s[0:1] offset:192
; GCN-NEXT:    s_waitcnt vmcnt(15)
; GCN-NEXT:    v_mov_b32_e32 v5, 0x3e7
; GCN-NEXT:    s_waitcnt vmcnt(1)
; GCN-NEXT:    global_store_dwordx4 v64, v[0:3], s[2:3] offset:128
; GCN-NEXT:    global_store_dwordx4 v64, v[4:7], s[2:3] offset:144
; GCN-NEXT:    global_store_dwordx4 v64, v[8:11], s[2:3] offset:160
; GCN-NEXT:    global_store_dwordx4 v64, v[12:15], s[2:3] offset:176
; GCN-NEXT:    s_waitcnt vmcnt(4)
; GCN-NEXT:    global_store_dwordx4 v64, v[16:19], s[2:3] offset:192
; GCN-NEXT:    global_store_dwordx4 v64, v[20:23], s[2:3] offset:208
; GCN-NEXT:    global_store_dwordx4 v64, v[24:27], s[2:3] offset:224
; GCN-NEXT:    global_store_dwordx4 v64, v[44:47], s[2:3]
; GCN-NEXT:    global_store_dwordx4 v64, v[48:51], s[2:3] offset:16
; GCN-NEXT:    global_store_dwordx4 v64, v[52:55], s[2:3] offset:32
; GCN-NEXT:    global_store_dwordx4 v64, v[56:59], s[2:3] offset:48
; GCN-NEXT:    global_store_dwordx4 v64, v[28:31], s[2:3] offset:240
; GCN-NEXT:    global_store_dwordx4 v64, v[60:63], s[2:3] offset:64
; GCN-NEXT:    global_store_dwordx4 v64, v[32:35], s[2:3] offset:80
; GCN-NEXT:    global_store_dwordx4 v64, v[36:39], s[2:3] offset:96
; GCN-NEXT:    global_store_dwordx4 v64, v[40:43], s[2:3] offset:112
; GCN-NEXT:    s_endpgm
  %id = call i32 @llvm.amdgcn.workitem.id.x()
  %gep.in = getelementptr <64 x i32>, <64 x i32> addrspace(1)* %ptr.in, i32 %id
  %vec = load <64 x i32>, <64 x i32> addrspace(1)* %gep.in
  %insert = insertelement <64 x i32> %vec, i32 999, i32 37
  %gep.out = getelementptr <64 x i32>, <64 x i32> addrspace(1)* %ptr.out, i32 %id
  store <64 x i32> %insert, <64 x i32> addrspace(1)* %gep.out
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() #1

attributes #0 = { "amdgpu-waves-per-eu"="1,10" }
attributes #1 = { nounwind readnone speculatable willreturn }
