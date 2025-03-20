; *******************************************************************************************
; *******************************************************************************************
;
;       Name :      floattostr.asm
;       Purpose :   Float to string conversion
;       Date :      20th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;           Convert the float in FPA (not tested) to the string buffer
;
; *******************************************************************************************

FloatFloatToString:
        pha
        phx
        phy
        lda     floatAExponent                   ; is it actually an integer ?
        bne     _FFTSFloat
        jsr     FloatIntegerToDecimalString ; if so, just do the integer conversion
        ply
        plx
        pla
        rts

_FFTSFloat:
        FloatPush32A                             ; push A on the stack
        jsr     FloatInteger                ; convert to an integer part.
        jsr     FloatIntegerToDecimalString ; and convert to a string.
        lda     #"."                        ; add decimal point
        jsr     FloatAddCharacterToBuffer

_FFTSFracLoop:
        FloatPop32B                              ; pop current value off the stack.
        FloatTest32B                             ; is it zero, if so then exit.
        beq     _FFTSExit
        FloatCopy32BA                            ; put the value in A
        jsr     FloatFractional             ; take the fractional part.
        jsr     FloatNormaliseA             ; normalise it.
        lda     floatBExponent                   ; if it is a small number stop here
        cmp     #$DE
        bcc     _FFTSExit
        lda     floatBufferSize             ; too long a decimal
        cmp     #15
        bcs     _FFTSExit
        lda     #10                         ; multiply that by 10.
        FloatSet32B
        jsr     FloatMultiply
        FloatPush32A                             ; save result on the stack for the next time round.
        jsr     FloatInteger                ; convert to an integer
        lda     floatAMantissa+0                 ; output as a digit
        ora     #48
        jsr     FloatAddCharacterToBuffer
        bra     _FFTSFracLoop               ; and go round again.

_FFTSExit:    
        ldx     floatBufferSize             ; check for trailing zero
        lda     floatBufferString-1,x       ; ends in a zero, but not .0
        cmp     #"0"
        bne     _FFTSNotTrailingZero
        lda     floatBufferString-2,x
        cmp     #"."
        beq     _FFTSNotTrailingZero
        dec     floatBufferSize             ; patch up.
        stz     floatBufferString-1,x
_FFTSNotTrailingZero:
        ply
        plx
        pla
        rts