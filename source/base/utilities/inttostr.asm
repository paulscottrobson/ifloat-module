; *******************************************************************************************
; *******************************************************************************************
;
;       Name :      inttostr.asm
;       Purpose :   Integer to String conversion.
;       Date :      20th March 2025
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;           Convert the integer in FPA (not tested) to Decimal in the string buffer
;
; *******************************************************************************************

FloatIntegerToDecimalString:
        pha
        lda     #10
        jsr     FloatIntegerToString        
        pla
        rts

; *******************************************************************************************
;
;                   Convert the integer in FPA to a String in Base A
;
; *******************************************************************************************

FloatIntegerToString:
        pha                                 ; save registers
        phx
        phy
        sta     floatBaseConvert                 ; save the base to convert

        stz     floatBufferSize                 ; clear the buffer, both NULL terminated and length prefixed.
        stz     floatBufferString

        bit     floatAFlags                      ; -ve ?
        bpl     _FITSPositive
        stz     floatAFlags                      ; not really required :)
        lda     #'-'                        ; output -
        jsr     FloatAddCharacterToBuffer
_FITSPositive:      
        jsr     _FITSRecursive
        ply                                 ; restore registers
        plx
        pla
        rts             

_FITSRecursive:
        lda     floatBaseConvert                 ; divide by the base, put in B
        FloatSet32B                      
        jsr     FloatIntDivide              ; integer division.
        lda     floatModulusLowByte              ; get the low byte, the remainder and save it.
        pha
        FloatTest32A                             ; zero ?
        beq     _FITSZero
        jsr     _FITSRecursive              ; if not, keep going.
_FITSZero:
        pla
        cmp     #10                         ; hexadecimal or higher ?
        bcc     _FITSNotHex
        clc
        adc     #7
_FITSNotHex:
        clc                                 ; make ASCII.
        adc     #48
        jsr     FloatAddCharacterToBuffer   ; add to buffer and exit
        rts

; *******************************************************************************************
;
;                   Add Character to Buffer (also used by FloatToString)
;
; *******************************************************************************************

FloatAddCharacterToBuffer:
        phx
        ldx     floatBufferSize                 ; current size
        sta     floatBufferString,x             ; write character out
        stz     floatBufferString+1,x       ; make ASCIIZ
        inc     floatBufferSize                 ; bump character count
        plx
        rts
