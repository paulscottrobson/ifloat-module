; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		start.asm
;		Purpose :	Test bed for ifloat code.
;		Date :		20th March 2025
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

        zeroPageSpace = $20
        dataSpace = $400
        codeSpace = $1000

        * = codeSpace

Boot:
		ldx 	#$FF
		txs
        jmp     Start

        .include "../../source/float.asm"

Start:
		ldx 	#11 						; copy in test data.
-		lda 	testdata1,x
		sta 	floatAFlags,x
		dex
		bpl 	-

        lda     #_testString & $FF
        sta     floatZ0
        lda     #_testString >> 8
        sta     floatZ0+1

		FloatDo StringToFloat

		jmp 	$FFFF

_testString:
        .text   '512.471',0
        ;
        ;       Use one of the two depending on whether you want the multi-file version or the one file library.
        ;
;        .include "../../build/ifloat.library"

        .include "__testdata.inc"		

        