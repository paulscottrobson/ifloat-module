; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		sinecosine.asm
;		Purpose :	Sine/Cosine evaluation
;		Date :		20th March 2025
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;						Cosine calculation of FPA (in Radians)
;
; *******************************************************************************************

PolyCosine:
		pha
		phx
		phy
		PolyConstantToB FloatConst_PiDiv2	; add Pi/2
		jsr 	FloatAdd  					
		jsr 	PolySine 					; calculate sin(x+pi/2)
		ply
		plx
		pla
		rts

; *******************************************************************************************
;
;						Sine calculation of FPA (in Radians)
;
; *******************************************************************************************

PolySine:
		pha
		phx
		phy

		lda 	floatAFlags						; save original sign
		sta 	polySign 					
		stz 	floatAFlags 						; take absolute value
		;
		;		Divide FPA by 2.Pi and take fractional part, forcing result into the '360' range
		;
		PolyConstantToB FloatConst_1Div2Pi 	; multiply by 1 / (2.Pi) (e.g. divide by 2.Pi)
		jsr 	FloatMultiply
		jsr 	FloatFractional 			; take the fractional part.
		;
		;		Rounded into 0-360 (in scaled radians), so x 4 to get the quadrant (0=0-90,1=90-180,2=180-270,3=270-360)
		;
		inc 	floatAExponent 					; x 2
		inc 	floatAExponent 					; x 4
		FloatPush32A 							; save this value
		jsr 	FloatInteger
		lda 	floatAMantissa+0 				; get the quadrant.
		pha 								; save for later
		cmp 	#2 							; quadrant 2 + 3, negate the result
		bcc 	_PSNotQ23
		lda 	polySign
		eor 	#$80
		sta 	polySign
_PSNotQ23:		
		;
		;		Work out the fractional part and adjust for quadrants 1 & 3
		;
		FloatPop32B 							; get the 4 x value back to B
		FloatCopy32BA							; copy to A. 
		jsr 	FloatFractional 			; fractional part, not quadrant
		pla 								; restore the quadrant
		and 	#1 							; is it quadrant 1 or 3
		beq 	_PSNotQ13
		lda 	#$80 						; make FPA -x (calculating 1-x)
		sta 	floatAFlags
		lda 	#1 							; B = 1, so -x + 1 being done here.
		FloatSet32B
		jsr 	FloatAdd
_PSNotQ13:		
		;
		; 		Save FPA for end multiply 
		;
		FloatPush32A 							; save FPA
		;
		;		Calculate FPA^2
		;
		FloatPush32A 							; square FPA - copy to FPB (slowly) and multiply
		FloatPop32B
		jsr 	FloatMultiply 				

		;
		;		Apply the polynomial and multiply by the saved value.
		;
		ldx 	#PolynomialSineData-PolynomialData
		jsr 	PolyEvaluate
		FloatPop32B 							; now multiply by the original value
		jsr 	FloatMultiply 				

		lda 	polySign 					; get original sign
		bpl 	_PSExit 
		lda 	floatAFlags 						; if was -ve negate the result.
		eor 	#$80
		sta 	floatAFlags		
_PSExit:		
		ply
		plx
		pla
		rts		
