; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx900 -global-isel -mattr=-promote-alloca -amdgpu-enable-flat-scratch -verify-machineinstrs < %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -march=amdgcn -mcpu=gfx1030 -global-isel -mattr=-promote-alloca -amdgpu-enable-flat-scratch -verify-machineinstrs < %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_kernel void @store_load_sindex_kernel(i32 %idx) {
; GFX9-LABEL: store_load_sindex_kernel:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_load_dword s0, s[0:1], 0x24
; GFX9-NEXT:    s_add_u32 flat_scratch_lo, s2, s5
; GFX9-NEXT:    s_addc_u32 flat_scratch_hi, s3, 0
; GFX9-NEXT:    v_mov_b32_e32 v0, 15
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_lshl_b32 s1, s0, 2
; GFX9-NEXT:    s_and_b32 s0, s0, 15
; GFX9-NEXT:    s_lshl_b32 s0, s0, 2
; GFX9-NEXT:    s_add_u32 s1, 4, s1
; GFX9-NEXT:    scratch_store_dword off, v0, s1
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_add_u32 s0, 4, s0
; GFX9-NEXT:    scratch_load_dword v0, off, s0 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_load_sindex_kernel:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_add_u32 s2, s2, s5
; GFX10-NEXT:    s_addc_u32 s3, s3, 0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s2
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s3
; GFX10-NEXT:    s_load_dword s0, s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 15
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_and_b32 s1, s0, 15
; GFX10-NEXT:    s_lshl_b32 s0, s0, 2
; GFX10-NEXT:    s_lshl_b32 s1, s1, 2
; GFX10-NEXT:    s_add_u32 s0, 4, s0
; GFX10-NEXT:    s_add_u32 s1, 4, s1
; GFX10-NEXT:    scratch_store_dword off, v0, s0
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, off, s1 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_endpgm
bb:
  %i = alloca [32 x float], align 4, addrspace(5)
  %i1 = bitcast [32 x float] addrspace(5)* %i to i8 addrspace(5)*
  %i7 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %idx
  %i8 = bitcast float addrspace(5)* %i7 to i32 addrspace(5)*
  store volatile i32 15, i32 addrspace(5)* %i8, align 4
  %i9 = and i32 %idx, 15
  %i10 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i9
  %i11 = bitcast float addrspace(5)* %i10 to i32 addrspace(5)*
  %i12 = load volatile i32, i32 addrspace(5)* %i11, align 4
  ret void
}

define amdgpu_kernel void @store_load_vindex_kernel() {
; GFX9-LABEL: store_load_vindex_kernel:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_add_u32 flat_scratch_lo, s0, s3
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, 0, v0
; GFX9-NEXT:    v_mov_b32_e32 v2, 4
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    s_addc_u32 flat_scratch_hi, s1, 0
; GFX9-NEXT:    v_add_u32_e32 v1, v2, v1
; GFX9-NEXT:    v_mov_b32_e32 v3, 15
; GFX9-NEXT:    scratch_store_dword v1, v3, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_add_u32_e32 v0, v2, v0
; GFX9-NEXT:    scratch_load_dword v0, v0, off offset:124 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_load_vindex_kernel:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_add_u32 s0, s0, s3
; GFX10-NEXT:    s_addc_u32 s1, s1, 0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s1
; GFX10-NEXT:    v_sub_nc_u32_e32 v1, 0, v0
; GFX10-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-NEXT:    v_mov_b32_e32 v2, 4
; GFX10-NEXT:    v_mov_b32_e32 v3, 15
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 2, v1
; GFX10-NEXT:    v_add_nc_u32_e32 v0, v2, v0
; GFX10-NEXT:    v_add_nc_u32_e32 v1, v2, v1
; GFX10-NEXT:    scratch_store_dword v0, v3, off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, v1, off offset:124 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_endpgm
bb:
  %i = alloca [32 x float], align 4, addrspace(5)
  %i1 = bitcast [32 x float] addrspace(5)* %i to i8 addrspace(5)*
  %i2 = tail call i32 @llvm.amdgcn.workitem.id.x()
  %i3 = zext i32 %i2 to i64
  %i7 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i2
  %i8 = bitcast float addrspace(5)* %i7 to i32 addrspace(5)*
  store volatile i32 15, i32 addrspace(5)* %i8, align 4
  %i9 = sub nsw i32 31, %i2
  %i10 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i9
  %i11 = bitcast float addrspace(5)* %i10 to i32 addrspace(5)*
  %i12 = load volatile i32, i32 addrspace(5)* %i11, align 4
  ret void
}

define void @store_load_vindex_foo(i32 %idx) {
; GFX9-LABEL: store_load_vindex_foo:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 2, v0
; GFX9-NEXT:    v_and_b32_e32 v0, 15, v0
; GFX9-NEXT:    v_mov_b32_e32 v2, s32
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_add_u32_e32 v1, v2, v1
; GFX9-NEXT:    v_mov_b32_e32 v3, 15
; GFX9-NEXT:    scratch_store_dword v1, v3, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_add_u32_e32 v0, v2, v0
; GFX9-NEXT:    scratch_load_dword v0, v0, off glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: store_load_vindex_foo:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_and_b32_e32 v1, 15, v0
; GFX10-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-NEXT:    v_mov_b32_e32 v2, s32
; GFX10-NEXT:    v_mov_b32_e32 v3, 15
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 2, v1
; GFX10-NEXT:    v_add_nc_u32_e32 v0, v2, v0
; GFX10-NEXT:    v_add_nc_u32_e32 v1, v2, v1
; GFX10-NEXT:    scratch_store_dword v0, v3, off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, v1, off glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  %i = alloca [32 x float], align 4, addrspace(5)
  %i1 = bitcast [32 x float] addrspace(5)* %i to i8 addrspace(5)*
  %i7 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %idx
  %i8 = bitcast float addrspace(5)* %i7 to i32 addrspace(5)*
  store volatile i32 15, i32 addrspace(5)* %i8, align 4
  %i9 = and i32 %idx, 15
  %i10 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i9
  %i11 = bitcast float addrspace(5)* %i10 to i32 addrspace(5)*
  %i12 = load volatile i32, i32 addrspace(5)* %i11, align 4
  ret void
}

define void @private_ptr_foo(float addrspace(5)* nocapture %arg) {
; GFX9-LABEL: private_ptr_foo:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v1, 0x41200000
; GFX9-NEXT:    scratch_store_dword v0, v1, off offset:4
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: private_ptr_foo:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v1, 0x41200000
; GFX10-NEXT:    scratch_store_dword v0, v1, off offset:4
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %gep = getelementptr inbounds float, float addrspace(5)* %arg, i32 1
  store float 1.000000e+01, float addrspace(5)* %gep, align 4
  ret void
}

define amdgpu_kernel void @store_load_sindex_small_offset_kernel(i32 %idx) {
; GFX9-LABEL: store_load_sindex_small_offset_kernel:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_load_dword s0, s[0:1], 0x24
; GFX9-NEXT:    s_add_u32 flat_scratch_lo, s2, s5
; GFX9-NEXT:    s_addc_u32 flat_scratch_hi, s3, 0
; GFX9-NEXT:    s_add_u32 s2, 4, 0
; GFX9-NEXT:    v_mov_b32_e32 v0, 15
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_lshl_b32 s1, s0, 2
; GFX9-NEXT:    s_and_b32 s0, s0, 15
; GFX9-NEXT:    s_lshl_b32 s0, s0, 2
; GFX9-NEXT:    s_add_u32 s1, 0x104, s1
; GFX9-NEXT:    scratch_load_dword v1, off, s2 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    scratch_store_dword off, v0, s1
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_add_u32 s0, 0x104, s0
; GFX9-NEXT:    scratch_load_dword v0, off, s0 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_load_sindex_small_offset_kernel:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_add_u32 s2, s2, s5
; GFX10-NEXT:    s_addc_u32 s3, s3, 0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s2
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s3
; GFX10-NEXT:    s_load_dword s0, s[0:1], 0x24
; GFX10-NEXT:    s_add_u32 s1, 4, 0
; GFX10-NEXT:    scratch_load_dword v0, off, s1 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, 15
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_and_b32 s1, s0, 15
; GFX10-NEXT:    s_lshl_b32 s0, s0, 2
; GFX10-NEXT:    s_lshl_b32 s1, s1, 2
; GFX10-NEXT:    s_add_u32 s0, 0x104, s0
; GFX10-NEXT:    s_add_u32 s1, 0x104, s1
; GFX10-NEXT:    scratch_store_dword off, v0, s0
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, off, s1 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_endpgm
bb:
  %padding = alloca [64 x i32], align 4, addrspace(5)
  %i = alloca [32 x float], align 4, addrspace(5)
  %pad_gep = getelementptr inbounds [64 x i32], [64 x i32] addrspace(5)* %padding, i32 0, i32 undef
  %pad_load = load volatile i32, i32 addrspace(5)* %pad_gep, align 4
  %i1 = bitcast [32 x float] addrspace(5)* %i to i8 addrspace(5)*
  %i7 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %idx
  %i8 = bitcast float addrspace(5)* %i7 to i32 addrspace(5)*
  store volatile i32 15, i32 addrspace(5)* %i8, align 4
  %i9 = and i32 %idx, 15
  %i10 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i9
  %i11 = bitcast float addrspace(5)* %i10 to i32 addrspace(5)*
  %i12 = load volatile i32, i32 addrspace(5)* %i11, align 4
  ret void
}

define amdgpu_kernel void @store_load_vindex_small_offset_kernel() {
; GFX9-LABEL: store_load_vindex_small_offset_kernel:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_add_u32 flat_scratch_lo, s0, s3
; GFX9-NEXT:    s_addc_u32 flat_scratch_hi, s1, 0
; GFX9-NEXT:    s_add_u32 s0, 4, 0
; GFX9-NEXT:    scratch_load_dword v1, off, s0 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, 0, v0
; GFX9-NEXT:    v_mov_b32_e32 v2, 0x104
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_add_u32_e32 v1, v2, v1
; GFX9-NEXT:    v_mov_b32_e32 v3, 15
; GFX9-NEXT:    scratch_store_dword v1, v3, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_add_u32_e32 v0, v2, v0
; GFX9-NEXT:    scratch_load_dword v0, v0, off offset:124 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_load_vindex_small_offset_kernel:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_add_u32 s0, s0, s3
; GFX10-NEXT:    s_addc_u32 s1, s1, 0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s1
; GFX10-NEXT:    v_sub_nc_u32_e32 v1, 0, v0
; GFX10-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-NEXT:    v_mov_b32_e32 v2, 0x104
; GFX10-NEXT:    v_mov_b32_e32 v3, 15
; GFX10-NEXT:    s_add_u32 s0, 4, 0
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 2, v1
; GFX10-NEXT:    v_add_nc_u32_e32 v0, v2, v0
; GFX10-NEXT:    v_add_nc_u32_e32 v1, v2, v1
; GFX10-NEXT:    scratch_load_dword v2, off, s0 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    scratch_store_dword v0, v3, off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, v1, off offset:124 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_endpgm
bb:
  %padding = alloca [64 x i32], align 4, addrspace(5)
  %i = alloca [32 x float], align 4, addrspace(5)
  %pad_gep = getelementptr inbounds [64 x i32], [64 x i32] addrspace(5)* %padding, i32 0, i32 undef
  %pad_load = load volatile i32, i32 addrspace(5)* %pad_gep, align 4
  %i1 = bitcast [32 x float] addrspace(5)* %i to i8 addrspace(5)*
  %i2 = tail call i32 @llvm.amdgcn.workitem.id.x()
  %i3 = zext i32 %i2 to i64
  %i7 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i2
  %i8 = bitcast float addrspace(5)* %i7 to i32 addrspace(5)*
  store volatile i32 15, i32 addrspace(5)* %i8, align 4
  %i9 = sub nsw i32 31, %i2
  %i10 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i9
  %i11 = bitcast float addrspace(5)* %i10 to i32 addrspace(5)*
  %i12 = load volatile i32, i32 addrspace(5)* %i11, align 4
  ret void
}

define void @store_load_vindex_small_offset_foo(i32 %idx) {
; GFX9-LABEL: store_load_vindex_small_offset_foo:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_add_u32 s0, s32, 0
; GFX9-NEXT:    scratch_load_dword v1, off, s0 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_add_u32 vcc_hi, s32, 0x100
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 2, v0
; GFX9-NEXT:    v_and_b32_e32 v0, 15, v0
; GFX9-NEXT:    v_mov_b32_e32 v2, vcc_hi
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_add_u32_e32 v1, v2, v1
; GFX9-NEXT:    v_mov_b32_e32 v3, 15
; GFX9-NEXT:    scratch_store_dword v1, v3, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_add_u32_e32 v0, v2, v0
; GFX9-NEXT:    scratch_load_dword v0, v0, off glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: store_load_vindex_small_offset_foo:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_and_b32_e32 v1, 15, v0
; GFX10-NEXT:    s_add_u32 vcc_lo, s32, 0x100
; GFX10-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-NEXT:    v_mov_b32_e32 v2, vcc_lo
; GFX10-NEXT:    v_mov_b32_e32 v3, 15
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 2, v1
; GFX10-NEXT:    s_add_u32 s0, s32, 0
; GFX10-NEXT:    v_add_nc_u32_e32 v0, v2, v0
; GFX10-NEXT:    v_add_nc_u32_e32 v1, v2, v1
; GFX10-NEXT:    scratch_load_dword v2, off, s0 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    scratch_store_dword v0, v3, off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, v1, off glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  %padding = alloca [64 x i32], align 4, addrspace(5)
  %i = alloca [32 x float], align 4, addrspace(5)
  %pad_gep = getelementptr inbounds [64 x i32], [64 x i32] addrspace(5)* %padding, i32 0, i32 undef
  %pad_load = load volatile i32, i32 addrspace(5)* %pad_gep, align 4
  %i1 = bitcast [32 x float] addrspace(5)* %i to i8 addrspace(5)*
  %i7 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %idx
  %i8 = bitcast float addrspace(5)* %i7 to i32 addrspace(5)*
  store volatile i32 15, i32 addrspace(5)* %i8, align 4
  %i9 = and i32 %idx, 15
  %i10 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i9
  %i11 = bitcast float addrspace(5)* %i10 to i32 addrspace(5)*
  %i12 = load volatile i32, i32 addrspace(5)* %i11, align 4
  ret void
}

define amdgpu_kernel void @store_load_sindex_large_offset_kernel(i32 %idx) {
; GFX9-LABEL: store_load_sindex_large_offset_kernel:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_load_dword s0, s[0:1], 0x24
; GFX9-NEXT:    s_add_u32 flat_scratch_lo, s2, s5
; GFX9-NEXT:    s_addc_u32 flat_scratch_hi, s3, 0
; GFX9-NEXT:    s_add_u32 s2, 4, 0
; GFX9-NEXT:    v_mov_b32_e32 v0, 15
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_lshl_b32 s1, s0, 2
; GFX9-NEXT:    s_and_b32 s0, s0, 15
; GFX9-NEXT:    s_lshl_b32 s0, s0, 2
; GFX9-NEXT:    s_add_u32 s1, 0x4004, s1
; GFX9-NEXT:    scratch_load_dword v1, off, s2 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    scratch_store_dword off, v0, s1
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_add_u32 s0, 0x4004, s0
; GFX9-NEXT:    scratch_load_dword v0, off, s0 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_load_sindex_large_offset_kernel:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_add_u32 s2, s2, s5
; GFX10-NEXT:    s_addc_u32 s3, s3, 0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s2
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s3
; GFX10-NEXT:    s_load_dword s0, s[0:1], 0x24
; GFX10-NEXT:    s_add_u32 s1, 4, 0
; GFX10-NEXT:    scratch_load_dword v0, off, s1 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, 15
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_and_b32 s1, s0, 15
; GFX10-NEXT:    s_lshl_b32 s0, s0, 2
; GFX10-NEXT:    s_lshl_b32 s1, s1, 2
; GFX10-NEXT:    s_add_u32 s0, 0x4004, s0
; GFX10-NEXT:    s_add_u32 s1, 0x4004, s1
; GFX10-NEXT:    scratch_store_dword off, v0, s0
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, off, s1 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_endpgm
bb:
  %padding = alloca [4096 x i32], align 4, addrspace(5)
  %i = alloca [32 x float], align 4, addrspace(5)
  %pad_gep = getelementptr inbounds [4096 x i32], [4096 x i32] addrspace(5)* %padding, i32 0, i32 undef
  %pad_load = load volatile i32, i32 addrspace(5)* %pad_gep, align 4
  %i1 = bitcast [32 x float] addrspace(5)* %i to i8 addrspace(5)*
  %i7 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %idx
  %i8 = bitcast float addrspace(5)* %i7 to i32 addrspace(5)*
  store volatile i32 15, i32 addrspace(5)* %i8, align 4
  %i9 = and i32 %idx, 15
  %i10 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i9
  %i11 = bitcast float addrspace(5)* %i10 to i32 addrspace(5)*
  %i12 = load volatile i32, i32 addrspace(5)* %i11, align 4
  ret void
}

define amdgpu_kernel void @store_load_vindex_large_offset_kernel() {
; GFX9-LABEL: store_load_vindex_large_offset_kernel:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_add_u32 flat_scratch_lo, s0, s3
; GFX9-NEXT:    s_addc_u32 flat_scratch_hi, s1, 0
; GFX9-NEXT:    s_add_u32 s0, 4, 0
; GFX9-NEXT:    scratch_load_dword v1, off, s0 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, 0, v0
; GFX9-NEXT:    v_mov_b32_e32 v2, 0x4004
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_add_u32_e32 v1, v2, v1
; GFX9-NEXT:    v_mov_b32_e32 v3, 15
; GFX9-NEXT:    scratch_store_dword v1, v3, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_add_u32_e32 v0, v2, v0
; GFX9-NEXT:    scratch_load_dword v0, v0, off offset:124 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_load_vindex_large_offset_kernel:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_add_u32 s0, s0, s3
; GFX10-NEXT:    s_addc_u32 s1, s1, 0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s1
; GFX10-NEXT:    v_sub_nc_u32_e32 v1, 0, v0
; GFX10-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-NEXT:    v_mov_b32_e32 v2, 0x4004
; GFX10-NEXT:    v_mov_b32_e32 v3, 15
; GFX10-NEXT:    s_add_u32 s0, 4, 0
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 2, v1
; GFX10-NEXT:    v_add_nc_u32_e32 v0, v2, v0
; GFX10-NEXT:    v_add_nc_u32_e32 v1, v2, v1
; GFX10-NEXT:    scratch_load_dword v2, off, s0 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    scratch_store_dword v0, v3, off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, v1, off offset:124 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_endpgm
bb:
  %padding = alloca [4096 x i32], align 4, addrspace(5)
  %i = alloca [32 x float], align 4, addrspace(5)
  %pad_gep = getelementptr inbounds [4096 x i32], [4096 x i32] addrspace(5)* %padding, i32 0, i32 undef
  %pad_load = load volatile i32, i32 addrspace(5)* %pad_gep, align 4
  %i1 = bitcast [32 x float] addrspace(5)* %i to i8 addrspace(5)*
  %i2 = tail call i32 @llvm.amdgcn.workitem.id.x()
  %i3 = zext i32 %i2 to i64
  %i7 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i2
  %i8 = bitcast float addrspace(5)* %i7 to i32 addrspace(5)*
  store volatile i32 15, i32 addrspace(5)* %i8, align 4
  %i9 = sub nsw i32 31, %i2
  %i10 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i9
  %i11 = bitcast float addrspace(5)* %i10 to i32 addrspace(5)*
  %i12 = load volatile i32, i32 addrspace(5)* %i11, align 4
  ret void
}

define void @store_load_vindex_large_offset_foo(i32 %idx) {
; GFX9-LABEL: store_load_vindex_large_offset_foo:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_add_u32 s0, s32, 0
; GFX9-NEXT:    scratch_load_dword v1, off, s0 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_add_u32 vcc_hi, s32, 0x4000
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 2, v0
; GFX9-NEXT:    v_and_b32_e32 v0, 15, v0
; GFX9-NEXT:    v_mov_b32_e32 v2, vcc_hi
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_add_u32_e32 v1, v2, v1
; GFX9-NEXT:    v_mov_b32_e32 v3, 15
; GFX9-NEXT:    scratch_store_dword v1, v3, off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_add_u32_e32 v0, v2, v0
; GFX9-NEXT:    scratch_load_dword v0, v0, off glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: store_load_vindex_large_offset_foo:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_and_b32_e32 v1, 15, v0
; GFX10-NEXT:    s_add_u32 vcc_lo, s32, 0x4000
; GFX10-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX10-NEXT:    v_mov_b32_e32 v2, vcc_lo
; GFX10-NEXT:    v_mov_b32_e32 v3, 15
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 2, v1
; GFX10-NEXT:    s_add_u32 s0, s32, 0
; GFX10-NEXT:    v_add_nc_u32_e32 v0, v2, v0
; GFX10-NEXT:    v_add_nc_u32_e32 v1, v2, v1
; GFX10-NEXT:    scratch_load_dword v2, off, s0 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    scratch_store_dword v0, v3, off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, v1, off glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  %padding = alloca [4096 x i32], align 4, addrspace(5)
  %i = alloca [32 x float], align 4, addrspace(5)
  %pad_gep = getelementptr inbounds [4096 x i32], [4096 x i32] addrspace(5)* %padding, i32 0, i32 undef
  %pad_load = load volatile i32, i32 addrspace(5)* %pad_gep, align 4
  %i1 = bitcast [32 x float] addrspace(5)* %i to i8 addrspace(5)*
  %i7 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %idx
  %i8 = bitcast float addrspace(5)* %i7 to i32 addrspace(5)*
  store volatile i32 15, i32 addrspace(5)* %i8, align 4
  %i9 = and i32 %idx, 15
  %i10 = getelementptr inbounds [32 x float], [32 x float] addrspace(5)* %i, i32 0, i32 %i9
  %i11 = bitcast float addrspace(5)* %i10 to i32 addrspace(5)*
  %i12 = load volatile i32, i32 addrspace(5)* %i11, align 4
  ret void
}

define amdgpu_kernel void @store_load_large_imm_offset_kernel() {
; GFX9-LABEL: store_load_large_imm_offset_kernel:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_add_u32 flat_scratch_lo, s0, s3
; GFX9-NEXT:    s_addc_u32 flat_scratch_hi, s1, 0
; GFX9-NEXT:    v_mov_b32_e32 v0, 13
; GFX9-NEXT:    s_add_u32 s0, 4, 0
; GFX9-NEXT:    scratch_store_dword off, v0, s0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_movk_i32 s0, 0x3e80
; GFX9-NEXT:    v_mov_b32_e32 v0, 15
; GFX9-NEXT:    s_add_u32 s0, 4, s0
; GFX9-NEXT:    scratch_store_dword off, v0, s0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    scratch_load_dword v0, off, s0 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_load_large_imm_offset_kernel:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_add_u32 s0, s0, s3
; GFX10-NEXT:    s_addc_u32 s1, s1, 0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s1
; GFX10-NEXT:    v_mov_b32_e32 v0, 13
; GFX10-NEXT:    v_mov_b32_e32 v1, 15
; GFX10-NEXT:    s_movk_i32 s0, 0x3e80
; GFX10-NEXT:    s_add_u32 s1, 4, 0
; GFX10-NEXT:    s_add_u32 s0, 4, s0
; GFX10-NEXT:    scratch_store_dword off, v0, s1
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_store_dword off, v1, s0
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, off, s0 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_endpgm
bb:
  %i = alloca [4096 x i32], align 4, addrspace(5)
  %i1 = getelementptr inbounds [4096 x i32], [4096 x i32] addrspace(5)* %i, i32 0, i32 undef
  store volatile i32 13, i32 addrspace(5)* %i1, align 4
  %i7 = getelementptr inbounds [4096 x i32], [4096 x i32] addrspace(5)* %i, i32 0, i32 4000
  store volatile i32 15, i32 addrspace(5)* %i7, align 4
  %i10 = getelementptr inbounds [4096 x i32], [4096 x i32] addrspace(5)* %i, i32 0, i32 4000
  %i12 = load volatile i32, i32 addrspace(5)* %i10, align 4
  ret void
}

define void @store_load_large_imm_offset_foo() {
; GFX9-LABEL: store_load_large_imm_offset_foo:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, 13
; GFX9-NEXT:    s_add_u32 s0, s32, 0
; GFX9-NEXT:    scratch_store_dword off, v0, s0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_movk_i32 s0, 0x3e80
; GFX9-NEXT:    v_mov_b32_e32 v0, 15
; GFX9-NEXT:    s_add_u32 s0, s32, s0
; GFX9-NEXT:    scratch_store_dword off, v0, s0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    scratch_load_dword v0, off, s0 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: store_load_large_imm_offset_foo:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v0, 13
; GFX10-NEXT:    v_mov_b32_e32 v1, 15
; GFX10-NEXT:    s_movk_i32 s0, 0x3e80
; GFX10-NEXT:    s_add_u32 s1, s32, 0
; GFX10-NEXT:    s_add_u32 s0, s32, s0
; GFX10-NEXT:    scratch_store_dword off, v0, s1
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_store_dword off, v1, s0
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, off, s0 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  %i = alloca [4096 x i32], align 4, addrspace(5)
  %i1 = getelementptr inbounds [4096 x i32], [4096 x i32] addrspace(5)* %i, i32 0, i32 undef
  store volatile i32 13, i32 addrspace(5)* %i1, align 4
  %i7 = getelementptr inbounds [4096 x i32], [4096 x i32] addrspace(5)* %i, i32 0, i32 4000
  store volatile i32 15, i32 addrspace(5)* %i7, align 4
  %i10 = getelementptr inbounds [4096 x i32], [4096 x i32] addrspace(5)* %i, i32 0, i32 4000
  %i12 = load volatile i32, i32 addrspace(5)* %i10, align 4
  ret void
}

define amdgpu_kernel void @store_load_vidx_sidx_offset(i32 %sidx) {
; GFX9-LABEL: store_load_vidx_sidx_offset:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_load_dword s0, s[0:1], 0x24
; GFX9-NEXT:    s_add_u32 flat_scratch_lo, s2, s5
; GFX9-NEXT:    s_addc_u32 flat_scratch_hi, s3, 0
; GFX9-NEXT:    v_mov_b32_e32 v1, 15
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_add_lshl_u32 v0, s0, v0, 2
; GFX9-NEXT:    v_add_u32_e32 v0, 4, v0
; GFX9-NEXT:    scratch_store_dword v0, v1, off offset:1024
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    scratch_load_dword v0, v0, off offset:1024 glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_load_vidx_sidx_offset:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_add_u32 s2, s2, s5
; GFX10-NEXT:    s_addc_u32 s3, s3, 0
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s2
; GFX10-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s3
; GFX10-NEXT:    s_load_dword s0, s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v1, 15
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_add_lshl_u32 v0, s0, v0, 2
; GFX10-NEXT:    v_add_nc_u32_e32 v0, 4, v0
; GFX10-NEXT:    scratch_store_dword v0, v1, off offset:1024
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dword v0, v0, off offset:1024 glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_endpgm
bb:
  %alloca = alloca [32 x i32], align 4, addrspace(5)
  %vidx = tail call i32 @llvm.amdgcn.workitem.id.x()
  %add1 = add nsw i32 %sidx, %vidx
  %add2 = add nsw i32 %add1, 256
  %gep = getelementptr inbounds [32 x i32], [32 x i32] addrspace(5)* %alloca, i32 0, i32 %add2
  store volatile i32 15, i32 addrspace(5)* %gep, align 4
  %load = load volatile i32, i32 addrspace(5)* %gep, align 4
  ret void
}

define void @store_load_i64_aligned(i64 addrspace(5)* nocapture %arg) {
; GFX9-LABEL: store_load_i64_aligned:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v1, 15
; GFX9-NEXT:    v_mov_b32_e32 v2, 0
; GFX9-NEXT:    scratch_store_dwordx2 v0, v[1:2], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    scratch_load_dwordx2 v[0:1], v0, off glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: store_load_i64_aligned:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v1, 15
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    scratch_store_dwordx2 v0, v[1:2], off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dwordx2 v[0:1], v0, off glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  store volatile i64 15, i64 addrspace(5)* %arg, align 8
  %load = load volatile i64, i64 addrspace(5)* %arg, align 8
  ret void
}

define void @store_load_i64_unaligned(i64 addrspace(5)* nocapture %arg) {
; GFX9-LABEL: store_load_i64_unaligned:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v1, 15
; GFX9-NEXT:    v_mov_b32_e32 v2, 0
; GFX9-NEXT:    scratch_store_dwordx2 v0, v[1:2], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    scratch_load_dwordx2 v[0:1], v0, off glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: store_load_i64_unaligned:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_mov_b32_e32 v1, 15
; GFX10-NEXT:    v_mov_b32_e32 v2, 0
; GFX10-NEXT:    scratch_store_dwordx2 v0, v[1:2], off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dwordx2 v[0:1], v0, off glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  store volatile i64 15, i64 addrspace(5)* %arg, align 1
  %load = load volatile i64, i64 addrspace(5)* %arg, align 1
  ret void
}

define void @store_load_v3i32_unaligned(<3 x i32> addrspace(5)* nocapture %arg) {
; GFX9-LABEL: store_load_v3i32_unaligned:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s2, 3
; GFX9-NEXT:    s_mov_b32 s1, 2
; GFX9-NEXT:    s_mov_b32 s0, 1
; GFX9-NEXT:    v_mov_b32_e32 v3, s2
; GFX9-NEXT:    v_mov_b32_e32 v2, s1
; GFX9-NEXT:    v_mov_b32_e32 v1, s0
; GFX9-NEXT:    scratch_store_dwordx3 v0, v[1:3], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    scratch_load_dwordx3 v[0:2], v0, off glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: store_load_v3i32_unaligned:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_mov_b32 s2, 3
; GFX10-NEXT:    s_mov_b32 s1, 2
; GFX10-NEXT:    s_mov_b32 s0, 1
; GFX10-NEXT:    v_mov_b32_e32 v3, s2
; GFX10-NEXT:    v_mov_b32_e32 v2, s1
; GFX10-NEXT:    v_mov_b32_e32 v1, s0
; GFX10-NEXT:    scratch_store_dwordx3 v0, v[1:3], off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dwordx3 v[0:2], v0, off glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  store volatile <3 x i32> <i32 1, i32 2, i32 3>, <3 x i32> addrspace(5)* %arg, align 1
  %load = load volatile <3 x i32>, <3 x i32> addrspace(5)* %arg, align 1
  ret void
}

define void @store_load_v4i32_unaligned(<4 x i32> addrspace(5)* nocapture %arg) {
; GFX9-LABEL: store_load_v4i32_unaligned:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s3, 4
; GFX9-NEXT:    s_mov_b32 s2, 3
; GFX9-NEXT:    s_mov_b32 s1, 2
; GFX9-NEXT:    s_mov_b32 s0, 1
; GFX9-NEXT:    v_mov_b32_e32 v4, s3
; GFX9-NEXT:    v_mov_b32_e32 v3, s2
; GFX9-NEXT:    v_mov_b32_e32 v2, s1
; GFX9-NEXT:    v_mov_b32_e32 v1, s0
; GFX9-NEXT:    scratch_store_dwordx4 v0, v[1:4], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    scratch_load_dwordx4 v[0:3], v0, off glc
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: store_load_v4i32_unaligned:
; GFX10:       ; %bb.0: ; %bb
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_mov_b32 s3, 4
; GFX10-NEXT:    s_mov_b32 s2, 3
; GFX10-NEXT:    s_mov_b32 s1, 2
; GFX10-NEXT:    s_mov_b32 s0, 1
; GFX10-NEXT:    v_mov_b32_e32 v4, s3
; GFX10-NEXT:    v_mov_b32_e32 v3, s2
; GFX10-NEXT:    v_mov_b32_e32 v2, s1
; GFX10-NEXT:    v_mov_b32_e32 v1, s0
; GFX10-NEXT:    scratch_store_dwordx4 v0, v[1:4], off
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    scratch_load_dwordx4 v[0:3], v0, off glc dlc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    s_setpc_b64 s[30:31]
bb:
  store volatile <4 x i32> <i32 1, i32 2, i32 3, i32 4>, <4 x i32> addrspace(5)* %arg, align 1
  %load = load volatile <4 x i32>, <4 x i32> addrspace(5)* %arg, align 1
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x()
