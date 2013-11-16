#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see [http://www.gnu.org/licenses/].
#
# Copyright (C) 2013 Nicolas Canceill
#

def expo(x,y,base):
	x_ = x%base
	y_ = y%base
	if y_ == 0: return 1
	if y_%2 == 0: return expo(x_,y_//2,base)**2
	return x_*expo(x_,y_-1,base)

def inverse(n,base):
	n_ = n%base
	if n_ == 0:
		raise ZeroDivisionError("divided by 0 modulo "+str(base))
	return expo(n_,base-2,base)

def divide(n,q,base):
	return n * inverse(q,base) % base

class Point:
	base = 0

	def __init__(self,x,y,z):
		self.X = x % self.base
		self.Y = y % self.base
		self.Z = z % self.base

	def eq(self,p):
		return self.X == p.X and self.Y == p.Y and self.Z == p.Z

	def __str__(self):
		return "Point ({},{},{})".format(self.X,self.Y,self.Z)

class ProjPoint(Point):
	def __init__(self,x,y,z=1):
		super().__init__(x,y,z)
		if self.X+self.Y+self.Z == 0:
			raise TypeError("(0,0,0) is not projective")

	def is_infty(self):
		return self.Z % self.base == 0

	def eq(self,p):
		if self.is_infty():
			if not p.is_infty(): return false
			if self.X == 0: return p.X == 0
			return divide(p.X,self.X,self.base) * self.Y % base == p.Y
		else:
			if p.is_infty(): return false
			return self.X == p.X and self.Y == p.Y

	def x(self):
		if self.is_infty():
			raise TypeError("Infinity cannot be homogeneous")
		return divide(self.X,self.Z,self.base)

	def y(self):
		if self.is_infty():
			raise TypeError("Infinity cannot be homogeneous")
		return divide(self.Y,self.Z,self.base)

	def __str__(self):
		if self.is_infty(): return "ProjPoint Infinity/{}".format(self.base)
		return "ProjPoint ({},{})/{}".format(self.x(),self.y(),self.base)

	def belongs_to(self,a,b):
		if self.is_infty(): return self.X == 0 and self.Y == 1
		return (self.X**3+a*self.X*self.Z**2+b*self.Z**3-self.Y**2*self.Z)%self.base == 0

class ElliPoint(ProjPoint):

	a = 0
	b = 0

	@staticmethod
	def infty():
		return ElliPoint(0,1,0)

	@classmethod
	def curve_set(self,a,b):
		self.a = a
		self.b = b

	def __init__(self,x,y,z=1):
		super().__init__(x,y,z)
		if not self.belongs_to(self.a,self.b):
			raise AttributeError("Point out of curve: {}".format(self))

	def __neg__(self):
		if self.is_infty(): return self.infty()
		return ElliPoint(self.x(),-self.y())

	def __pow__(self,p):
		if self.is_infty(): return -p
		if p.is_infty(): return -self
		if self == p:
			l = divide(3*self.x()**2+self.a,2*self.y(),self.base)
			k = l**2-2*self.x()
			return ElliPoint(k,l*(k-self.x())+self.y())
		if self.x() == p.x(): return self.infty()
		l = divide(p.y()-self.y(),p.x()-self.x(),self.base)
		k = l**2-self.x()-p.x()
		return ElliPoint(k,l*(k-self.x())+self.y())

	def __rpow__(self,p):
		return p.__pow__(self)

	def __add__(self,p):
		return self.infty()**(self**p)

	def __radd__(self,p):
		return self.__add__(p)

	def __sub__(self,p):
		return self+(-p)

	def __rsub__(self,p):
		return p.__sub__(self)

	def __mul__(self,n):
		if n == 0: return self.infty()
		if n == 1: return self
		if n < 0: return (-self)*(-n)
		return self+(self*(n-1))

	def __rmul__(self,n):
		return self.__mul__(n)

	def __str__(self):
		if self.is_infty(): return "ElliPoint Infinity/{}".format(self.base)
		return "ElliPoint ({},{})/{}".format(self.x(),self.y(),self.base)

