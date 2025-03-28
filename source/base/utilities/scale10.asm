; *******************************************************************************************
; *******************************************************************************************
;
;       Name :      scale10.asm
;       Purpose :   Divide A by 10^A
;       Date :      20th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;                                       Divide FPA by 10^Y
;
; *******************************************************************************************

FloatScale10:
        pha
        phx
        phy

        tya                                 ; get divider
        cmp     #16                         ; divider >= 16
        bcs     _FSCZero                    ; return zero.

        sta     floatBMantissa              ; temporary store, we want to x 3
        asl                                 ; x 2
        adc     floatBMantissa              ; x 3
        asl                                 ; x 6
        tax
        ldy     #0                          ; index into FPB
_FSCCopy:
        lda     FloatScalarTable,x          ; copy it
        sta     floatBFlags,y
        inx
        iny
        cpy     #6                          ; copied 6 bytes of float data
        bne     _FSCCopy
        jsr     FloatMultiply               ; the scalars are 1, 0.1 etc.
        bra     _FSCExit

_FSCZero:
        FloatClear32A                       ; set the FPA register to zero.
_FSCExit:       
        ply                                 ; restore registers
        plx
        pla
        clc
        rts             

