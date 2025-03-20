; *******************************************************************************************
; *******************************************************************************************
;
;       Name :      add.asm
;       Purpose :   Addition/Subtraction
;       Date :      20th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;                         Subtract iFloat FPB from iFloat FPA
;
; *******************************************************************************************

FloatSubtract:
        pha                                 ; toggle the sign of FPB and add
        lda     floatBFlags                      
        eor     #$80
        sta     floatBFlags
        pla

; *******************************************************************************************
;
;                       Add iFloat FPB to iFloat FPA (also used for subtract)
;
; *******************************************************************************************

FloatAdd:
        pha                                 ; save registers
        phx
        phy

        lda     floatAExponent              ; check if both integer
        ora     floatBExponent
        beq     _FAInteger                  ; if so, don't need to normalise
        ;
        ;       Check zero.
        ;
        FloatTest32B                        ; check if FPB = 0
        beq     _FAExit                     ; if so, just return FPA.
        FloatTest32A                        ; check if FPA = 0
        bne     _FAFloatingPoint            ; if not, then do FP addition.
        FloatCopy32BA                       ; copy FPB to FPA
        bra     _FAExit                     ; and exit
        ;
        ;       Floating point add/subtract
        ;
_FAFloatingPoint:
        jsr     FloatNormaliseA             ; normalise FPA & FPB                   
        jsr     FloatNormaliseB                     
        ;
        ;       Work out the common exponent for the arithmetic.
        ;
        lda     floatAExponent              ; calculate the higher exponent, to X
        tax
        sec
        sbc     floatBExponent              ; signed comparison
        bvc     +
        eor     #$80
+       bpl     +
        ldx     floatBExponent              ; get the lower value.
+       
        ;
        ;       Shift both mantissa/exponent to match X in FPA
        ;
-       cpx     floatAExponent              ; reached required exponent (FPA)
        beq     +
        phx
        FloatShr32A                         ; shift right and adjust exponent, preserving the target
        plx
        inc     floatAExponent
        bra     -
+           
        ;
        ;       Shift both mantissa/exponent to match X in B
        ;
-       cpx     floatBExponent              ; reached required exponent (FPB)
        beq     +
        phx
        FloatShr32B                         ; shift right and adjust exponent, preserving the target
        plx
        inc     floatBExponent
        bra     -
+                               
        ;
        ;       Now do the mantissa add/subtract and adjustment, figure out which first.
        ;                   
_FAInteger:
        lda     floatAFlags                 ; are they different sign flags
        eor     floatBFlags                 ; e.g. the signs are different, it's a subtraction
        bmi     _FASubtraction
_FAAddition:
        ;
        ;       Integer arithmetic : Addition
        ;
        FloatAdd32AB                        ; add FPB to FPA - sign of result is inherited.
        bpl     _FAExit                     ; no overflow, bit 31 of mantissa clear.
        FloatShr32A                         ; fix up the mantissa
        inc     floatAExponent              ; bump the exponent
        bra     _FAExit                     ; and quit.
        ;
        ;       Integer arithmetic : Subtraction
        ;   
_FASubtraction:
        FloatSub32AB                        ; subtract FPB from FPA
        bpl     _FAExit                     ; no underflow, then exit.
        FloatNeg32A                         ; negate FPA mantissa 
        lda     floatAFlags                 ; toggle the sign flag
        eor     #$80
        sta     floatAFlags
        bra     _FAExit
        ;
        ;       Exit, with check for minus zero
        ;
_FAExit:
        jsr     FloatCheckMinusZero
        ply                                 ; restore registers
        plx
        pla
        rts

; *******************************************************************************************
;
;           Test FPA for minus zero as we have a sign and magnitude system
;
; *******************************************************************************************

FloatCheckMinusZero:
        lda     floatAFlags                 ; slight increase as mostly +ve
        bpl     _FCMZExit
        FloatTest32A                        ; if a zero mantissa
        bne     _FCMZExit
        lda     floatAFlags                 ; clear the sign bit
        and     #$7F
        sta     floatAFlags
_FCMZExit:              
        rts     

; *******************************************************************************************
;
;                                   Normalise FPA & FPB
;
; *******************************************************************************************

FloatNormaliseA:
        FloatTest32A                        ; check FPA zero
        beq     _NAExit     
-
        lda     floatAMantissa+3            ; check normalised
        and     #$40
        bne     _NAExit     
        FloatShl32A
        dec     floatAExponent
        bra     -
_NAExit:
        rts             
        
FloatNormaliseB:
        FloatTest32B                        ; check FPB zero
        beq     _NBExit
-
        lda     floatBMantissa+3            ; check normalised
        and     #$40
        bne     _NBExit     
        FloatShl32B
        dec     floatBExponent
        bra     -
_NBExit:
        rts             

