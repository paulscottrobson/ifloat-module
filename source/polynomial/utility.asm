; *******************************************************************************************
; *******************************************************************************************
;
;       Name :      utility.asm
;       Purpose :   Utility polynomial functions
;       Date :      20th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;           Evaluate polynomial at offset X from PolynomialData using value in FPA
;                                       (Horner's method)
;
; *******************************************************************************************

FloatEvaluatePoly:
        lda     PolynomialData,x            ; get the number to do
        inx                                 ; point to first number.
        sta     polyCoefficientCount        ; count of numbers

        ldy     #5                          ; copy poly x to workspace
_PECopy1:
        lda     floatAFlags,y
        sta     polyTempFloat,y
        dey 
        bpl     _PECopy1

        FloatClear32A                       ; set FPA to zero.

_PEEvaluateLoop:        
        ldy     #5                          ; copy X back to FPB
_PECopy2:
        lda     polyTempFloat,y
        sta     floatBFlags,y
        dey 
        bpl     _PECopy2
        jsr     FloatMultiply               ; and multiply into FPA

        ldy     #0                          ; copy the next coefficient into FPB
_PECopy3:
        lda     PolynomialData,x
        sta     floatBFlags,y
        inx     
        iny
        cpy     #6
        bne     _PECopy3

        jsr     FloatAdd                    ; and add into FPB

        dec     polyCoefficientCount        ; do for all coefficients
        bne     _PEEvaluateLoop

        rts

; *******************************************************************************************
;
;                       Load Floating Point value, address following to FPA/FPB.
;
; *******************************************************************************************

PolyConstantToA .macro
        lda     #\1-FloatConst_1Div2Pi
        jsr     PolyConstantToACode
        .endm

PolyConstantToB .macro
        lda     #\1-FloatConst_1Div2Pi
        jsr     PolyConstantToBCode
        .endm

PolyConstantToACode:
        phx
        phy
        tax
        ldy     #0
_PCACLoop:
        lda     FloatConst_1Div2Pi,x
        sta     floatAFlags,y
        inx
        iny
        cpy     #6
        bne     _PCACLoop
        ply
        plx
        rts

PolyConstantToBCode:
        phx
        phy
        tax
        ldy     #0
_PCACLoop:
        lda     FloatConst_1Div2Pi,x
        sta     floatBFlags,y
        inx
        iny
        cpy     #6
        bne     _PCACLoop
        ply
        plx
        rts

