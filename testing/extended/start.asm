; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		start.asm
;		Purpose :	Extended test for ifloat code.
;		Date :		21st March 2025
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

        zeroPageSpace = $20
        dataSpace = $400
        codeSpace = $1000

        * = codeSpace

testPtr = $10

Boot:
		ldx 	#$FF
		txs
        jmp     Start

        .include "../../source/float.asm"
;        .include "../../build/ifloat.library"


Start:  lda     #TestData & $FF
        sta     testPtr
        lda     #TestData >> 8
        sta     testPtr+1
_TestLoop:
        lda     (testPtr)                   ; check if reached end of the tests
        bmi     _TestExit

        clc                                 ; set string pointer in case it is one.
        lda     testPtr     
        adc     #1
        sta     floatZ0
        lda     testPtr+1
        adc     #0
        sta     floatZ0+1

        ldy     #1
_TestCopy:
        lda     (testPtr),y                 ; copy the test data in as numbers initially.
        sta     floatAFlags-1,y
        iny
        cpy     #13
        bne     _TestCopy        

        lda     (testPtr)                   ; do the command
        jsr     FloatEntry
_TestError:        
        bcs     _TestError

        ldy     #13                         ; copy A into the result area.
_TestCopy2:        
        lda     floatAFlags-13,y
        sta     (testPtr),y
        iny
        cpy     #19
        bne     _TestCopy2

        lda     (testPtr)
        cmp     #FTCMD_FloatToString        ; returns a string
        beq     _TestCopyString
        cmp     #FTCMD_IntegerToDecimalString
        beq     _TestCopyString
        cmp     #FTCMD_IntegerToString
        bne     _TestNext

_TestCopyString:                            ; copy string into result area.
        ldx     #0
        ldy     #13
_TestCSLoop:
        lda     floatBufferString,x
        sta     (testPtr),y
        inx
        iny
        cpx     #12
        bne     _TestCSLoop
                
_TestNext:        
        clc                                 ; do next test.
        lda     testPtr
        adc     #32
        sta     testPtr
        bcc     _TestLoop
        inc     testPtr+1
        bra     _TestLoop

_TestExit:
        jmp     $FFFF



        lda     #_testString & $FF
        sta     floatZ0
        lda     #_testString >> 8
        sta     floatZ0+1


_testString:
        .text   '512.471',0
        ;
        ;       Use one of the two depending on whether you want the multi-file version or the one file library.
        ;
        * = $2000

TestData:
        .include "__testdata.inc"		

        