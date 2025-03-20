; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		strtoint.asm
;		Purpose :	String to Integer conversion.
;		Date :		20th March 2025
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;		(floatZ0) points to a numeric string, extract decimal integer from it to FPA (no minus 
;		prefix). Return CS on error (overflow, no number), and return in A the number of 
;		characters removed.
;
; *******************************************************************************************

FloatStringToInt:
		phx
		phy

		FloatClear32A 							; set the F{A register to zero.
		ldy 	#0 							; start from here.
_FSILoop:	
		FloatLoadIY floatZ0 					; get next character
		cmp 	#'0'						; check validity
		bcc 	_FSIExit
		cmp 	#'9'+1
		bcs 	_FSIExit	

		lda 	#10 						; multiply FPA by 10
		FloatSet32B
		jsr 	FloatMultiply
		FloatLoadIY floatZ0 					; add number.
		iny
		and 	#$0F
		FloatSet32B
		jsr 	FloatAdd  					
		lda 	floatAExponent 					; check still an integer.
		beq 	_FSILoop
_FSIFail: 									; overflow, or no digits at all.
		sec 		
		lda 	#0 							; return zero consumed as error.
		ply 								; restore registers
		plx
		rts				

_FSIExit:
		tya									; check consumed at least one digit ? count in Y
		beq 	_FSIFail
		ply 								; restore registers
		plx
		clc
		rts				

