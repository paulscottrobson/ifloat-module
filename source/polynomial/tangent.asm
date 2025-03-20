; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		tangent.asm
;		Purpose :	Tangent evaluation
;		Date :		20th March 2025
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;					Tangent calculation of FPA (in Radians). Return CS on error
;
; *******************************************************************************************

PolyTangent:
		pha
		phx
		phy

		FloatPush32A 							; save FPA on stack
		jsr 	PolyCosine 					; FPA is cos(x)
		FloatPop32B 							; FPA is cos(x) FPB (x)
		FloatPush32A 							; FPB is x, cos(x) on stack
		FloatCopy32BA 							; FPA is x, cos(x) on stack
		jsr 	PolySine 					; FPA is sin(x), cos(x) on stack
		FloatPop32B 							; FPA is sin(x), FPB is cos(x)

		FloatTest32B 							; check cos(x) is zero.
		sec 								; if so exit with carry set.
		beq 	_PTExit
		jsr 	FloatDivide 				; work out tangent
		clc 								; no error.
_PTExit:		
		ply
		plx
		pla
		rts

