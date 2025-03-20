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
        ;
        ;       The basic arithmetic operations
        ;        
        .include "base/arithmetic/add.asm"
        .include "base/arithmetic/multiply.asm"
        .include "base/arithmetic/divide.asm"
        .include "base/arithmetic/integer.asm"
        .include "base/arithmetic/fractional.asm"
        ;
        ;       Convert to/from strings.
        ;
        .include "base/utilities/inttostr.asm"
        .include "base/utilities/floattostr.asm"
        .include "base/utilities/strtoint.asm"
        .include "base/utilities/strtofloat.asm"
        .include "base/utilities/scale10.asm"
        .include "base/utilities/__scalars.asm"
        ;
        ;       Taylor series functions.
        ;
        .include "polynomial/__coefficients.asm"
        .include "polynomial/__constants.asm"        
        .include "polynomial/sinecosine.asm"                
        .include "polynomial/tangent.asm"                
        .include "polynomial/logarithm.asm"                
        .include "polynomial/exponent.asm"                
        .include "polynomial/squareroot.asm"                
        .include "polynomial/arctangent.asm"                
        .include "polynomial/utility.asm"                

