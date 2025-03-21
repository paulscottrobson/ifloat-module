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

floatCodeResume = *

; *******************************************************************************************
;
;	                                  Zero Page Usage
;
; *******************************************************************************************

        * = zeroPageSpace

floatA:

floatAFlags:
		.fill 	1
floatAExponent:		
		.fill 	1
floatAMantissa:
		.fill 	4

floatB:

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

floatBufferSize:
		.fill 	1
floatBufferString:
		.fill 	33

polyCoefficientCount:
		.fill 	1
polyTempFloat:
		.fill 	6	
polySign:
		.fill 	1			
polyFlag:
		.fill 	1	
polyExponentTemp:
		.fill 	1				

floatR:
floatRFlags:
		.fill 	1
floatRExponent:		
		.fill 	1
floatRMantissa:
		.fill 	4

floatBaseConvert:
		.fill 	1
floatModulusLowByte:
		.fill 	1	

floatStackPointer:
        .fill   1
floatStack:
        .fill   5*6

        * = floatCodeResume
        