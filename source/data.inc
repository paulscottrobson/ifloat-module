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

ftStackPointer:
        .fill   1
ftStack:
        .fill   10*6

        * = FloatCodeResume
        