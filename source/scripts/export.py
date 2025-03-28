# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		export.py
#		Purpose :	Export functions generation.
#		Date :		21st March 2025
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re
#
#       List of functions to be exported. Indexed from zero.
#
exportList = [
    "FloatAdd",
    "FloatSubtract",
    "FloatMultiply",
    "FloatDivide",
    "FloatIntDivide",
    "FloatFractional",
    "FloatInteger",
    "FloatFloatToString",
    "FloatIntegerToDecimalString",
    "FloatIntegerToString",
    "FloatScale10",
    "FloatStringToInteger",
    "FloatStringToFloat",
    "FloatLogarithmE",
    "FloatExponent",
    "FloatSquareRoot",
    "FloatSine",
    "FloatCosine",
    "FloatTangent",
    "FloatArcTangent"
]

header = ";\n;\tThis file is automatically generated.\n;"
#
#       Vector table.
#
if sys.argv[1] == "V":
    print(header)
    print("FloatVectorTable:")
    for i in range(0,len(exportList)):
        print("\tFloatVector\t{0:30} ; {1}".format(exportList[i],i))
#
#       Constants (Assembler)
#
if sys.argv[1] == "C":
    print(header)
    print("FTCMD_COUNT = {0}\n".format(len(exportList)))
    for i in range(0,len(exportList)):
        fc = "FTCMD_"+exportList[i][5:]
        print("{0} = {1}".format(fc,i))        
#
#       Constants (Python)
#
if sys.argv[1] == "P":
    print(header.replace(";","#"))
    print("class FPCommands(object):\n\tpass\n")
    for i in range(0,len(exportList)):
        fc = exportList[i]
        print("FPCommands.{0} = {1}".format(fc[5:],i))                