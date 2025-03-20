; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		logarithm.asm
;		Purpose :	Natural logarithm evaluation
;		Date :		20th March 2025
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;						Logarithm calculation of FPA. Return CS on error
;
; *******************************************************************************************

PolyLogarithmE:
		pha
		phx
		phy


		lda 	aFlags 						; if negative, it's bad
		sec 								; so return with CS.
		bmi 	_PLEExit

		jsr 	FloatNormaliseA 			; normalise, might be integer

		;
		;		Extract the exponent, as a power of 2.
		;
		lda 	aExponent 					; work out the shift
		sec
		sbc 	#$E1  						; $E1 normalised is the required exponent offset
		pha  								; save on stack.

		lda 	#$E1 						; force into range 0.5-1
		sta 	aExponent
		;
		;		Add square root of 0.5
		;
		jsr 	PolyCopyFloatB 	
		.word	FloatConst_Sqr0_5
		jsr 	FloatAdd
		;
		;		Divide into -(square root of 2)
		;
		Push32A
		Pop32B
		jsr 	PolyCopyFloatA
		.word	FloatConst_MinusSqr2
		jsr 	FloatDivide
		;
		;		Add 1 (so calculating 1-root(2)/(x+root(0.5)))
		;
		lda 	#1
		Set32B
		jsr 	FloatAdd
		;
		;		Apply the polynomial
		;
		ldx 	#PolynomialLogData-PolynomialData
		jsr 	PolyEvaluate
		;
		;		Add the exponent offset
		;
		pla 								; Set A to the exponent offset.
		Set32B
		jsr 	FloatAdd

		jsr 	PolyCopyFloatB 				; multiply by Log(2)
		.word	FloatConst_Log2
		jsr 	FloatMultiply

		clc
_PLEExit:
		ply
		plx
		pla
		rts

