; *******************************************************************************************
; *******************************************************************************************
;
;       Name :      integer.asm
;       Purpose :   Integer part of a number
;       Date :      20th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;                           Get integer part of FPA
;
; *******************************************************************************************

FloatInteger:
        pha                                 ; save registers
        phx
        phy

        lda     floatAExponent                   ; exponent >= 0, then already integer
        bpl     _FIExit
        Test32A                             ; zero, then integer
        beq     _FIExit
        jsr     FloatNormaliseA             ; Normalise FPA
_FIConvert:     
        lda     floatAExponent                   ; exponent sill negative ?
        bpl     _FIExit
        Shr32A                          ; keep shifting right until exponent = 0
        inc     floatAExponent
        bra     _FIConvert
_FIExit:
        jsr     FloatCheckMinusZero         ; -0 check required here.
        ply                                 ; restore registers
        plx
        pla
        rts             

