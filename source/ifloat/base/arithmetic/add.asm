; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		add.asm
;		Purpose :	Addition/Subtraction
;		Date :		9th December 2024
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;						  Subtract iFloat FPB from iFloat FPA
;
; *******************************************************************************************

FloatSubtract:
		pha 								; toggle the sign of FPB and add
		lda 	bFlags 						
		eor 	#$80
		sta 	bFlags
		pla

; *******************************************************************************************
;
;						Add iFloat FPB to iFloat FPA (also used for subtract)
;
; *******************************************************************************************

FloatAdd:
		pha 								; save registers
		phx
		phy

		lda 	aExponent 					; check if both integer
		ora 	bExponent
		beq 	_FAInteger 					; if so, don't need to normalise
		;
		;		Check zero.
		;
		+Test32B 							; check if FPB = 0
		beq 	_FAExit 					; if so, just return FPA.
		+Test32A 							; check if FPA = 0
		bne 	_FAFloatingPoint 			; if not, then do FP addition.
		+Copy32BA 							; copy FPB to FPA
		bra 	_FAExit 					; and exit
		;
		;		Floating point add/subtract
		;
_FAFloatingPoint:
		jsr 	FloatNormaliseA 			; normalise FPA & FPB 					
		jsr 	FloatNormaliseB 					
		;
		;		Work out the common exponent for the arithmetic.
		;
		lda 	aExponent 					; calculate the higher exponent, to X
		tax
		sec
		sbc 	bExponent 					; signed comparison
		bvc		+
		eor 	#$80
+		bpl 	+
		ldx 	bExponent 					; get the lower value.
+		
		;
		;		Shift both mantissa/exponent to match X in FPA
		;
- 		cpx 	aExponent 					; reached required exponent (FPA)
		beq 	+
		phx
		+Shr32A 							; shift right and adjust exponent, preserving the target
		plx
		inc 	aExponent
		bra 	-
+			
		;
		;		Shift both mantissa/exponent to match X in B
		;
- 		cpx 	bExponent 					; reached required exponent (FPB)
		beq 	+
		phx
		+Shr32B 							; shift right and adjust exponent, preserving the target
		plx
		inc 	bExponent
		bra 	-
+								
		;
		;		Now do the mantissa add/subtract and adjustment, figure out which first.
		;					
_FAInteger:
		lda 	aFlags 						; are they different sign flags
		eor 	bFlags 						; e.g. the signs are different, it's a subtraction
		bmi 	_FASubtraction
_FAAddition:
		;
		;		Integer arithmetic : Addition
		;
		+Add32AB  							; add FPB to FPA - sign of result is inherited.
		bpl 	_FAExit 					; no overflow, bit 31 of mantissa clear.
		+Shr32A 							; fix up the mantissa
		inc 	aExponent 					; bump the exponent
		bra 	_FAExit 					; and quit.
		;
		;		Integer arithmetic : Subtraction
		;	
_FASubtraction:
		+Sub32AB 							; subtract FPB from FPA
		bpl 	_FAExit 					; no underflow, then exit.
		+Neg32A 							; negate FPA mantissa 
		lda 	aFlags 						; toggle the sign flag
		eor 	#$80
		sta 	aFlags
		bra 	_FAExit
		;
		;		Exit, with check for minus zero
		;
_FAExit:
		jsr 	FloatCheckMinusZero
		ply 								; restore registers
		plx
		pla
		rts

; *******************************************************************************************
;
;			Test FPA for minus zero as we have a sign and magnitude system
;
; *******************************************************************************************

FloatCheckMinusZero:
		lda 	aFlags 						; slight increase as mostly +ve
		bpl 	_FCMZExit
		+Test32A 							; if a zero mantissa
		bne 	_FCMZExit
		lda 	aFlags 						; clear the sign bit
		and 	#$7F
		sta 	aFlags
_FCMZExit:				
		rts		


		bra 	_FAExit

; *******************************************************************************************
;
;									Normalise FPA & FPB
;
; *******************************************************************************************

FloatNormaliseA:
		+Test32A 							; check FPA zero
		beq 	_NAExit		
-:
		lda 	aMantissa+3 				; check normalised
		and 	#$40
		bne 	_NAExit		
		+Shl32A
		dec 	aExponent
		bra 	-
_NAExit:
		rts				
		
FloatNormaliseB:
		+Test32B 							; check FPB zero
		beq 	_NBExit
-:
		lda 	bMantissa+3 				; check normalised
		and 	#$40
		bne 	_NBExit		
		+Shl32B
		dec 	bExponent
		bra 	-
_NBExit:
		rts				

