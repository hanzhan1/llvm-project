; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s

declare void @notdead(i8*)
declare i8* @llvm.frameaddress(i32)
declare i8* @llvm.returnaddress(i32)

define i8* @test_frameaddress_0() nounwind {
; RV32I-LABEL: test_frameaddress_0:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_frameaddress_0:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 16
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call i8* @llvm.frameaddress(i32 0)
  ret i8* %1
}

define i8* @test_frameaddress_2() nounwind {
; RV32I-LABEL: test_frameaddress_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    lw a0, -8(s0)
; RV32I-NEXT:    lw a0, -8(a0)
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_frameaddress_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 16
; RV64I-NEXT:    ld a0, -16(s0)
; RV64I-NEXT:    ld a0, -16(a0)
; RV64I-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call i8* @llvm.frameaddress(i32 2)
  ret i8* %1
}

define i8* @test_frameaddress_3_alloca() nounwind {
; RV32I-LABEL: test_frameaddress_3_alloca:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -112
; RV32I-NEXT:    sw ra, 108(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 104(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 112
; RV32I-NEXT:    addi a0, s0, -108
; RV32I-NEXT:    call notdead@plt
; RV32I-NEXT:    lw a0, -8(s0)
; RV32I-NEXT:    lw a0, -8(a0)
; RV32I-NEXT:    lw a0, -8(a0)
; RV32I-NEXT:    lw s0, 104(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 108(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 112
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_frameaddress_3_alloca:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -128
; RV64I-NEXT:    sd ra, 120(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 112(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 128
; RV64I-NEXT:    addi a0, s0, -116
; RV64I-NEXT:    call notdead@plt
; RV64I-NEXT:    ld a0, -16(s0)
; RV64I-NEXT:    ld a0, -16(a0)
; RV64I-NEXT:    ld a0, -16(a0)
; RV64I-NEXT:    ld s0, 112(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 120(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 128
; RV64I-NEXT:    ret
  %1 = alloca [100 x i8]
  %2 = bitcast [100 x i8]* %1 to i8*
  call void @notdead(i8* %2)
  %3 = call i8* @llvm.frameaddress(i32 3)
  ret i8* %3
}

define i8* @test_returnaddress_0() nounwind {
; RV32I-LABEL: test_returnaddress_0:
; RV32I:       # %bb.0:
; RV32I-NEXT:    mv a0, ra
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_returnaddress_0:
; RV64I:       # %bb.0:
; RV64I-NEXT:    mv a0, ra
; RV64I-NEXT:    ret
  %1 = call i8* @llvm.returnaddress(i32 0)
  ret i8* %1
}

define i8* @test_returnaddress_2() nounwind {
; RV32I-LABEL: test_returnaddress_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    lw a0, -8(s0)
; RV32I-NEXT:    lw a0, -8(a0)
; RV32I-NEXT:    lw a0, -4(a0)
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: test_returnaddress_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi s0, sp, 16
; RV64I-NEXT:    ld a0, -16(s0)
; RV64I-NEXT:    ld a0, -16(a0)
; RV64I-NEXT:    ld a0, -8(a0)
; RV64I-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call i8* @llvm.returnaddress(i32 2)
  ret i8* %1
}
