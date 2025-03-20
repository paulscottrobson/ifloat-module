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
        stz     aMantissa+0
        bra     FloatClr32A6502Continue

; -------------------------------------------------------------------------------------------
;
;                                   Set A to 32 bit integer in A
;
; -------------------------------------------------------------------------------------------

FloatSet32A6502:
        sta     aMantissa+0
FloatClr32A6502Continue:    
        stz     aFlags
        stz     aExponent
        stz     aMantissa+1
        stz     aMantissa+2
        stz     aMantissa+3
        rts

; -------------------------------------------------------------------------------------------
;
;                                   Set B to 32 bit integer in A
;
; -------------------------------------------------------------------------------------------

FloatSet32B6502:
        sta     bMantissa+0
        stz     bFlags
        stz     bExponent
        stz     bMantissa+1
        stz     bMantissa+2
        stz     bMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                           Copy B to A as 32 bit integer
;
; -------------------------------------------------------------------------------------------

FloatCopy32BA6502:
        copyreg bFlags,aFlags
        rts

; -------------------------------------------------------------------------------------------
;
;                           Copy A to R as 32 bit integer
;
; -------------------------------------------------------------------------------------------

FloatCopy32AR6502:
        copyreg aFlags,rFlags
        rts

; -------------------------------------------------------------------------------------------
;
;                           Copy R to A as 32 bit integer
;
; -------------------------------------------------------------------------------------------

FloatCopy32RA6502:
        copyreg rFlags,aFlags
        rts
    
; -------------------------------------------------------------------------------------------
;
;                       Add B to A as 32 bit integer, sets N and C 
;
; -------------------------------------------------------------------------------------------
FloatAdd32AB6502:
        clc 
        lda     aMantissa+0
        adc     bMantissa+0
        sta     aMantissa+0
        lda     aMantissa+1
        adc     bMantissa+1
        sta     aMantissa+1
        lda     aMantissa+2
        adc     bMantissa+2
        sta     aMantissa+2
        lda     aMantissa+3
        adc     bMantissa+3
        sta     aMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                       Subtract B from A as 32 bit integer, sets N and C 
;
; -------------------------------------------------------------------------------------------
FloatSub32AB6502:
        sec 
        lda     aMantissa+0
        sbc     bMantissa+0
        sta     aMantissa+0
        lda     aMantissa+1
        sbc     bMantissa+1
        sta     aMantissa+1
        lda     aMantissa+2
        sbc     bMantissa+2
        sta     aMantissa+2
        lda     aMantissa+3
        sbc     bMantissa+3
        sta     aMantissa+3
        rts 
; -------------------------------------------------------------------------------------------
;
;                                   Shift A right 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
FloatShr32A6502:
        lsr     aMantissa+3
        ror     aMantissa+2
        ror     aMantissa+1
        ror     aMantissa+0
        rts
; -------------------------------------------------------------------------------------------
;
;                                   Shift B right 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
FloatShr32B6502:
        lsr     bMantissa+3
        ror     bMantissa+2
        ror     bMantissa+1
        ror     bMantissa+0
        rts
; -------------------------------------------------------------------------------------------
;
;                                   Shift R right 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
FloatShr32R6502:
        lsr     rMantissa+3
        ror     rMantissa+2
        ror     rMantissa+1
        ror     rMantissa+0
        rts
; -------------------------------------------------------------------------------------------
;
;                               Negate A mantissa as 32 bit int
;
; -------------------------------------------------------------------------------------------
FloatNeg32A6502:
        sec
        lda     #0
        sbc     aMantissa+0
        sta     aMantissa+0
        lda     #0
        sbc     aMantissa+1
        sta     aMantissa+1
        lda     #0
        sbc     aMantissa+2
        sta     aMantissa+2
        lda     #0
        sbc     aMantissa+3
        sta     aMantissa+3
        rts

; -------------------------------------------------------------------------------------------
;
;                               Shift A left 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
FloatShl32A6502:
        asl     aMantissa+0
        rol     aMantissa+1
        rol     aMantissa+2
        rol     aMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                               Shift B left 1 bit, sets C
;
; -------------------------------------------------------------------------------------------
FloatShl32B6502:
        asl     bMantissa+0
        rol     bMantissa+1
        rol     bMantissa+2
        rol     bMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                                   Check if A is zero
;
; -------------------------------------------------------------------------------------------
FloatTest32A6502:
        lda     aMantissa+0
        ora     aMantissa+1
        ora     aMantissa+2
        ora     aMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                                   Check if B is zero
;
; -------------------------------------------------------------------------------------------
FloatTest32B6502:
        lda     bMantissa+0
        ora     bMantissa+1
        ora     bMantissa+2
        ora     bMantissa+3
        rts
; -------------------------------------------------------------------------------------------
;
;                                   Check if R is zero
;
; -------------------------------------------------------------------------------------------
FloatTest32R6502:
        lda     rMantissa+0
        ora     rMantissa+1
        ora     rMantissa+2
        ora     rMantissa+3
        rts

; -------------------------------------------------------------------------------------------
;
;                                   Push A on the stack
;
; -------------------------------------------------------------------------------------------
FloatPush32A6502:
        ldy     ftStackPointer
        ldx     #5
_FPLoop:lda     aFlags,x
        sta     ftStack,y
        iny
        dex
        bpl     _FPLoop
        sty     ftStackPointer        
        rts

; -------------------------------------------------------------------------------------------
;
;                                   Pop B off the stack
;
; -------------------------------------------------------------------------------------------

FloatPop32B6502:
        ldy     ftStackPointer
        ldx     #0
_FPLoop:dey
        lda     ftStack,y
        sta     bFlags,x
        inx
        cpx     #6
        bne     _FPLoop        
        sty     ftStackPointer        
        rts

