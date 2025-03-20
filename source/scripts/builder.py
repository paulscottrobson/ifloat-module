# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		builder.py
#		Purpose :	Construct iFloat module.
#		Date :		20th March 2025
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import os,sys,re

for s in open("float.asm").readlines():
    if s.find(".include") >= 0:
        m = re.match('^\\s*\\.include\\s*\\"(.*?)\\"',s)
        assert m is not None,"Bad include "+s
        for s1 in open(m.group(1)).readlines():
            assert s1.find(".include") < 0,s + "bad line"
            print(s1.rstrip())
    else:
        print(s.rstrip())