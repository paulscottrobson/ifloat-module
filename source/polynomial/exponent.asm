; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		exponent.asm
;		Purpose :	Exponent evaluation
;		Date :		20th March 2025
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;									Calculation of e^FPA 
;
; *******************************************************************************************

PolyExponent:
		pha
		phx
		phy
		;
		;		Save sign, take absolute value
		;
		lda 	floatAFlags
		sta 	polySign
		stz 	floatAFlags
		;
		;		Multiply FPA by log2 e
		;
		PolyConstantToB FloatConst_Log2_E			; multiply by log2 e
		jsr 	FloatMultiply
		;
		;		Extract the integer part.
		;
		Push32A 							; push FPA as we want it restored after this bit.
		jsr 	FloatInteger 				; take and save the integer part
		lda 	floatAMantissa+0 			
		sta 	PolyExponentTemp
		Pop32B
		Copy32BA
		jsr 	FloatFractional 			; extract the fractional part
		;
		;		Handle -ve values in original FPA. Negate the exponent and the value for x
		;
		bit 	polySign
		bpl 	_PENotNegative

		sec 								; negate the exponent
		lda 	#0
		sbc 	PolyExponentTemp
		sta 	PolyExponentTemp

		lda 	#$80 						; make FPA negative
		sta 	floatAFlags

_PENotNegative:		
		;
		;		Take fractional part of FPA and calculate the Polynomial (which is 2^x, not the standard exp() taylor series)
		;
		ldx 	#PolynomialExpData-PolynomialData
		jsr 	PolyEvaluate
		;
		;		Add the exponent extracted earlier
		;
		clc
		lda 	PolyExponentTemp
		adc 	floatAExponent
		sta 	floatAExponent

		ply
		plx
		pla
		rts

