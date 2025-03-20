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

FloatCode = *

; *******************************************************************************************
;
;	                                  Zero Page Usage
;
; *******************************************************************************************

        * = zeroPageSpace

aFlags:
		.fill 	1
aExponent:		
		.fill 	1
aMantissa:
		.fill 	4

bFlags:
		.fill 	1
bExponent:		
		.fill 	1
bMantissa:
		.fill 	4
zTemp0:			
		.fill	2

; *******************************************************************************************
;
;								Non-Zero page data space
;
; *******************************************************************************************

		* = dataSpace 

convBufferSize:
		.fill 	1
convBufferString:
		.fill 	16

polyCoefficientCount:
		.fill 	1
polyTempFloat:
		.fill 	6	
polySign:
		.fill 	1			
polyFlag:
		.fill 	1	
polyExponent:
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

        * = FloatCode
        