# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		functions.py
#		Purpose :	Trigonometry / Logarithms functions.
#		Date :		9th December 2024
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import random,math
from ifloat import *

# *******************************************************************************************
#
#									Polynomial base class
#
# *******************************************************************************************

class PolyCalculator(object):
	#
	#		Evaluate a sine polynomial.
	#
	def evaluatePolynomial(self,v,coeff):
		if self.getName() is not None:
			self.registerPolynomial()

		n = 0
		for c in coeff:
			n = n * v
			n = n + c
		return n
	#
	#		Evaluate a factorial
	#
	def factorial(self,n):
		r = 1
		for i in range(1,n+1):
			r = r * i
		return r
	#
	#		Get name for output
	#
	def getName(self):
		return None
	#
	# 		Register a polynomial set
	#
	def registerPolynomial(self):
		name = self.getName()
		PolyCalculator.polynomials[name] = self.getPolynomial()
	#
	#		Export the polynomials.
	#
	def export(self,fileName):
		h = open(fileName,"w")
		h.write(";\n;\tThis file is automatically generated.\n;\n")
		h.write("PolynomialData:\n")
		for k in PolyCalculator.polynomials.keys():
			self.exportPolynomial(h,k,PolyCalculator.polynomials[k])
		h.close()
	#
	def exportPolynomial(self,h,name,values):
		h.write("\n;\n;\t Polynomial to evaluate {0}\n;\n".format(name))
		h.write("Polynomial{0}Data:\n".format(name))
		h.write("\t!byte\t{0}\n".format(len(values)))
		for v in values:
			f = IFloat(v)
			m = f.mantissa
			h.write("\t!byte\t${0:02x},${1:02x},${2:02x},${3:02x},${4:02x},${5:02x} ; {6}\n".format(0x80 if f.isNegative else 0x00,f.exponent & 0xFF, 
					m & 0xFF,(m >> 8) & 0xFF,(m >> 16) & 0xFF,(m >> 24) & 0xFF,v))

PolyCalculator.polynomials = {}

# *******************************************************************************************
#
#								Calculate sin(x) in radians
#
# *******************************************************************************************

class SineCalculator(PolyCalculator):
	#
	#		Calculate polynomial function sin(x)
	#
	def calculate(self,r):
		f = r / (2 * math.pi)  															# Divide by 2.Pi, so 0..360 is now range 0..1
		#
		f = abs(f)   																	# Get the fractional part, force into range.
		f = f - math.floor(f)
		#
		f = f * 4  																		# multiply to get quadrant
		quadrant = int(f) 																# quadrant 0-3 work out.
		f = f - int(f)  																# take fractional part
		#
		sign = 1 if r >= 0 else -1  													# sin(-x) = -sin(x)
		if quadrant >= 2:  																# quadrant 2 + 3 are -ve quadrant 0 + 1
			sign = -sign
		if quadrant == 1 or quadrant == 3: 												# quadrant 1 and 3, flip as curve is backwards
			f = 1.0 + (-f)

		sinePoly = self.getPolynomial()
		result = self.evaluatePolynomial(f*f,sinePoly) * f   							# evaluate using x^2 and multiply by x
		result = result * sign
		return result
	#
	#		Get Polynomial
	#
	def getPolynomial(self):
		sinePoly = []  																	# calculate the sine polynomial
		for i in range(0,5):
			coefficient = 1.0 / self.factorial(i*2+1) 									# normal polynomial
			coefficient = coefficient if (i % 2) == 0 else -coefficient
			coefficient = coefficient / pow(4*4,i)  									# adjust for the divide by 4 pre squaring
			coefficient = coefficient / 4  												# adjust for the final result being divided by 4.
			coefficient = coefficient * pow(2 * math.pi ,i*2+1)
			sinePoly.insert(0,coefficient)
		return sinePoly
	#
	#		Get name for output
	#
	def getName(self):
		return "Sine"

# *******************************************************************************************
#
#								Calculate cos(x) in radians
#
# *******************************************************************************************

class CosineCalculator(SineCalculator):
	#
	#		Calculate cos(x) using sin(x)
	#
	def calculate(self,r):
		return SineCalculator.calculate(self,r + math.pi/2)

# *******************************************************************************************
#
#								Calculate tan(x) in radians
#
# *******************************************************************************************

class TangentCalculator(SineCalculator):
	#
	#		Calculate tan(x) using sin(x)/cos(x)
	#
	def calculate(self,r):
		sineValue = SineCalculator.calculate(self,r)
		cosineValue = SineCalculator.calculate(self,r + math.pi/2)
		return None if cosineValue == 0 else sineValue / cosineValue

# *******************************************************************************************
#
#								Calculate arctan(x) in radians
#
# *******************************************************************************************

class ArcTanCalculator(PolyCalculator):
	#
	#		Calculate arctan(x)
	#
	def calculate(self,f):
		#
		adjust = abs(f) >= 1  															# outside range 0..1
		if adjust: 	 																	# if outside range use pi/2-atan(1/f)
			f = 1 / f
		#
		sign = -1 if f < 0 else 1  														# work out sign of result.		
		f = abs(f)
		#
		atanPoly = self.getPolynomial()
		#
		result = self.evaluatePolynomial(f*f,atanPoly) * f   							# evaluate using x^2 and multiply by x
		if adjust:
			result = math.pi/2 - result
		#
		result = result * sign  														# put sign back in.
		return result
	#
	#		Get name for output
	#
	def getName(self):
		return "Arctan"
	#
	#		Get Polynomial
	#
	def getPolynomial(self):
		atanPoly = []  																	# calculate the atan polynomial
		for i in range(0,10):
			coefficient = 1.0 / (i*2+1)
			coefficient = coefficient if (i % 2) == 0 else -coefficient
			atanPoly.insert(0,coefficient)
		return atanPoly

# *******************************************************************************************
#
#								Calculate log(x)
#
# *******************************************************************************************

class LogCalculator(PolyCalculator):
	#
	#		Calculate polynomial function log(x)
	#
	def calculate(self,r):
		if r < 0:
			return None
		exp = 0  																		# Force into range 0.5-1 , this can be done fairly easily by manipulating
		while r >= 1:   																# exponents
			r = r / 2
			exp = exp + 1
		while r < 0.5:
			r = r * 2
			exp = exp - 1

		x = 1.0-math.sqrt(2) / (r + math.sqrt(0.5))  									# calculate the coefficient
		r = self.evaluatePolynomial(x,self.getPolynomial())  							# evaluate the polynomial.
		r = r + exp  																	# Put power back
		r = r * math.log(2)  															# Force to log base e
		return r

	#
	#		Get name for output
	#
	def getName(self):
		return "Log"
	#
	#		Get Polynomial
	#
	def getPolynomial(self):
		logPoly = [0.43425594189,0,0.57658454124,0,0.96180075919,0,2.8853900731,-0.5]
		return logPoly

# *******************************************************************************************
#
#								Calculate exp(x)
#
# *******************************************************************************************

class ExpCalculator(PolyCalculator):
	#
	#		Calculate polynomial function log(x)
	#
	def calculate(self,r):
		x = abs(r * math.log(math.e,2)) 											# Multiply by log2 e, take absolute value.
		#
		exp = int(x)  																# Exponent is the integer part
		x = x - exp   																# calculate for fractional part
		if r < 0:  																	# if was originally -ve
			x = -x   																# negate fractional part and exponent adjust
			exp = -exp
		#							
		pow2Poly = self.getPolynomial()
		r = self.evaluatePolynomial(x,pow2Poly) * pow(2,exp)  						# Multiply by 2^ exp - easy in floating point.
		return r
	#
	#		Get name for output
	#
	def getName(self):
		return "Exp"
	#
	#		Get Polynomial
	#
	def getPolynomial(self):
		# This polynomial calculates 2^x
		return [ 2.1498763701e-5 ,1.4352314037e-4 ,1.3422634825e-3 ,9.6140170135e-3 ,5.5505126860e-2 ,0.24022638460 ,0.69314718618, 1.0 ]

if __name__ == "__main__":
	random.seed(42)
	#
	#		Sine test
	#
	if False:
		for i in range(-90,90,5):
			a = i / 10.0
			print("{0:5} {1:8.3f} {2:8.3f} {3:8.3f}".format(a,math.sin(a),SineCalculator().calculate(a),abs(math.sin(a)-SineCalculator().calculate(a))))
		print()
	#
	#		Cosine test
	#
	if False:
		for i in range(-90,90,5):
			a = i / 10.0
			print("{0:5} {1:8.3f} {2:8.3f} {3:8.3f}".format(a,math.cos(a),CosineCalculator().calculate(a),abs(math.cos(a)-CosineCalculator().calculate(a))))
		print()
	#
	#		Tangent test (only if cos(a) is non-zero)
	#
	if False:
		for i in range(-90,90,5):
			a = i / 10.0
			if math.cos(a) != 0:
				t = math.tan(a)
				print("{0:5} {1:8.3f} {2:8.3f} {3:8.3f}".format(a,t,TangentCalculator().calculate(a),abs(t-TangentCalculator().calculate(a))))
		print()
	#
	#		Arctangent test 
	#
	if False:
		for i in range(-90,90,5):
			a = i / 10.0
			t = math.atan(a)
			print("{0:5} {1:8.3f} {2:8.3f} {3:8.3f}".format(a,t,ArcTanCalculator().calculate(a),abs(t-ArcTanCalculator().calculate(a))))
		print()
	#
	#		Log test 
	#
	if True:

		for i in range(5,100,3):
			a = i / 10.0
			t = math.log(a)
			print("{0:5} {1:8.3f} {2:8.3f} {3:8.3f}".format(a,t,LogCalculator().calculate(a),abs(t-LogCalculator().calculate(a))))
		print()
	#
	#		Exp test 
	#
	if False:
		for i in range(-40,40,4):
			a = i / 10.0
			t = math.exp(a)
			print("{0:5} {1:8.3f} {2:8.3f} {3:8.3f}".format(a,t,ExpCalculator().calculate(a),abs(t-ExpCalculator().calculate(a))))
		print()

	#
	#		Yes, it's a bodge. 
	#
	LogCalculator().calculate(1.0)
	ExpCalculator().calculate(1.0)
	SineCalculator().calculate(1.0)
	CosineCalculator().calculate(1.0)
	TangentCalculator().calculate(1.0)
	ArcTanCalculator().calculate(1.0)

	LogCalculator().export("coefficients.acme")

