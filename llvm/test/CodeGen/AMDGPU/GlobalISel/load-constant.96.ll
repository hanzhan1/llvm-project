; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 -mattr=+unaligned-buffer-access < %s | FileCheck -check-prefixes=GCN,GFX9,GFX9-UNALIGNED %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 -mattr=-unaligned-buffer-access < %s | FileCheck -check-prefixes=GCN,GFX9,GFX9-NOUNALIGNED %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=hawaii -mattr=+unaligned-buffer-access < %s | FileCheck -check-prefixes=GCN,GFX7,GFX7-UNALIGNED %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=hawaii -mattr=-unaligned-buffer-access < %s | FileCheck -check-prefixes=GCN,GFX7,GFX7-NOUNALIGNED %s

; FIXME:
; XUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=tahiti < %s | FileCheck -check-prefixes=GCN,GFX6 %s

define <3 x i32> @v_load_constant_v3i32_align1(<3 x i32> addrspace(4)* %ptr) {
; GFX9-UNALIGNED-LABEL: v_load_constant_v3i32_align1:
; GFX9-UNALIGNED:       ; %bb.0:
; GFX9-UNALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-UNALIGNED-NEXT:    global_load_dwordx3 v[0:2], v[0:1], off
; GFX9-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX9-UNALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-NOUNALIGNED-LABEL: v_load_constant_v3i32_align1:
; GFX9-NOUNALIGNED:       ; %bb.0:
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NOUNALIGNED-NEXT:	v_add_co_u32_e32 v2, vcc, 11, v0
; GFX9-NOUNALIGNED-NEXT:	v_addc_co_u32_e32 v3, vcc, 0, v1, vcc
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v0, v[0:1], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v1, v[2:3], off offset:-10
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v4, v[2:3], off offset:-9
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v5, v[2:3], off offset:-8
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v6, v[2:3], off offset:-7
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v7, v[2:3], off offset:-6
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v8, v[2:3], off offset:-5
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v9, v[2:3], off offset:-4
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v10, v[2:3], off offset:-3
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v11, v[2:3], off offset:-2
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v12, v[2:3], off offset:-1
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v2, v[2:3], off
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v3, 0xff
; GFX9-NOUNALIGNED-NEXT:	s_movk_i32 s4, 0xff
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v13, 8
; GFX9-NOUNALIGNED-NEXT:	s_mov_b32 s5, 8
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(10)
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_sdwa v1, s5, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(9)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v4, s4, v4
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(8)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v5, s4, v5
; GFX9-NOUNALIGNED-NEXT:	v_and_or_b32 v0, v0, s4, v1
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(6)
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_sdwa v7, v13, v7 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(5)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v8, v8, v3
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(4)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v9, v9, v3
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v1, 16, v4
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(2)
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_sdwa v11, v13, v11 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(1)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v12, v12, v3
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(0)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v2, v2, v3
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v4, 24, v5
; GFX9-NOUNALIGNED-NEXT:	v_and_or_b32 v5, v6, v3, v7
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v6, 16, v8
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v7, 24, v9
; GFX9-NOUNALIGNED-NEXT:	v_and_or_b32 v3, v10, v3, v11
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v8, 16, v12
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v2, 24, v2
; GFX9-NOUNALIGNED-NEXT:	v_or3_b32 v0, v0, v1, v4
; GFX9-NOUNALIGNED-NEXT:	v_or3_b32 v1, v5, v6, v7
; GFX9-NOUNALIGNED-NEXT:	v_or3_b32 v2, v3, v8, v2
; GFX9-NOUNALIGNED-NEXT:	s_setpc_b64 s[30:31]
;
; GFX7-UNALIGNED-LABEL: v_load_constant_v3i32_align1:
; GFX7-UNALIGNED:       ; %bb.0:
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-UNALIGNED-NEXT:    s_mov_b32 s6, 0
; GFX7-UNALIGNED-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-UNALIGNED-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-UNALIGNED-NEXT:    buffer_load_dwordx3 v[0:2], v[0:1], s[4:7], 0 addr64
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-UNALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-NOUNALIGNED-LABEL: v_load_constant_v3i32_align1:
; GFX7-NOUNALIGNED:       ; %bb.0:
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NOUNALIGNED-NEXT:    s_mov_b32 s6, 0
; GFX7-NOUNALIGNED-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NOUNALIGNED-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v2, v[0:1], s[4:7], 0 addr64
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v3, v[0:1], s[4:7], 0 addr64 offset:1
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v4, v[0:1], s[4:7], 0 addr64 offset:2
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v5, v[0:1], s[4:7], 0 addr64 offset:3
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v6, v[0:1], s[4:7], 0 addr64 offset:4
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v7, v[0:1], s[4:7], 0 addr64 offset:5
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v8, v[0:1], s[4:7], 0 addr64 offset:6
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v9, v[0:1], s[4:7], 0 addr64 offset:7
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v10, v[0:1], s[4:7], 0 addr64 offset:8
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v11, v[0:1], s[4:7], 0 addr64 offset:9
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v12, v[0:1], s[4:7], 0 addr64 offset:10
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v0, v[0:1], s[4:7], 0 addr64 offset:11
; GFX7-NOUNALIGNED-NEXT:    v_mov_b32_e32 v1, 0xff
; GFX7-NOUNALIGNED-NEXT:    s_movk_i32 s4, 0xff
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(11)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v2, s4, v2
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(10)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v3, s4, v3
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(9)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v4, s4, v4
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(8)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v5, s4, v5
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(7)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v6, s4, v6
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(6)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v7, v7, v1
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(5)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v8, v8, v1
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(4)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v9, v9, v1
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(3)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v10, v10, v1
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(2)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v11, v11, v1
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(1)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v12, v12, v1
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v0, v0, v1
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v1, 8, v3
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v3, 16, v4
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v4, 24, v5
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v5, 8, v7
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v7, 16, v8
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v8, 24, v9
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v9, 8, v11
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v11, 16, v12
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v12, 24, v0
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v0, v2, v1
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v1, v6, v5
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v2, v10, v9
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v0, v0, v3
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v1, v1, v7
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v2, v2, v11
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v0, v0, v4
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v1, v1, v8
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v2, v2, v12
; GFX7-NOUNALIGNED-NEXT:    s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(4)* %ptr, align 1
  ret <3 x i32> %load
}

define <3 x i32> @v_load_constant_v3i32_align2(<3 x i32> addrspace(4)* %ptr) {
; GFX9-UNALIGNED-LABEL: v_load_constant_v3i32_align2:
; GFX9-UNALIGNED:       ; %bb.0:
; GFX9-UNALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-UNALIGNED-NEXT:    global_load_dwordx3 v[0:2], v[0:1], off
; GFX9-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX9-UNALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-NOUNALIGNED-LABEL: v_load_constant_v3i32_align2:
; GFX9-NOUNALIGNED:       ; %bb.0:
; GFX9-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NOUNALIGNED-NEXT:        v_add_co_u32_e32 v2, vcc, 10, v0
; GFX9-NOUNALIGNED-NEXT:        v_addc_co_u32_e32 v3, vcc, 0, v1, vcc
; GFX9-NOUNALIGNED-NEXT:        global_load_ushort v0, v[0:1], off
; GFX9-NOUNALIGNED-NEXT:        global_load_ushort v1, v[2:3], off offset:-8
; GFX9-NOUNALIGNED-NEXT:        global_load_ushort v4, v[2:3], off offset:-6
; GFX9-NOUNALIGNED-NEXT:        global_load_ushort v5, v[2:3], off offset:-4
; GFX9-NOUNALIGNED-NEXT:        global_load_ushort v6, v[2:3], off offset:-2
; GFX9-NOUNALIGNED-NEXT:        global_load_ushort v2, v[2:3], off
; GFX9-NOUNALIGNED-NEXT:        v_mov_b32_e32 v3, 0xffff
; GFX9-NOUNALIGNED-NEXT:        s_mov_b32 s4, 0xffff
; GFX9-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(4)
; GFX9-NOUNALIGNED-NEXT:        v_and_b32_e32 v1, s4, v1
; GFX9-NOUNALIGNED-NEXT:        v_lshlrev_b32_e32 v1, 16, v1
; GFX9-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(2)
; GFX9-NOUNALIGNED-NEXT:        v_and_b32_e32 v5, v5, v3
; GFX9-NOUNALIGNED-NEXT:        v_lshlrev_b32_e32 v5, 16, v5
; GFX9-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(0)
; GFX9-NOUNALIGNED-NEXT:        v_and_b32_e32 v2, v2, v3
; GFX9-NOUNALIGNED-NEXT:        v_lshlrev_b32_e32 v2, 16, v2
; GFX9-NOUNALIGNED-NEXT:        v_and_or_b32 v0, v0, s4, v1
; GFX9-NOUNALIGNED-NEXT:        v_and_or_b32 v1, v4, v3, v5
; GFX9-NOUNALIGNED-NEXT:        v_and_or_b32 v2, v6, v3, v2
; GFX9-NOUNALIGNED-NEXT:        s_setpc_b64 s[30:31]
;
; GFX7-UNALIGNED-LABEL: v_load_constant_v3i32_align2:
; GFX7-UNALIGNED:       ; %bb.0:
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-UNALIGNED-NEXT:    s_mov_b32 s6, 0
; GFX7-UNALIGNED-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-UNALIGNED-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-UNALIGNED-NEXT:    buffer_load_dwordx3 v[0:2], v[0:1], s[4:7], 0 addr64
; GFX7-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-UNALIGNED-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-NOUNALIGNED-LABEL: v_load_constant_v3i32_align2:
; GFX7-NOUNALIGNED:       ; %bb.0:
; GFX7-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NOUNALIGNED-NEXT:        s_mov_b32 s6, 0
; GFX7-NOUNALIGNED-NEXT:        s_mov_b32 s7, 0xf000
; GFX7-NOUNALIGNED-NEXT:        s_mov_b64 s[4:5], 0
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v2, v[0:1], s[4:7], 0 addr64
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v3, v[0:1], s[4:7], 0 addr64 offset:2
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v4, v[0:1], s[4:7], 0 addr64 offset:4
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v5, v[0:1], s[4:7], 0 addr64 offset:6
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v6, v[0:1], s[4:7], 0 addr64 offset:8
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v0, v[0:1], s[4:7], 0 addr64 offset:10
; GFX7-NOUNALIGNED-NEXT:        s_mov_b32 s4, 0xffff
; GFX7-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(5)
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v1, s4, v2
; GFX7-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(4)
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v2, s4, v3
; GFX7-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(3)
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v3, s4, v4
; GFX7-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(2)
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v4, s4, v5
; GFX7-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(1)
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v5, s4, v6
; GFX7-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(0)
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v0, s4, v0
; GFX7-NOUNALIGNED-NEXT:        v_lshlrev_b32_e32 v2, 16, v2
; GFX7-NOUNALIGNED-NEXT:        v_lshlrev_b32_e32 v6, 16, v0
; GFX7-NOUNALIGNED-NEXT:        v_lshlrev_b32_e32 v4, 16, v4
; GFX7-NOUNALIGNED-NEXT:        v_or_b32_e32 v0, v1, v2
; GFX7-NOUNALIGNED-NEXT:        v_or_b32_e32 v1, v3, v4
; GFX7-NOUNALIGNED-NEXT:        v_or_b32_e32 v2, v5, v6
; GFX7-NOUNALIGNED-NEXT:        s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(4)* %ptr, align 2
  ret <3 x i32> %load
}

define <3 x i32> @v_load_constant_v3i32_align4(<3 x i32> addrspace(4)* %ptr) {
; GFX9-LABEL: v_load_constant_v3i32_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx3 v[0:2], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_load_constant_v3i32_align4:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx3 v[0:2], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(4)* %ptr, align 4
  ret <3 x i32> %load
}

define i96 @v_load_constant_i96_align8(i96 addrspace(4)* %ptr) {
; GFX9-LABEL: v_load_constant_i96_align8:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx3 v[0:2], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_load_constant_i96_align8:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx3 v[0:2], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load i96, i96 addrspace(4)* %ptr, align 8
  ret i96 %load
}

define <3 x i32> @v_load_constant_v3i32_align8(<3 x i32> addrspace(4)* %ptr) {
; GFX9-LABEL: v_load_constant_v3i32_align8:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx3 v[0:2], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_load_constant_v3i32_align8:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx3 v[0:2], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(4)* %ptr, align 8
  ret <3 x i32> %load
}

define <6 x i16> @v_load_constant_v6i16_align8(<6 x i16> addrspace(4)* %ptr) {
; GFX9-LABEL: v_load_constant_v6i16_align8:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx3 v[0:2], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_load_constant_v6i16_align8:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx3 v[6:8], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_lshrrev_b32_e32 v1, 16, v6
; GFX7-NEXT:    v_lshrrev_b32_e32 v3, 16, v7
; GFX7-NEXT:    v_lshrrev_b32_e32 v5, 16, v8
; GFX7-NEXT:    v_mov_b32_e32 v0, v6
; GFX7-NEXT:    v_mov_b32_e32 v2, v7
; GFX7-NEXT:    v_mov_b32_e32 v4, v8
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <6 x i16>, <6 x i16> addrspace(4)* %ptr, align 8
  ret <6 x i16> %load
}

define <12 x i8> @v_load_constant_v12i8_align8(<12 x i8> addrspace(4)* %ptr) {
; GFX9-LABEL: v_load_constant_v12i8_align8:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx3 v[0:2], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshrrev_b32_e32 v13, 8, v0
; GFX9-NEXT:    v_lshrrev_b32_e32 v12, 16, v0
; GFX9-NEXT:    v_lshrrev_b32_e32 v3, 24, v0
; GFX9-NEXT:    v_lshrrev_b32_e32 v5, 8, v1
; GFX9-NEXT:    v_lshrrev_b32_e32 v6, 16, v1
; GFX9-NEXT:    v_lshrrev_b32_e32 v7, 24, v1
; GFX9-NEXT:    v_mov_b32_e32 v4, v1
; GFX9-NEXT:    v_lshrrev_b32_e32 v9, 8, v2
; GFX9-NEXT:    v_lshrrev_b32_e32 v10, 16, v2
; GFX9-NEXT:    v_lshrrev_b32_e32 v11, 24, v2
; GFX9-NEXT:    v_mov_b32_e32 v8, v2
; GFX9-NEXT:    v_mov_b32_e32 v1, v13
; GFX9-NEXT:    v_mov_b32_e32 v2, v12
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_load_constant_v12i8_align8:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx3 v[0:2], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_lshrrev_b32_e32 v13, 8, v0
; GFX7-NEXT:    v_lshrrev_b32_e32 v12, 16, v0
; GFX7-NEXT:    v_lshrrev_b32_e32 v3, 24, v0
; GFX7-NEXT:    v_lshrrev_b32_e32 v5, 8, v1
; GFX7-NEXT:    v_lshrrev_b32_e32 v6, 16, v1
; GFX7-NEXT:    v_lshrrev_b32_e32 v7, 24, v1
; GFX7-NEXT:    v_mov_b32_e32 v4, v1
; GFX7-NEXT:    v_lshrrev_b32_e32 v9, 8, v2
; GFX7-NEXT:    v_lshrrev_b32_e32 v10, 16, v2
; GFX7-NEXT:    v_lshrrev_b32_e32 v11, 24, v2
; GFX7-NEXT:    v_mov_b32_e32 v8, v2
; GFX7-NEXT:    v_mov_b32_e32 v1, v13
; GFX7-NEXT:    v_mov_b32_e32 v2, v12
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <12 x i8>, <12 x i8> addrspace(4)* %ptr, align 8
  ret <12 x i8> %load
}

define <3 x i32> @v_load_constant_v3i32_align16(<3 x i32> addrspace(4)* %ptr) {
; GFX9-LABEL: v_load_constant_v3i32_align16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx3 v[0:2], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_load_constant_v3i32_align16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx3 v[0:2], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %load = load <3 x i32>, <3 x i32> addrspace(4)* %ptr, align 16
  ret <3 x i32> %load
}

define amdgpu_ps <3 x i32> @s_load_constant_v3i32_align1(<3 x i32> addrspace(4)* inreg %ptr) {
; GFX9-UNALIGNED-LABEL: s_load_constant_v3i32_align1:
; GFX9-UNALIGNED:       ; %bb.0:
; GFX9-UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-UNALIGNED-NEXT:    v_mov_b32_e32 v1, s1
; GFX9-UNALIGNED-NEXT:    global_load_dwordx3 v[0:2], v[0:1], off
; GFX9-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX9-UNALIGNED-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-UNALIGNED-NEXT:    v_readfirstlane_b32 s1, v1
; GFX9-UNALIGNED-NEXT:    v_readfirstlane_b32 s2, v2
; GFX9-UNALIGNED-NEXT:    ; return to shader part epilog
;
; GFX9-NOUNALIGNED-LABEL: s_load_constant_v3i32_align1:
; GFX9-NOUNALIGNED:       ; %bb.0:
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 1
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v2, s2
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v3, s3
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 2
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v5, s3
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v4, s2
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 3
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v7, s3
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v6, s2
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 4
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v9, s3
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v8, s2
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 5
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v11, s3
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v10, s2
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 6
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v13, s3
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v12, s2
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 7
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v0, s0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v15, s3
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v14, s2
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 8
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v1, s1
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v16, v[0:1], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v17, v[2:3], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v18, v[4:5], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v19, v[6:7], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v8, v[8:9], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v9, v[10:11], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v10, v[12:13], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v11, v[14:15], off
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v0, s2
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v1, s3
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 9
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v2, s2
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v3, s3
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 10
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s0, s0, 11
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s1, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v5, s3
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v7, s1
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v4, s2
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v6, s0
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v12, v[0:1], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v2, v[2:3], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v3, v[4:5], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ubyte v4, v[6:7], off
; GFX9-NOUNALIGNED-NEXT:	s_movk_i32 s0, 0xff
; GFX9-NOUNALIGNED-NEXT:	s_mov_b32 s1, 8
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v5, 0xff
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v6, 8
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(10)
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_sdwa v0, s1, v17 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(9)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v1, s0, v18
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(8)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v7, s0, v19
; GFX9-NOUNALIGNED-NEXT:	v_and_or_b32 v0, v16, s0, v0
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v1, 16, v1
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v7, 24, v7
; GFX9-NOUNALIGNED-NEXT:	v_or3_b32 v0, v0, v1, v7
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(5)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v1, v10, v5
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(4)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v7, v11, v5
; GFX9-NOUNALIGNED-NEXT:	v_readfirstlane_b32 s0, v0
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_sdwa v0, v6, v9 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX9-NOUNALIGNED-NEXT:	v_and_or_b32 v0, v8, v5, v0
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v1, 16, v1
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v7, 24, v7
; GFX9-NOUNALIGNED-NEXT:	v_or3_b32 v1, v0, v1, v7
; GFX9-NOUNALIGNED-NEXT:	v_readfirstlane_b32 s1, v1
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(2)
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_sdwa v0, v6, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(1)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v1, v3, v5
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(0)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v2, v4, v5
; GFX9-NOUNALIGNED-NEXT:	v_and_or_b32 v0, v12, v5, v0
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v1, 16, v1
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v2, 24, v2
; GFX9-NOUNALIGNED-NEXT:	v_or3_b32 v2, v0, v1, v2
; GFX9-NOUNALIGNED-NEXT:	v_readfirstlane_b32 s2, v2
; GFX9-NOUNALIGNED-NEXT:	; return to shader part epilog
;
; GFX7-UNALIGNED-LABEL: s_load_constant_v3i32_align1:
; GFX7-UNALIGNED:       ; %bb.0:
; GFX7-UNALIGNED-NEXT:    s_load_dwordx2 s[6:7], s[0:1], 0x0
; GFX7-UNALIGNED-NEXT:    s_load_dword s0, s[0:1], 0x2
; GFX7-UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v0, s6
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v2, s8
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v2, s0
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v1, s7
; GFX7-UNALIGNED-NEXT:    v_readfirstlane_b32 s0, v0
; GFX7-UNALIGNED-NEXT:    v_readfirstlane_b32 s1, v1
; GFX7-UNALIGNED-NEXT:    v_readfirstlane_b32 s2, v2
; GFX7-UNALIGNED-NEXT:    ; return to shader part epilog
;
; GFX7-NOUNALIGNED-LABEL: s_load_constant_v3i32_align1:
; GFX7-NOUNALIGNED:       ; %bb.0:
; GFX7-NOUNALIGNED-NEXT:    s_mov_b32 s2, -1
; GFX7-NOUNALIGNED-NEXT:    s_mov_b32 s3, 0xf000
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v0, off, s[0:3], 0
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v1, off, s[0:3], 0 offset:1
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v2, off, s[0:3], 0 offset:2
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v3, off, s[0:3], 0 offset:3
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v4, off, s[0:3], 0 offset:4
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v5, off, s[0:3], 0 offset:5
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v6, off, s[0:3], 0 offset:6
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v7, off, s[0:3], 0 offset:7
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v8, off, s[0:3], 0 offset:8
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v9, off, s[0:3], 0 offset:9
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v10, off, s[0:3], 0 offset:10
; GFX7-NOUNALIGNED-NEXT:    buffer_load_ubyte v11, off, s[0:3], 0 offset:11
; GFX7-NOUNALIGNED-NEXT:    v_mov_b32_e32 v12, 0xff
; GFX7-NOUNALIGNED-NEXT:    s_movk_i32 s0, 0xff
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(11)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v0, s0, v0
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(10)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v1, s0, v1
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(9)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v2, s0, v2
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v1, 8, v1
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(7)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v4, s0, v4
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(6)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v5, v5, v12
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(5)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v6, v6, v12
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v5, 8, v5
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(3)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v8, v8, v12
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(2)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v9, v9, v12
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(1)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v10, v10, v12
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v9, 8, v9
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v3, s0, v3
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v7, v7, v12
; GFX7-NOUNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NOUNALIGNED-NEXT:    v_and_b32_e32 v11, v11, v12
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v1, v4, v5
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v6, 16, v6
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v10, 16, v10
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v4, v8, v9
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v0, v0, v2
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v3, 24, v3
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v7, 24, v7
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v1, v1, v6
; GFX7-NOUNALIGNED-NEXT:    v_lshlrev_b32_e32 v11, 24, v11
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v2, v4, v10
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v0, v0, v3
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v1, v1, v7
; GFX7-NOUNALIGNED-NEXT:    v_or_b32_e32 v2, v2, v11
; GFX7-NOUNALIGNED-NEXT:    v_readfirstlane_b32 s0, v0
; GFX7-NOUNALIGNED-NEXT:    v_readfirstlane_b32 s1, v1
; GFX7-NOUNALIGNED-NEXT:    v_readfirstlane_b32 s2, v2
; GFX7-NOUNALIGNED-NEXT:    ; return to shader part epilog
  %load = load <3 x i32>, <3 x i32> addrspace(4)* %ptr, align 1
  ret <3 x i32> %load
}

define amdgpu_ps <3 x i32> @s_load_constant_v3i32_align2(<3 x i32> addrspace(4)* inreg %ptr) {
; GFX9-UNALIGNED-LABEL: s_load_constant_v3i32_align2:
; GFX9-UNALIGNED:       ; %bb.0:
; GFX9-UNALIGNED-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-UNALIGNED-NEXT:    v_mov_b32_e32 v1, s1
; GFX9-UNALIGNED-NEXT:    global_load_dwordx3 v[0:2], v[0:1], off
; GFX9-UNALIGNED-NEXT:    s_waitcnt vmcnt(0)
; GFX9-UNALIGNED-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-UNALIGNED-NEXT:    v_readfirstlane_b32 s1, v1
; GFX9-UNALIGNED-NEXT:    v_readfirstlane_b32 s2, v2
; GFX9-UNALIGNED-NEXT:    ; return to shader part epilog
;
; GFX9-NOUNALIGNED-LABEL: s_load_constant_v3i32_align2:
; GFX9-NOUNALIGNED:       ; %bb.0:
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 2
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v2, s2
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v3, s3
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 4
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v5, s3
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v4, s2
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 6
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v7, s3
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v6, s2
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s2, s0, 8
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s3, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v0, s0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v1, s1
; GFX9-NOUNALIGNED-NEXT:	s_add_u32 s0, s0, 10
; GFX9-NOUNALIGNED-NEXT:	s_addc_u32 s1, s1, 0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v9, s3
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v11, s1
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v10, s0
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v8, s2
; GFX9-NOUNALIGNED-NEXT:	global_load_ushort v0, v[0:1], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ushort v1, v[2:3], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ushort v2, v[4:5], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ushort v3, v[6:7], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ushort v4, v[8:9], off
; GFX9-NOUNALIGNED-NEXT:	global_load_ushort v5, v[10:11], off
; GFX9-NOUNALIGNED-NEXT:	s_mov_b32 s0, 0xffff
; GFX9-NOUNALIGNED-NEXT:	v_mov_b32_e32 v6, 0xffff
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(4)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v1, s0, v1
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v1, 16, v1
; GFX9-NOUNALIGNED-NEXT:	v_and_or_b32 v0, v0, s0, v1
; GFX9-NOUNALIGNED-NEXT:	v_readfirstlane_b32 s0, v0
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(2)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v0, v3, v6
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v0, 16, v0
; GFX9-NOUNALIGNED-NEXT:	v_and_or_b32 v1, v2, v6, v0
; GFX9-NOUNALIGNED-NEXT:	s_waitcnt vmcnt(0)
; GFX9-NOUNALIGNED-NEXT:	v_and_b32_e32 v0, v5, v6
; GFX9-NOUNALIGNED-NEXT:	v_lshlrev_b32_e32 v0, 16, v0
; GFX9-NOUNALIGNED-NEXT:	v_and_or_b32 v2, v4, v6, v0
; GFX9-NOUNALIGNED-NEXT:	v_readfirstlane_b32 s1, v1
; GFX9-NOUNALIGNED-NEXT:	v_readfirstlane_b32 s2, v2
; GFX9-NOUNALIGNED-NEXT:	; return to shader part epilog
;
; GFX7-UNALIGNED-LABEL: s_load_constant_v3i32_align2:
; GFX7-UNALIGNED:       ; %bb.0:
; GFX7-UNALIGNED-NEXT:    s_load_dwordx2 s[6:7], s[0:1], 0x0
; GFX7-UNALIGNED-NEXT:    s_load_dword s0, s[0:1], 0x2
; GFX7-UNALIGNED-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v0, s6
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v2, s8
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v2, s0
; GFX7-UNALIGNED-NEXT:    v_mov_b32_e32 v1, s7
; GFX7-UNALIGNED-NEXT:    v_readfirstlane_b32 s0, v0
; GFX7-UNALIGNED-NEXT:    v_readfirstlane_b32 s1, v1
; GFX7-UNALIGNED-NEXT:    v_readfirstlane_b32 s2, v2
; GFX7-UNALIGNED-NEXT:    ; return to shader part epilog
;
; GFX7-NOUNALIGNED-LABEL: s_load_constant_v3i32_align2:
; GFX7-NOUNALIGNED:       ; %bb.0:
; GFX7-NOUNALIGNED-NEXT:        s_mov_b32 s2, -1
; GFX7-NOUNALIGNED-NEXT:        s_mov_b32 s3, 0xf000
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v0, off, s[0:3], 0
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v1, off, s[0:3], 0 offset:2
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v2, off, s[0:3], 0 offset:4
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v3, off, s[0:3], 0 offset:6
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v4, off, s[0:3], 0 offset:8
; GFX7-NOUNALIGNED-NEXT:        buffer_load_ushort v5, off, s[0:3], 0 offset:10
; GFX7-NOUNALIGNED-NEXT:        s_mov_b32 s0, 0xffff
; GFX7-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(5)
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v0, s0, v0
; GFX7-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(4)
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v1, s0, v1
; GFX7-NOUNALIGNED-NEXT:        v_lshlrev_b32_e32 v1, 16, v1
; GFX7-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(2)
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v3, s0, v3
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v2, s0, v2
; GFX7-NOUNALIGNED-NEXT:        s_waitcnt vmcnt(0)
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v5, s0, v5
; GFX7-NOUNALIGNED-NEXT:        v_and_b32_e32 v4, s0, v4
; GFX7-NOUNALIGNED-NEXT:        v_lshlrev_b32_e32 v3, 16, v3
; GFX7-NOUNALIGNED-NEXT:        v_lshlrev_b32_e32 v5, 16, v5
; GFX7-NOUNALIGNED-NEXT:        v_or_b32_e32 v0, v0, v1
; GFX7-NOUNALIGNED-NEXT:        v_or_b32_e32 v1, v2, v3
; GFX7-NOUNALIGNED-NEXT:        v_or_b32_e32 v2, v4, v5
; GFX7-NOUNALIGNED-NEXT:        v_readfirstlane_b32 s0, v0
; GFX7-NOUNALIGNED-NEXT:        v_readfirstlane_b32 s1, v1
; GFX7-NOUNALIGNED-NEXT:        v_readfirstlane_b32 s2, v2
; GFX7-NOUNALIGNED-NEXT:        ; return to shader part epilog
  %load = load <3 x i32>, <3 x i32> addrspace(4)* %ptr, align 2
  ret <3 x i32> %load
}

define amdgpu_ps <3 x i32> @s_load_constant_v3i32_align4(<3 x i32> addrspace(4)* inreg %ptr) {
; GFX9-LABEL: s_load_constant_v3i32_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s2, s0
; GFX9-NEXT:    s_mov_b32 s3, s1
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x8
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX7-LABEL: s_load_constant_v3i32_align4:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_mov_b32 s2, s0
; GFX7-NEXT:    s_mov_b32 s3, s1
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GFX7-NEXT:    s_load_dword s2, s[2:3], 0x2
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    ; return to shader part epilog
  %load = load <3 x i32>, <3 x i32> addrspace(4)* %ptr, align 4
  ret <3 x i32> %load
}

define amdgpu_ps i96 @s_load_constant_i96_align8(i96 addrspace(4)* inreg %ptr) {
; GFX9-LABEL: s_load_constant_i96_align8:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s2, s0
; GFX9-NEXT:    s_mov_b32 s3, s1
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x8
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX7-LABEL: s_load_constant_i96_align8:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_mov_b32 s2, s0
; GFX7-NEXT:    s_mov_b32 s3, s1
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GFX7-NEXT:    s_load_dword s2, s[2:3], 0x2
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    ; return to shader part epilog
  %load = load i96, i96 addrspace(4)* %ptr, align 8
  ret i96 %load
}

define amdgpu_ps <3 x i32> @s_load_constant_v3i32_align8(<3 x i32> addrspace(4)* inreg %ptr) {
; GFX9-LABEL: s_load_constant_v3i32_align8:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s2, s0
; GFX9-NEXT:    s_mov_b32 s3, s1
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x8
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX7-LABEL: s_load_constant_v3i32_align8:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_mov_b32 s2, s0
; GFX7-NEXT:    s_mov_b32 s3, s1
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GFX7-NEXT:    s_load_dword s2, s[2:3], 0x2
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    ; return to shader part epilog
  %load = load <3 x i32>, <3 x i32> addrspace(4)* %ptr, align 8
  ret <3 x i32> %load
}

define amdgpu_ps <3 x i32> @s_load_constant_v6i16_align8(<6 x i16> addrspace(4)* inreg %ptr) {
; GFX9-LABEL: s_load_constant_v6i16_align8:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s2, s0
; GFX9-NEXT:    s_mov_b32 s3, s1
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x8
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX7-LABEL: s_load_constant_v6i16_align8:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_mov_b32 s2, s0
; GFX7-NEXT:    s_mov_b32 s3, s1
; GFX7-NEXT:    s_load_dwordx2 s[0:1], s[2:3], 0x0
; GFX7-NEXT:    s_load_dword s2, s[2:3], 0x2
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    ; return to shader part epilog
  %load = load <6 x i16>, <6 x i16> addrspace(4)* %ptr, align 8
  %cast = bitcast <6 x i16> %load to <3 x i32>
  ret <3 x i32> %cast
}

define amdgpu_ps <12 x i8> @s_load_constant_v12i8_align8(<12 x i8> addrspace(4)* inreg %ptr) {
; GFX9-LABEL: s_load_constant_v12i8_align8:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx2 s[12:13], s[0:1], 0x0
; GFX9-NEXT:    s_load_dword s8, s[0:1], 0x8
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_lshr_b32 s1, s12, 8
; GFX9-NEXT:    s_lshr_b32 s2, s12, 16
; GFX9-NEXT:    s_lshr_b32 s3, s12, 24
; GFX9-NEXT:    s_lshr_b32 s5, s13, 8
; GFX9-NEXT:    s_lshr_b32 s6, s13, 16
; GFX9-NEXT:    s_lshr_b32 s7, s13, 24
; GFX9-NEXT:    s_lshr_b32 s9, s8, 8
; GFX9-NEXT:    s_lshr_b32 s10, s8, 16
; GFX9-NEXT:    s_lshr_b32 s11, s8, 24
; GFX9-NEXT:    s_mov_b32 s0, s12
; GFX9-NEXT:    s_mov_b32 s4, s13
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX7-LABEL: s_load_constant_v12i8_align8:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx2 s[12:13], s[0:1], 0x0
; GFX7-NEXT:    s_load_dword s8, s[0:1], 0x2
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_lshr_b32 s1, s12, 8
; GFX7-NEXT:    s_lshr_b32 s2, s12, 16
; GFX7-NEXT:    s_lshr_b32 s3, s12, 24
; GFX7-NEXT:    s_lshr_b32 s5, s13, 8
; GFX7-NEXT:    s_lshr_b32 s6, s13, 16
; GFX7-NEXT:    s_lshr_b32 s7, s13, 24
; GFX7-NEXT:    s_lshr_b32 s9, s8, 8
; GFX7-NEXT:    s_lshr_b32 s10, s8, 16
; GFX7-NEXT:    s_lshr_b32 s11, s8, 24
; GFX7-NEXT:    s_mov_b32 s0, s12
; GFX7-NEXT:    s_mov_b32 s4, s13
; GFX7-NEXT:    ; return to shader part epilog
  %load = load <12 x i8>, <12 x i8> addrspace(4)* %ptr, align 8
  ret <12 x i8> %load
}

define amdgpu_ps <3 x i32> @s_load_constant_v3i32_align16(<3 x i32> addrspace(4)* inreg %ptr) {
; GCN-LABEL: s_load_constant_v3i32_align16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ; return to shader part epilog
  %load = load <3 x i32>, <3 x i32> addrspace(4)* %ptr, align 16
  ret <3 x i32> %load
}
