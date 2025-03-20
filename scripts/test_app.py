# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		test_app.py
#		Purpose :	General purpose app 
#		Date :		15th November 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import math

r = 32.75
print("Using math library",math.log(r,math.e))


print("Start",r)

r = r + math.sqrt(0.5)
print("Add root 0.5",r)

r = math.sqrt(2) / r
print("Divide into root 2",r)

r = 1.0 - r
print("Subtract from 1",r)

poly = [0.43425594189,0,0.57658454124,0,0.96180075919,0,2.8853900731,-0.5]
poly.reverse()
x = r
r = 0
for i in range(0,len(poly)):
	r = r + pow(x,i) * poly[i]
print("After polynomial calculation",r)

# Add the shift.

r = r * math.log(2.0,math.e)
print("Multiply by log e 2",r)

