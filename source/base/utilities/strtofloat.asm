; *******************************************************************************************
; *******************************************************************************************
;
;       Name :      strtofloat.asm
;       Purpose :   Convert value at (floatZ0) to a floating point number in A
;       Date :      20th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;                   Convert string at (floatZ0) into FPA. Return CS on error.
;        Behaves like VAL() in that it does not have a problem with ending bad characters
;
; *******************************************************************************************

FloatStringToFloat:
        pha                                 ; save registers
        phx
        phy
        ;
        ;       Process possible preceding '-'
        ;
        ldy     #0
        lda     (floatZ0)                   ; get, and push, the first character.
        eor     #"-"                        ; will be $00 if it is '-', non zero otherwise
        beq     _FSTFNoFlip
        lda     #$80                        ; $00 => '-', $80 => positive
_FSTFNoFlip:        
        eor     #$80                        ; now a sign bit.
        pha                                 ; save it.
        beq     _FSTFNoMinus                ; if was +ve don't bump
        lda     #1
        jsr     _FSTFAddToPointer
_FSTFNoMinus:
        ;
        ;       The integer part, if there is one.
        ;
        FloatClear32A                       ; zero FPA
        ldy     #1                          ; this is the amount to skip if decimal.
        FloatLoadI floatZ0                  ; is it '.xxxxx' VAL(".12") => 0.12
        cmp     #"."                        ; if so, convert to decimal.
        beq     _FSTFDecimalPart

        jsr     FloatStringToInteger        ; get the integer part first.
        bcs     _FSTFExit                   ; bad number.
        tay                                 ; count of characters in Y
        FloatLoadIY floatZ0                 ; what follows is '.'
        cmp     #'.'                        ; if not, then exit with a whole number and carry clear
        bne     _FSTFExitOkay
        iny
        ;
        ;       The fractional part, if there is one.
        ;
_FSTFDecimalPart:
        tya                                 ; point floatZ0 to post decimal point bit.
        jsr     _FSTFAddToPointer
        FloatLoadI floatZ0                  ; character following, if illegal just ignore it.
        cmp     #'0'                        ; VAL("12.") => 12
        bcc     _FSTFExitOkay
        cmp     #'9'+1
        bcs     _FSTFExitOkay
        FloatPush32A                        ; push FPA on the stack.
        jsr     FloatStringToInteger        ; get the Decimal Point bit, divisor is in A
        bcs     _FSTFExit                   ; bad number.
        tay                                 ; put in Y
        jsr     FloatScale10                ; divide by 10^Y
        FloatPop32B                         ; FPA is fractional part, FPB integer part
        jsr     FloatAdd                    ; add them together.
_FSTFExitOkay:
        pla                                 ; get flags
        sta     floatAFlags
        clc                                 ; result is okay.
_FSTFExit:      
        ply                                 ; restore registers
        plx
        pla
        rts             

; *******************************************************************************************
;
;                       Add A to the pointer, supports 6502 and 65816
;
; *******************************************************************************************

_FSTFAddToPointer:
        clc
        adc     floatZ0
        sta     floatZ0
        bcc     _FSTFNoCarry
        inc     floatZ0+1
        bne     _FSTFNoCarry
        inc     floatZ0+2
_FSTFNoCarry:       
        rts

        