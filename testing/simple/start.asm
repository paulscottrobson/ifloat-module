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

		ldx 	#11 						; copy in test data.
-		lda 	testdata1,x
		sta 	aFlags,x
		dex
		bpl 	-

        lda     #1
        sta     FloatBufferSize
        lda     #"?"
        sta     FloatBufferString

		jsr 	FloatFloatToString

		jmp 	$FFFF

        .include "../../source/float.asm"
        .include "__testdata.inc"

		