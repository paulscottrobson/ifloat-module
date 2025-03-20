; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		data.inc
;		Purpose :	Data files
;		Date :		20th March 2025
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

FloatCodeResume = *

; *******************************************************************************************
;
;	                                  Zero Page Usage
;
; *******************************************************************************************

        * = zeroPageSpace

floatAFlags:
		.fill 	1
floatAExponent:		
		.fill 	1
floatAMantissa:
		.fill 	4

floatBFlags:
		.fill 	1
floatBExponent:		
		.fill 	1
floatBMantissa:
		.fill 	4
        
floatZ0:			
		.fill	3

; *******************************************************************************************
;
;								Non-Zero page data space
;
; *******************************************************************************************

		* = dataSpace 

FloatBufferSize:
		.fill 	1
FloatBufferString:
		.fill 	33

polyCoefficientCount:
		.fill 	1
polyTempFloat:
		.fill 	6	
polySign:
		.fill 	1			
polyFlag:
		.fill 	1	
PolyExponentTemp:
		.fill 	1				

rFlags:
		.fill 	1
rExponent:		
		.fill 	1
rMantissa:
		.fill 	4

baseConvert:
		.fill 	1
modulusLowByte:
		.fill 	1	

FloatStackPointer:
        .fill   1
FloatStack:
        .fill   5*6

        * = FloatCodeResume
        