; *******************************************************************************************
; *******************************************************************************************
;
;       Name :      fp_utility_6502.asm
;       Purpose :   Utility routines and/or macros, 6502 version.
;       Date :      20th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; -------------------------------------------------------------------------------------------
;
;                                       Clear A to zero
;
; -------------------------------------------------------------------------------------------

FloatClr32A6502:
        stz     floatAMantissa+0
        bra     FloatClr32A6502Continue

; -------------------------------------------------------------------------------------------
;
;                                   Set A to 32 bit integer in A
;
; -------------------------------------------------------------------------------------------

FloatSet32A6502:
        sta     floatAMantissa+0
FloatClr32A6502Continue:    
        stz     floatAFlags
        stz     floatAExponent
        stz     floatAMantissa+1
        stz     floatAMantissa+2
        stz     floatAMantissa+3
        rts

; -------------------------------------------------------------------------------------------
;
;                                   Set B to 32 bit integer in A
;
; -------------------------------------------------------------------------------------------

FloatSet32B6502:
        sta     floatBMantissa+0
        stz     floatBFlags
        stz     floatBExponent
        stz     floatBMantissa+1
        stz     floatBMantissa+2
        stz     floatBMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                           Copy B to A as 32 bit integer
;
; -------------------------------------------------------------------------------------------

FloatCopy32BA6502:
        FloatCopyReg floatB,floatA
        rts

; -------------------------------------------------------------------------------------------
;
;                           Copy A to R as 32 bit integer
;
; -------------------------------------------------------------------------------------------

FloatCopy32AR6502:
        FloatCopyReg floatA,floatR
        rts

; -------------------------------------------------------------------------------------------
;
;                           Copy R to A as 32 bit integer
;
; -------------------------------------------------------------------------------------------

FloatCopy32RA6502:
        FloatCopyReg floatR,floatA
        rts
    
; -------------------------------------------------------------------------------------------
;
;                       Add B to A as 32 bit integer, sets N and C 
;
; -------------------------------------------------------------------------------------------
FloatAdd32AB6502:
        clc 
        lda     floatAMantissa+0
        adc     floatBMantissa+0
        sta     floatAMantissa+0
        lda     floatAMantissa+1
        adc     floatBMantissa+1
        sta     floatAMantissa+1
        lda     floatAMantissa+2
        adc     floatBMantissa+2
        sta     floatAMantissa+2
        lda     floatAMantissa+3
        adc     floatBMantissa+3
        sta     floatAMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                       Subtract B from A as 32 bit integer, sets N and C 
;
; -------------------------------------------------------------------------------------------
FloatSub32AB6502:
        sec 
        lda     floatAMantissa+0
        sbc     floatBMantissa+0
        sta     floatAMantissa+0
        lda     floatAMantissa+1
        sbc     floatBMantissa+1
        sta     floatAMantissa+1
        lda     floatAMantissa+2
        sbc     floatBMantissa+2
        sta     floatAMantissa+2
        lda     floatAMantissa+3
        sbc     floatBMantissa+3
        sta     floatAMantissa+3
        rts 
; -------------------------------------------------------------------------------------------
;
;                                   Shift A right 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
FloatShr32A6502:
        lsr     floatAMantissa+3
        ror     floatAMantissa+2
        ror     floatAMantissa+1
        ror     floatAMantissa+0
        rts
; -------------------------------------------------------------------------------------------
;
;                                   Shift B right 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
FloatShr32B6502:
        lsr     floatBMantissa+3
        ror     floatBMantissa+2
        ror     floatBMantissa+1
        ror     floatBMantissa+0
        rts
; -------------------------------------------------------------------------------------------
;
;                                   Shift R right 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
FloatShr32R6502:
        lsr     floatRMantissa+3
        ror     floatRMantissa+2
        ror     floatRMantissa+1
        ror     floatRMantissa+0
        rts
; -------------------------------------------------------------------------------------------
;
;                               Negate A mantissa as 32 bit int
;
; -------------------------------------------------------------------------------------------
FloatNeg32A6502:
        sec
        lda     #0
        sbc     floatAMantissa+0
        sta     floatAMantissa+0
        lda     #0
        sbc     floatAMantissa+1
        sta     floatAMantissa+1
        lda     #0
        sbc     floatAMantissa+2
        sta     floatAMantissa+2
        lda     #0
        sbc     floatAMantissa+3
        sta     floatAMantissa+3
        rts

; -------------------------------------------------------------------------------------------
;
;                               Shift A left 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
FloatShl32A6502:
        asl     floatAMantissa+0
        rol     floatAMantissa+1
        rol     floatAMantissa+2
        rol     floatAMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                               Shift B left 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
FloatShl32B6502:
        asl     floatBMantissa+0
        rol     floatBMantissa+1
        rol     floatBMantissa+2
        rol     floatBMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                                   Check if A is zero
;
; -------------------------------------------------------------------------------------------
FloatTest32A6502:
        lda     floatAMantissa+0
        ora     floatAMantissa+1
        ora     floatAMantissa+2
        ora     floatAMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                                   Check if B is zero
;
; -------------------------------------------------------------------------------------------
FloatTest32B6502:
        lda     floatBMantissa+0
        ora     floatBMantissa+1
        ora     floatBMantissa+2
        ora     floatBMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                                   Check if R is zero
;
; -------------------------------------------------------------------------------------------
FloatTest32R6502:
        lda     floatRMantissa+0
        ora     floatRMantissa+1
        ora     floatRMantissa+2
        ora     floatRMantissa+3
        rts

; -------------------------------------------------------------------------------------------
;
;                                   Push A on the stack
;
; -------------------------------------------------------------------------------------------
FloatPush32A6502:
        ldy     floatStackPointer
        ldx     #5
_FPLoop:lda     floatA,x
        sta     floatStack,y
        iny
        dex
        bpl     _FPLoop
        sty     floatStackPointer        

        rts

; -------------------------------------------------------------------------------------------
;
;                                   Pop B off the stack
;
; -------------------------------------------------------------------------------------------

FloatPop32B6502:
        ldy     floatStackPointer
        ldx     #0
_FPLoop:dey
        lda     floatStack,y
        sta     floatB,x
        inx
        cpx     #6
        bne     _FPLoop        
        sty     floatStackPointer        
        rts

