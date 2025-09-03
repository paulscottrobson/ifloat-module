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
    #       String test (e.g. to int, to float)
    #
    def createStringTest(self,s1,func):
        self.test = [ func ]
        self.test += [ ord(c) for c in s1 ]
        self.padTest()
        self.outputTest()
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
    random.seed()
    seed = random.randint(0,9999)
    random.seed(seed)

    sys.stderr.write("Seed {0}\n".format(seed))
    t = TestGenerator()

    for s in range(0,1):
        n1 = random.randint(-1000001,100000)
        n2 = 0
        while n2 == 0:
            n2 = random.randint(-10000,10000)
        t.createBinaryTest(n1,n2,FPCommands.Add)
        t.createBinaryTest(n1,n2,FPCommands.Subtract)
        t.createBinaryTest(n1,n1,FPCommands.Subtract)
        t.createBinaryTest(n1,n2,FPCommands.Multiply)
        t.createBinaryTest(n1,n2,FPCommands.Divide)
        t.createBinaryTest(n1,n2,FPCommands.IntDivide)

        n1 = random.randint(-1000000,10000000)/100
        n2 = 0.0
        while n2 == 0.0:
            n2 = random.randint(-100000,1000000)/100
        t.createBinaryTest(n1,n2,FPCommands.Add)
        t.createBinaryTest(n1,n2,FPCommands.Subtract)
        t.createBinaryTest(n1,n1,FPCommands.Subtract)
        t.createBinaryTest(n1,n2,FPCommands.Multiply)
        t.createBinaryTest(n1,n2,FPCommands.Divide)
        
        n1 = random.randint(-100000,100000)/100
        t.createUnaryTest(n1,FPCommands.Fractional)
        t.createUnaryTest(n1,FPCommands.Integer)

        t.createUnaryTest(abs(n1),FPCommands.SquareRoot)

        n1 = random.randint(-2000,2000)/1000
        t.createUnaryTest(n1,FPCommands.Sine)
        t.createUnaryTest(n1,FPCommands.Cosine)
        t.createUnaryTest(n1,FPCommands.Tangent)
        t.createUnaryTest(n1,FPCommands.ArcTangent)

        n1 = random.randint(-100000,100000)
        n2 = random.randint(-100000,100000)/100
        t.createUnaryTest(n1,FPCommands.IntegerToDecimalString)
        t.createUnaryTest(n2,FPCommands.FloatToString)
        t.createUnaryTest(-n1,FPCommands.IntegerToDecimalString)
        t.createUnaryTest(-n1,FPCommands.FloatToString)
        t.createUnaryTest(-n2,FPCommands.FloatToString)

        t.createStringTest(str(n1),FPCommands.StringToInteger)
        t.createStringTest(str(n2),FPCommands.StringToFloat)
        t.createStringTest(str(-n1),FPCommands.StringToInteger)
        t.createStringTest(str(-n2),FPCommands.StringToFloat)

    t.endTest()