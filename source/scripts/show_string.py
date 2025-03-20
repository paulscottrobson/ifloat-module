# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		show_string.py
#		Purpose :	Output string length prefixed.
#		Date :		20th March 2025
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re

if os.path.exists(sys.argv[1]):
	mem = [x for x in open(sys.argv[1],"rb").read(-1)]
	for s in sys.argv[2:]:
		addr = eval(s)
		print("Length:{0} \"{1}\"".format(mem[addr],"".join([chr(mem[addr+i+1]) for i in range(0,mem[addr])])))