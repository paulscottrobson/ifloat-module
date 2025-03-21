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

data = [x for x in open("dump.bin","rb").read(-1)]
pos = 0x2000
while data[pos] != 0xFF:
    cmd = data[pos]
    if cmd == FPCommands.FloatToString or cmd == FPCommands.IntegerToDecimalString or cmd == FPCommands.IntegerToString:
        print("${0:04x} : {1} [{2}] => {3}".format(pos,number(pos+1),cmd,string(pos+13)))
    elif cmd == FPCommands.StringToFloat or cmd == FPCommands.StringToInteger:
        print("${0:04x} : {1} [{2}] => {3}".format(pos,string(pos+1),cmd,number(pos+13)))
    else:
        print("${0:04x} : {1} [{2}] {3} => {4}".format(pos,number(pos+1),cmd,number(pos+7),number(pos+13)))
    pos += 32