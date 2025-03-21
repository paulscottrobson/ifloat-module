# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		create.py
#		Purpose :	Unit test creation simple.
#		Date :		21st March 2025
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,math,random
from __fpconsts import *
from __ifloat_copy import *

# *******************************************************************************************
#
#                                       Generates tests
#
# *******************************************************************************************

class TestGenerator(object):
    def __init__(self):
        self.target = sys.stdout
    #
    #       Numerical binary test
    #
    def createBinaryTest(self,n1,n2,func):
        self.test = [ func ]                                                        # 1 byte, the function
        self.addNumber(n1)                                                          # The 2 values 6 bytes each (or a 12 byte ASCIIZ string)
        self.addNumber(n2)
        self.padTest()                                                              # 6 byte result or 12 bytes ASCIIZ string next
        self.outputTest()
    #
    #       Numerical unary test
    #
    def createUnaryTest(self,n1,func):
        self.createBinaryTest(n1,0,func)
    #
    #       Output test to target
    #
    def outputTest(self):
        self.target.write("\t.byte\t{0}\n".format(",".join([str(x) for x in self.test])))
    #
    #       Add a number to the test in ifloat format
    #
    def addNumber(self,n):
        n = IFloat(n)
        self.test += [ 0x80 if n.isNegative else 0x00 , n.exponent & 0xFF]
        for i in range(0,4):
            self.test.append((n.mantissa >> (i * 8)) & 0xFF)
    #
    #       Pad test out to full size
    #
    def padTest(self):
        while len(self.test) != 32:
            self.test.append(0)
    #
    #       Add the end of test list marker.
    #
    def endTest(self):
        self.target.write("\t.byte\t$FF\n")

#
#       Manually created for development & debugging.
#
if __name__ == "__main__":
    t = TestGenerator()
    t.createBinaryTest(22,7,FPCommands.Add)
    t.createBinaryTest(22,7,FPCommands.Subtract)
    t.createBinaryTest(22,7,FPCommands.Multiply)
    t.createBinaryTest(22,7,FPCommands.Divide)
    t.createBinaryTest(22,7,FPCommands.IntDivide)

    t.createBinaryTest(22.5,7,FPCommands.Add)
    t.createBinaryTest(22.5,7,FPCommands.Subtract)
    t.createBinaryTest(22.5,7,FPCommands.Multiply)
    t.createBinaryTest(22.5,7,FPCommands.Divide)
    t.createBinaryTest(22.5,7,FPCommands.IntDivide)

    t.createUnaryTest(123.456,FPCommands.Fractional)
    t.createUnaryTest(123.456,FPCommands.Integer)

    t.createUnaryTest(65,FPCommands.SquareRoot)
    t.createUnaryTest(1,FPCommands.Sine)
    t.createUnaryTest(1,FPCommands.Cosine)
    t.createUnaryTest(1,FPCommands.Tangent)
    t.createUnaryTest(1,FPCommands.ArcTangent)
    t.endTest()