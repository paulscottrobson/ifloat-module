; *******************************************************************************************
; *******************************************************************************************
;
;       Name :      multiply.asm
;       Purpose :   Multiplication (int and float)
;       Date :      20th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************
    
; *******************************************************************************************
;
;                           Multiply iFloat FPA by iFloat FPB 
;
; *******************************************************************************************

FloatMultiply:
        pha                                 ; save registers
        phx
        phy
        ;
        ;       Check zero. Ax0 or 0xB => 0 always.
        ;
        FloatTest32A                        ; check if FPA = 0
        beq     _FMExit1                    ; if so, just return FPA
        FloatTest32B                        ; check if FPB = 0
        bne     _FMMultiply                 ; if not, do multiply code
        FloatClear32A                       ; otherwise return zero
_FMExit1:
        ply                                 ; restore registers
        plx
        pla
        rts     
        ;
        ;       Floating point multiply, also works as an integer operation, but if integer overflows
        ;       it will return a float, which can be detected by a non zero exponents
        ;
_FMMultiply:
        clc                                 ; add FPA exponent to FPB exponent
        lda     floatAExponent
        adc     floatBExponent
        pha

        lda     floatAFlags                 ; work out the new sign.
        eor     floatBFlags
        and     #$80
        pha

        FloatCopy32AR                       ; copy FPA into FPR
        FloatClear32A                       ; zero FPA
        ;
        ;       Main multiplication loop. FPA is the total, FPB is the additive multiplies, FPR is the right shifting multiplier.
        ;
_FMMultiplyLoop:
        lda     floatRMantissa+0            ; check LSB of FPR
        and     #1
        beq     _FMNoAdd                    

        FloatAdd32AB                        ; add FPB to FPA
        bit     floatAMantissa+3            ; did we get an overflow ?
        bpl     _FMNoAdd                    ; no, no overflow shift required.
        ;
        ;       Add overflowed, so shift FPA right rather than doubling FPB. In Integer only this will become a float
        ;
        FloatShr32A                         ; addition on overflow : shift FPA right and bump the exponent.
        inc     floatAExponent              ; this replaces doubling the adder FPB
        bra     _FMShiftR
        ;
        ;       Double FPB, the value being added in.
        ;
_FMNoAdd:       
        bit     floatBMantissa+3            ; is it actually possible to double FPB ?
        bvs     _FMCantDoubleB              ; e.g. is bit 30 clear
        FloatShl32B                         ; if it is clear we can just shift it
        bra     _FMShiftR
_FMCantDoubleB:
        FloatShr32A                         ; we can't double FPB so we halve FPA
        inc     floatAExponent              ; this fixes the result up.
        ;
        ;       The usual end of the multiply loop, shift FPR right and loop back if non-zero.
        ;
_FMShiftR:      
        FloatShr32R                         ; shift FPR right.
        FloatTest32R                        ; loop back if non-zero
        bne     _FMMultiplyLoop

_FMExit2:
        pla                                 ; update the sign and exponent.
        sta     floatAFlags
        pla
        clc
        adc     floatAExponent
        sta     floatAExponent
        jsr     FloatCheckMinusZero         ; -0 check required here.
        ply                                 ; restore registers
        plx
        pla
        rts
