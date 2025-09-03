# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		viewer.py
#		Purpose :	Unit test result viewer
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
#                                       Test result viewer
#
# *******************************************************************************************

def number(p):
    n = IFloat(0)
    n.isNegative = (data[p] & 0x80) != 0
    n.exponent = data[p+1]
    n.exponent = n.exponent if n.exponent < 128 else n.exponent-256
    n.mantissa = data[p+2] + (data[p+3] << 8) + (data[p+4] << 16) + (data[p+5] << 24)
    return n.get()

def string(p):
    s = ""
    while data[p] != 0:
        s = s + chr(data[p])
        p += 1
    return '"'+s+'"'

def calc(n1,op,n2):
    if op == FPCommands.Add:
        return [n1+n2,"+"]
    if op == FPCommands.Subtract:
        return [n1-n2,"-"]
    if op == FPCommands.Multiply:
        return [n1*n2,"*"]
    if op == FPCommands.Divide:
        return [n1/n2,"/"]
    if op == FPCommands.IntDivide:
        return [n1//n2,"//"]
    if op == FPCommands.Fractional:
        return [abs(n1)-int(abs(n1)),"Frac()"]
    if op == FPCommands.Integer:
        return [int(abs(n1)) * (-1 if n1 < 0 else 1),"Int()"]
    if op == FPCommands.SquareRoot:
        return [math.sqrt(n1),"Sqrt()"]
    if op == FPCommands.Sine:
        return [math.sin(n1),"Sin()"]
    if op == FPCommands.Cosine:
        return [math.cos(n1),"Cos()"]
    if op == FPCommands.Tangent:
        return [math.tan(n1),"Tan()"]
    if op == FPCommands.ArcTangent:
        return [math.atan(n1),"ArcTan()"]
    return [0,"---"]


data = [x for x in open("dump.bin","rb").read(-1)]
pos = 0x2000
while data[pos] != 0xFF:
    cmd = data[pos]
    n1 = number(pos+1)
    n2 = number(pos+7)
    r = number(pos+13)

    if cmd == FPCommands.FloatToString or cmd == FPCommands.IntegerToDecimalString or cmd == FPCommands.IntegerToString:
        print("${0:04x} : {1} [{2}] => {3}".format(pos,number(pos+1),cmd,string(pos+13)))
    elif cmd == FPCommands.StringToFloat or cmd == FPCommands.StringToInteger:
        print("${0:04x} : {1} [{2}] => {3}".format(pos,string(pos+1),cmd,number(pos+13)))
    else:
        ev = calc(n1,cmd,n2)
        pc = int(100*abs(ev[0]-r)/r if r != 0 else 1)
        print("${0:04x} : {1} [{5}] {3} => {4} : <{6} {7}%>".format(pos,round(n1,3),cmd,round(n2,3),round(r,3),ev[1],round(ev[0],3),pc))
        assert pc < 2 or cmd == FPCommands.IntDivide

    pos += 32