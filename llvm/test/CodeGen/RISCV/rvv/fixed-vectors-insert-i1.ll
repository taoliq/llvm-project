; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK,RV64

define <1 x i1> @insertelt_v1i1(<1 x i1> %x, i1 %elt) nounwind {
; CHECK-LABEL: insertelt_v1i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 1, e8,mf8,ta,mu
; CHECK-NEXT:    vmv.v.i v25, 0
; CHECK-NEXT:    vmerge.vim v25, v25, 1, v0
; CHECK-NEXT:    vmv.s.x v25, a0
; CHECK-NEXT:    vand.vi v25, v25, 1
; CHECK-NEXT:    vmsne.vi v0, v25, 0
; CHECK-NEXT:    ret
  %y = insertelement <1 x i1> %x, i1 %elt, i64 0
  ret <1 x i1> %y
}

define <1 x i1> @insertelt_idx_v1i1(<1 x i1> %x, i1 %elt, i32 zeroext %idx) nounwind {
; RV32-LABEL: insertelt_idx_v1i1:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 1, e8,mf8,ta,mu
; RV32-NEXT:    vmv.s.x v25, a0
; RV32-NEXT:    vmv.v.i v26, 0
; RV32-NEXT:    vmerge.vim v26, v26, 1, v0
; RV32-NEXT:    addi a0, a1, 1
; RV32-NEXT:    vsetvli zero, a0, e8,mf8,tu,mu
; RV32-NEXT:    vslideup.vx v26, v25, a1
; RV32-NEXT:    vsetivli zero, 1, e8,mf8,ta,mu
; RV32-NEXT:    vand.vi v25, v26, 1
; RV32-NEXT:    vmsne.vi v0, v25, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_idx_v1i1:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 1, e8,mf8,ta,mu
; RV64-NEXT:    vmv.s.x v25, a0
; RV64-NEXT:    vmv.v.i v26, 0
; RV64-NEXT:    vmerge.vim v26, v26, 1, v0
; RV64-NEXT:    sext.w a0, a1
; RV64-NEXT:    addi a1, a0, 1
; RV64-NEXT:    vsetvli zero, a1, e8,mf8,tu,mu
; RV64-NEXT:    vslideup.vx v26, v25, a0
; RV64-NEXT:    vsetivli zero, 1, e8,mf8,ta,mu
; RV64-NEXT:    vand.vi v25, v26, 1
; RV64-NEXT:    vmsne.vi v0, v25, 0
; RV64-NEXT:    ret
  %y = insertelement <1 x i1> %x, i1 %elt, i32 %idx
  ret <1 x i1> %y
}

define <2 x i1> @insertelt_v2i1(<2 x i1> %x, i1 %elt) nounwind {
; CHECK-LABEL: insertelt_v2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8,mf8,ta,mu
; CHECK-NEXT:    vmv.s.x v25, a0
; CHECK-NEXT:    vmv.v.i v26, 0
; CHECK-NEXT:    vmerge.vim v26, v26, 1, v0
; CHECK-NEXT:    vsetivli zero, 2, e8,mf8,tu,mu
; CHECK-NEXT:    vslideup.vi v26, v25, 1
; CHECK-NEXT:    vsetivli zero, 2, e8,mf8,ta,mu
; CHECK-NEXT:    vand.vi v25, v26, 1
; CHECK-NEXT:    vmsne.vi v0, v25, 0
; CHECK-NEXT:    ret
  %y = insertelement <2 x i1> %x, i1 %elt, i64 1
  ret <2 x i1> %y
}

define <2 x i1> @insertelt_idx_v2i1(<2 x i1> %x, i1 %elt, i32 zeroext %idx) nounwind {
; RV32-LABEL: insertelt_idx_v2i1:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 2, e8,mf8,ta,mu
; RV32-NEXT:    vmv.s.x v25, a0
; RV32-NEXT:    vmv.v.i v26, 0
; RV32-NEXT:    vmerge.vim v26, v26, 1, v0
; RV32-NEXT:    addi a0, a1, 1
; RV32-NEXT:    vsetvli zero, a0, e8,mf8,tu,mu
; RV32-NEXT:    vslideup.vx v26, v25, a1
; RV32-NEXT:    vsetivli zero, 2, e8,mf8,ta,mu
; RV32-NEXT:    vand.vi v25, v26, 1
; RV32-NEXT:    vmsne.vi v0, v25, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_idx_v2i1:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e8,mf8,ta,mu
; RV64-NEXT:    vmv.s.x v25, a0
; RV64-NEXT:    vmv.v.i v26, 0
; RV64-NEXT:    vmerge.vim v26, v26, 1, v0
; RV64-NEXT:    sext.w a0, a1
; RV64-NEXT:    addi a1, a0, 1
; RV64-NEXT:    vsetvli zero, a1, e8,mf8,tu,mu
; RV64-NEXT:    vslideup.vx v26, v25, a0
; RV64-NEXT:    vsetivli zero, 2, e8,mf8,ta,mu
; RV64-NEXT:    vand.vi v25, v26, 1
; RV64-NEXT:    vmsne.vi v0, v25, 0
; RV64-NEXT:    ret
  %y = insertelement <2 x i1> %x, i1 %elt, i32 %idx
  ret <2 x i1> %y
}

define <8 x i1> @insertelt_v8i1(<8 x i1> %x, i1 %elt) nounwind {
; CHECK-LABEL: insertelt_v8i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8,mf2,ta,mu
; CHECK-NEXT:    vmv.s.x v25, a0
; CHECK-NEXT:    vmv.v.i v26, 0
; CHECK-NEXT:    vmerge.vim v26, v26, 1, v0
; CHECK-NEXT:    vsetivli zero, 2, e8,mf2,tu,mu
; CHECK-NEXT:    vslideup.vi v26, v25, 1
; CHECK-NEXT:    vsetivli zero, 8, e8,mf2,ta,mu
; CHECK-NEXT:    vand.vi v25, v26, 1
; CHECK-NEXT:    vmsne.vi v0, v25, 0
; CHECK-NEXT:    ret
  %y = insertelement <8 x i1> %x, i1 %elt, i64 1
  ret <8 x i1> %y
}

define <8 x i1> @insertelt_idx_v8i1(<8 x i1> %x, i1 %elt, i32 zeroext %idx) nounwind {
; RV32-LABEL: insertelt_idx_v8i1:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 8, e8,mf2,ta,mu
; RV32-NEXT:    vmv.s.x v25, a0
; RV32-NEXT:    vmv.v.i v26, 0
; RV32-NEXT:    vmerge.vim v26, v26, 1, v0
; RV32-NEXT:    addi a0, a1, 1
; RV32-NEXT:    vsetvli zero, a0, e8,mf2,tu,mu
; RV32-NEXT:    vslideup.vx v26, v25, a1
; RV32-NEXT:    vsetivli zero, 8, e8,mf2,ta,mu
; RV32-NEXT:    vand.vi v25, v26, 1
; RV32-NEXT:    vmsne.vi v0, v25, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_idx_v8i1:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 8, e8,mf2,ta,mu
; RV64-NEXT:    vmv.s.x v25, a0
; RV64-NEXT:    vmv.v.i v26, 0
; RV64-NEXT:    vmerge.vim v26, v26, 1, v0
; RV64-NEXT:    sext.w a0, a1
; RV64-NEXT:    addi a1, a0, 1
; RV64-NEXT:    vsetvli zero, a1, e8,mf2,tu,mu
; RV64-NEXT:    vslideup.vx v26, v25, a0
; RV64-NEXT:    vsetivli zero, 8, e8,mf2,ta,mu
; RV64-NEXT:    vand.vi v25, v26, 1
; RV64-NEXT:    vmsne.vi v0, v25, 0
; RV64-NEXT:    ret
  %y = insertelement <8 x i1> %x, i1 %elt, i32 %idx
  ret <8 x i1> %y
}

define <64 x i1> @insertelt_v64i1(<64 x i1> %x, i1 %elt) nounwind {
; CHECK-LABEL: insertelt_v64i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a1, zero, 64
; CHECK-NEXT:    vsetvli zero, a1, e8,m4,ta,mu
; CHECK-NEXT:    vmv.s.x v28, a0
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    vsetivli zero, 2, e8,m4,tu,mu
; CHECK-NEXT:    vslideup.vi v8, v28, 1
; CHECK-NEXT:    vsetvli zero, a1, e8,m4,ta,mu
; CHECK-NEXT:    vand.vi v28, v8, 1
; CHECK-NEXT:    vmsne.vi v0, v28, 0
; CHECK-NEXT:    ret
  %y = insertelement <64 x i1> %x, i1 %elt, i64 1
  ret <64 x i1> %y
}

define <64 x i1> @insertelt_idx_v64i1(<64 x i1> %x, i1 %elt, i32 zeroext %idx) nounwind {
; RV32-LABEL: insertelt_idx_v64i1:
; RV32:       # %bb.0:
; RV32-NEXT:    addi a2, zero, 64
; RV32-NEXT:    vsetvli zero, a2, e8,m4,ta,mu
; RV32-NEXT:    vmv.s.x v28, a0
; RV32-NEXT:    vmv.v.i v8, 0
; RV32-NEXT:    vmerge.vim v8, v8, 1, v0
; RV32-NEXT:    addi a0, a1, 1
; RV32-NEXT:    vsetvli zero, a0, e8,m4,tu,mu
; RV32-NEXT:    vslideup.vx v8, v28, a1
; RV32-NEXT:    vsetvli zero, a2, e8,m4,ta,mu
; RV32-NEXT:    vand.vi v28, v8, 1
; RV32-NEXT:    vmsne.vi v0, v28, 0
; RV32-NEXT:    ret
;
; RV64-LABEL: insertelt_idx_v64i1:
; RV64:       # %bb.0:
; RV64-NEXT:    addi a2, zero, 64
; RV64-NEXT:    vsetvli zero, a2, e8,m4,ta,mu
; RV64-NEXT:    vmv.s.x v28, a0
; RV64-NEXT:    vmv.v.i v8, 0
; RV64-NEXT:    vmerge.vim v8, v8, 1, v0
; RV64-NEXT:    sext.w a0, a1
; RV64-NEXT:    addi a1, a0, 1
; RV64-NEXT:    vsetvli zero, a1, e8,m4,tu,mu
; RV64-NEXT:    vslideup.vx v8, v28, a0
; RV64-NEXT:    vsetvli zero, a2, e8,m4,ta,mu
; RV64-NEXT:    vand.vi v28, v8, 1
; RV64-NEXT:    vmsne.vi v0, v28, 0
; RV64-NEXT:    ret
  %y = insertelement <64 x i1> %x, i1 %elt, i32 %idx
  ret <64 x i1> %y
}
