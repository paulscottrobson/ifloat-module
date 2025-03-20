; *******************************************************************************************
; *******************************************************************************************
;
;       Name :      arctangent.asm
;       Purpose :   ArcTangent evaluation
;       Date :      20th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;                 ArcTangent calculation of FPA (in Radians). Return CS on error
;
; *******************************************************************************************

PolyArcTangent:
        pha
        phx
        phy
        jsr     FloatNormaliseA             ; normalise A so we can compare >= 1

        lda     floatAFlags                 ; save the current sign of FPA 
        sta     polySign                    
        stz     floatAFlags                 ; take absolute value of A

        ;
        ;       if FPA >= 1.0, take reciprocal of FPA
        ;
        stz     polyFlag                    ; clear the adjust flag.
        lda     floatAExponent              ; is the exponent >= $E2 , this means >= 1
        bpl     _PATAdjust                  ; definitely > 1 :)
        cmp     #$E2                        ; $E2..$FF are also > 1
        bcc     _PATNotAdjust
_PATAdjust:     
        FloatPush32A                        ; copy FPA to FPB
        FloatPop32B
        lda     #1                          ; FPA = 1, FPB = x
        FloatSet32A
        jsr     FloatDivide                 ; take reciprocal
        inc     polyFlag                    ; set the adjust flag
_PATNotAdjust:      
        ;
        ;       Save FPA for end multiply 
        ;
        FloatPush32A                        ; save FPA
        ;
        ;       Calculate FPA^2
        ;
        FloatPush32A                        ; square FPA - copy to FPB (slowly) and multiply
        FloatPop32B
        jsr     FloatMultiply               
        ;
        ;       Apply the polynomial and multiply by the saved value.
        ;
        ldx     #PolynomialArctanData-PolynomialData
        jsr     PolyEvaluate
        FloatPop32B                         ; now multiply by the original value
        jsr     FloatMultiply               
        ;
        ;       If adjusted subtract result from Pi/2
        ;
        lda     polyFlag
        beq     _PATNoFixup

        lda     floatAFlags                 ; FPA = -FPA
        eor     #$80
        sta     floatAFlags
        PolyConstantToB FLoatConst_PiDiv2   ; FPB = Pi/2
        jsr     FloatAdd
_PATNoFixup:        
        ;
        ;       Restore sign
        ;
        lda     polySign                    ; restore the original sign
        sta     floatAFlags

        ply
        plx
        pla
        rts

