; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		float.asm
;		Purpose :	Main program, also used to create module library
;		Date :		20th March 2025
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

        .include "data.inc"

        .include "6502/fp_macros_6502.inc"
        .include "6502/fp_utility_6502.asm"        

        .include "65816/fp_macros_65816.inc"
        .include "65816/fp_utility_65816.asm"        


        .include "base/arithmetic/add.asm"
        .include "base/arithmetic/multiply.asm"
        .include "base/arithmetic/divide.asm"
        .include "base/arithmetic/integer.asm"
        .include "base/arithmetic/fractional.asm"

