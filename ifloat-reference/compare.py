# *******************************************************************************************
# *******************************************************************************************
#
#       Name :      compare.py
#       Purpose :   Compare two values
#       Date :      22nd March 2025
#       Author :    Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,math,random
from ifloat import *
from mathop import *
from add import *

# *******************************************************************************************
#
#                                      Comparison Class
#
#
# *******************************************************************************************

class CompareOperation(BinaryOperation):
    #
    #       Add two numbers
    #
    def calculate(self,a,b):
        if a.isNegative != b.isNegative:                                                    # If the signs are different then it's easy !
            return IFloat(-1 if a.isNegative else 1)

        flipResult = a.isNegative                                                           # if both -ve the result is flipped.
        a.isNegative = False                                                                # calculate |a|-|b|
        b.isNegative = True
        result = AddOperation().calculate(a,b)                                              # which is now in result.

        if result.exponent != 0:                                                            # For floats this ignores tiny errors.
            result.mantissa &= 0xFFFFF800

        if result.mantissa == 0:                                                 
            return IFloat(0)
        retVal = -1 if result.isNegative else 1
        return IFloat(-retVal if flipResult else retVal)
    #
    #       Error percent allowed
    #
    def getErrorPercent(self,a,b):
        return 0.0001                                                                       # This doesn't quite work, Python and this routine do it differently.
    #  
    #       Calculate the actual result.
    #
    def getResult(self,a,b):
        v = a.get()-b.get()
        if abs(v) < 0.000001:
            return 0
        return -1 if v < 0 else 1
    #
    #       Validate the input data.
    #
    def validate(self,a,b):
        return abs(a.get()) > 0.000001 and abs(b.get()) > 0.000001

        
if __name__ == "__main__":
    random.seed(42)
    to = CompareOperation()
#   r = to.calculateFloat(IFloat(1903998632),IFloat(1.54207332572e-14))
#   r.dump()
    for i in range(0,1000*100):
        to.test(False,False)
