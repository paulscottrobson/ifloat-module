# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		show_ifloat.py
#		Purpose :	Output iFloats in binary format.
#		Date :		9th December 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re

if os.path.exists(sys.argv[1]):
	mem = [x for x in open(sys.argv[1],"rb").read(-1)]
	for s in sys.argv[2:]:
		addr = eval(s)
		mantissa = mem[addr+2] + (mem[addr+3] << 8) + (mem[addr+4] << 16) + (mem[addr+5] << 24)
		exponent = mem[addr+1]
		exponent = exponent if (exponent & 0x80) == 0 else exponent - 256
		sign = mem[addr+0] & 0x80
		n = mantissa * pow(2,exponent) * (-1 if sign != 0 else 1)
		print("Number: {3} Mantissa: ${0:08x} Exponent: ${1:02x} Sign: ${2:02x}".format(mantissa,exponent,sign,n))
