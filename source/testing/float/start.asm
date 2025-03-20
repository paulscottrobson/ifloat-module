; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		start.asm
;		Purpose :	Test bed for ifloat code.
;		Date :		9th December 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

Boot:
		ldx 	#$FF
		txs

		ldx 	#11 						; copy in test data.
-:		lda 	test_float,x
		sta 	aFlags,x
		dex
		bpl 	-

		stz 	exprStackPtr 				; clear out expression stack.
		stz 	convBufferSize

		;jsr 	FloatAdd	
		;jsr 	FloatSubtract
		;jsr 	FloatMultiply
		;jsr 	FloatIntDivide
		;jsr 	FloatDivide
		;jsr 	FloatInteger
		;jsr 	FloatFractional		

		;jsr 	PolySine
		;jsr 	PolyCosine
		;jsr 	PolyTangent
		;jsr 	PolyArcTangent
		;jsr 	PolyExponent

		;jsr 	PolyLogarithmE
		jsr 	PolySquareRoot 

		;jsr 	FloatFloatToString

		;lda 	#testString & $FF
		;sta 	zTemp0
		;lda 	#testString >> 8
		;sta 	zTemp0+1
		;jsr 	FloatStringToFloat

		jmp 	$FFFF

testString:
		!text 	"32766.127Z"



		