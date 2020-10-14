; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=hexagon < %s | FileCheck %s

; Splat immediate, 8-bit, v60
define <128 x i8> @f0() #0 {
; CHECK-LABEL: f0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = ##2139062143
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <128 x i8> undef, i8 127, i32 0
  %v1 = shufflevector <128 x i8> %v0, <128 x i8> undef, <128 x i32> zeroinitializer
  ret <128 x i8> %v1
}

; Splat immediate, 16 bit, v60
define <64 x i16> @f1() #0 {
; CHECK-LABEL: f1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = ##-1437226411
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <64 x i16> undef, i16 43605, i32 0
  %v1 = shufflevector <64 x i16> %v0, <64 x i16> undef, <64 x i32> zeroinitializer
  ret <64 x i16> %v1
}

; Splat immediate, 32 bit, v60
define <32 x i32> @f2() #0 {
; CHECK-LABEL: f2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = ##134744072
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <32 x i32> undef, i32 134744072, i32 0
  %v1 = shufflevector <32 x i32> %v0, <32 x i32> undef, <32 x i32> zeroinitializer
  ret <32 x i32> %v1
}

; Splat immediate, 8-bit, v62+
define <128 x i8> @f3() #1 {
; CHECK-LABEL: f3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #127
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.b = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <128 x i8> undef, i8 127, i32 0
  %v1 = shufflevector <128 x i8> %v0, <128 x i8> undef, <128 x i32> zeroinitializer
  ret <128 x i8> %v1
}

; Splat immediate, 16 bit, v62+
define <64 x i16> @f4() #1 {
; CHECK-LABEL: f4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-21931
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.h = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <64 x i16> undef, i16 43605, i32 0
  %v1 = shufflevector <64 x i16> %v0, <64 x i16> undef, <64 x i32> zeroinitializer
  ret <64 x i16> %v1
}

; Splat immediate, 32 bit, v62+
define <32 x i32> @f5() #1 {
; CHECK-LABEL: f5:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = ##134744072
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <32 x i32> undef, i32 134744072, i32 0
  %v1 = shufflevector <32 x i32> %v0, <32 x i32> undef, <32 x i32> zeroinitializer
  ret <32 x i32> %v1
}

; Splat register, 8-bit, v60
define <128 x i8> @f6(i8 %a0) #0 {
; CHECK-LABEL: f6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = vsplatb(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <128 x i8> undef, i8 %a0, i32 0
  %v1 = shufflevector <128 x i8> %v0, <128 x i8> undef, <128 x i32> zeroinitializer
  ret <128 x i8> %v1
}

; Splat register, 16 bit, v60
define <64 x i16> @f7(i16 %a0) #0 {
; CHECK-LABEL: f7:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = combine(r0.l,r0.l)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <64 x i16> undef, i16 %a0, i32 0
  %v1 = shufflevector <64 x i16> %v0, <64 x i16> undef, <64 x i32> zeroinitializer
  ret <64 x i16> %v1
}

; Splat register, 32 bit, v60
define <32 x i32> @f8(i32 %a0) #0 {
; CHECK-LABEL: f8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <32 x i32> undef, i32 %a0, i32 0
  %v1 = shufflevector <32 x i32> %v0, <32 x i32> undef, <32 x i32> zeroinitializer
  ret <32 x i32> %v1
}

; Splat register, 8-bit, v62+
define <128 x i8> @f9(i8 %a0) #1 {
; CHECK-LABEL: f9:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.b = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <128 x i8> undef, i8 %a0, i32 0
  %v1 = shufflevector <128 x i8> %v0, <128 x i8> undef, <128 x i32> zeroinitializer
  ret <128 x i8> %v1
}

; Splat register, 16 bit, v62+
define <64 x i16> @f10(i16 %a0) #1 {
; CHECK-LABEL: f10:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0.h = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <64 x i16> undef, i16 %a0, i32 0
  %v1 = shufflevector <64 x i16> %v0, <64 x i16> undef, <64 x i32> zeroinitializer
  ret <64 x i16> %v1
}

; Splat register, 32 bit, v62+
define <32 x i32> @f11(i32 %a0) #1 {
; CHECK-LABEL: f11:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = vsplat(r0)
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <32 x i32> undef, i32 %a0, i32 0
  %v1 = shufflevector <32 x i32> %v0, <32 x i32> undef, <32 x i32> zeroinitializer
  ret <32 x i32> %v1
}

; Splat immediate, 8-bit, v60, pair
define <256 x i8> @f12() #0 {
; CHECK-LABEL: f12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = ##2139062143
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1 = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <256 x i8> undef, i8 127, i32 0
  %v1 = shufflevector <256 x i8> %v0, <256 x i8> undef, <256 x i32> zeroinitializer
  ret <256 x i8> %v1
}

; Splat immediate, 16 bit, v60, pair
define <128 x i16> @f13() #0 {
; CHECK-LABEL: f13:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = ##-1437226411
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1 = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <128 x i16> undef, i16 43605, i32 0
  %v1 = shufflevector <128 x i16> %v0, <128 x i16> undef, <128 x i32> zeroinitializer
  ret <128 x i16> %v1
}

; Splat immediate, 32 bit, v60, pair
define <64 x i32> @f14() #0 {
; CHECK-LABEL: f14:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = ##134744072
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1 = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <64 x i32> undef, i32 134744072, i32 0
  %v1 = shufflevector <64 x i32> %v0, <64 x i32> undef, <64 x i32> zeroinitializer
  ret <64 x i32> %v1
}

; Splat immediate, 8-bit, v62+, pair
define <256 x i8> @f15() #1 {
; CHECK-LABEL: f15:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #127
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1.b = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <256 x i8> undef, i8 127, i32 0
  %v1 = shufflevector <256 x i8> %v0, <256 x i8> undef, <256 x i32> zeroinitializer
  ret <256 x i8> %v1
}

; Splat immediate, 16 bit, v62+, pair
define <128 x i16> @f16() #1 {
; CHECK-LABEL: f16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = #-21931
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1.h = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <128 x i16> undef, i16 43605, i32 0
  %v1 = shufflevector <128 x i16> %v0, <128 x i16> undef, <128 x i32> zeroinitializer
  ret <128 x i16> %v1
}

; Splat immediate, 32 bit, v62+, pair
define <64 x i32> @f17() #1 {
; CHECK-LABEL: f17:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = ##134744072
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1 = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <64 x i32> undef, i32 134744072, i32 0
  %v1 = shufflevector <64 x i32> %v0, <64 x i32> undef, <64 x i32> zeroinitializer
  ret <64 x i32> %v1
}

; Splat register, 8-bit, v60, pair
define <256 x i8> @f18(i8 %a0) #0 {
; CHECK-LABEL: f18:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = vsplatb(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1 = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <256 x i8> undef, i8 %a0, i32 0
  %v1 = shufflevector <256 x i8> %v0, <256 x i8> undef, <256 x i32> zeroinitializer
  ret <256 x i8> %v1
}

; Splat register, 16 bit, v60, pair
define <128 x i16> @f19(i16 %a0) #0 {
; CHECK-LABEL: f19:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     r0 = combine(r0.l,r0.l)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v1 = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <128 x i16> undef, i16 %a0, i32 0
  %v1 = shufflevector <128 x i16> %v0, <128 x i16> undef, <128 x i32> zeroinitializer
  ret <128 x i16> %v1
}

; Splat register, 32 bit, v60, pair
define <64 x i32> @f20(i32 %a0) #0 {
; CHECK-LABEL: f20:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v1 = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <64 x i32> undef, i32 %a0, i32 0
  %v1 = shufflevector <64 x i32> %v0, <64 x i32> undef, <64 x i32> zeroinitializer
  ret <64 x i32> %v1
}

; Splat register, 8-bit, v62+, pair
define <256 x i8> @f21(i8 %a0) #1 {
; CHECK-LABEL: f21:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v1.b = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <256 x i8> undef, i8 %a0, i32 0
  %v1 = shufflevector <256 x i8> %v0, <256 x i8> undef, <256 x i32> zeroinitializer
  ret <256 x i8> %v1
}

; Splat register, 16 bit, v62+, pair
define <128 x i16> @f22(i16 %a0) #1 {
; CHECK-LABEL: f22:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v1.h = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <128 x i16> undef, i16 %a0, i32 0
  %v1 = shufflevector <128 x i16> %v0, <128 x i16> undef, <128 x i32> zeroinitializer
  ret <128 x i16> %v1
}

; Splat register, 32 bit, v62+, pair
define <64 x i32> @f23(i32 %a0) #1 {
; CHECK-LABEL: f23:
; CHECK:       // %bb.0:
; CHECK-NEXT:    {
; CHECK-NEXT:     v1 = vsplat(r0)
; CHECK-NEXT:    }
; CHECK-NEXT:    {
; CHECK-NEXT:     v0 = v1
; CHECK-NEXT:     jumpr r31
; CHECK-NEXT:    }
  %v0 = insertelement <64 x i32> undef, i32 %a0, i32 0
  %v1 = shufflevector <64 x i32> %v0, <64 x i32> undef, <64 x i32> zeroinitializer
  ret <64 x i32> %v1
}

attributes #0 = { nounwind readnone "target-cpu"="hexagonv60" "target-features"="+hvxv60,+hvx-length128b" }
attributes #1 = { nounwind readnone "target-cpu"="hexagonv62" "target-features"="+hvxv62,+hvx-length128b" }
