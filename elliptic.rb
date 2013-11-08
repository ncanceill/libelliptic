# This is a library for computing elliptic curves.
#
# Author::    Nicolas Canceill (mailto:nicolas.canceill@ens-cachan.org)
# Copyright:: Copyright (c) 2013 Nicolas Canceill
# License::   GNU Public License v3

# This module implements specific arithmetics methods.
#
# == Division ring
#
# Every operation is performed in <i>Z/pZ</i>, which is a division ring when
# <i>p</i> is prime. It contains integers from 0 to <i>p</i>-1.
#
# == base parameter
#
# Consequently, each function requires a base argument as <i>p</i>.

module Ellithmetic

	#
	# Module functions
	module_function

	# Computes the inverse of any number in <i>Z/pZ</i>
    #
    # ==== Attributes
    #
    # * +n+ - The number to compute. It will be reduced <i>modulo p</i>. WARNING: passing 0 <i>modulo p</i> will raise a <code>ZeroDivisionError</code>!
    # * +base+ - The base for <i>Z/pZ</i>. WARNING: if <i>p</i> is not prime, results will be incoherent!
    #
    # ==== Examples
    #
    # Basic usage:
    #
    #    inverse 1, 11
	#        => 1
    #    inverse 3, 5
	#        => 2
    #    inverse 4, 5
	#        => 4
	#
	# You can compute any number, it will be reduced in <i>Z/pZ</i>:
	#
    #    inverse -666, 5
	#        => 4
	def inverse n, base
		n_ = n % base
		raise ZeroDivisionError,
		      "divided by 0 modulo " + base.to_s if
				n_ == 0
		return 1 if n_ == 1
		i = 2
		i += 1 until (i * n) % base == 1
		return i % base
	end

	# Computes the division of a number by another in <i>Z/pZ</i>
    #
    # ==== Attributes
    #
    # * +n+ - The number to divide. It will be reduced <i>modulo p</i>.
    # * +q+ - The number to divide by. It will be reduced <i>modulo p</i>. WARNING: passing 0 will raise a <code>ZeroDivisionError</code>!
    # * +base+ - The base for <i>Z/pZ</i>. WARNING: if <i>p</i> is not prime, results will be incoherent!
    #
    # ==== Examples
    #
    # Basic usage:
    #
    #    divide 4, 2, 11
	#        => 2
    #    divide 3, 2, 11
	#        => 7
	#
	# You can compute any number, it will be reduced in <i>Z/pZ</i>:
	#
    #    divide -1, 4, 5
	#        => 1
    #    divide -666, 4, 5
	#        => 1
	def divide n, q, base
		return (n * (inverse q, base)) % base
	end

end

# This class implements a tri-dimensional point in <i>Z/pZ</i>.
#
# == Coordinates
#
# Coordinates are stored as accessible variables X, Y, and Z.
#
# == <i>Z/pZ</i>
#
# Coordinates are integers <i>modulo p</i>. You should set the <code>@@base</code> variable to <i>p</i>.

class Point

	#
	# Attributes

	# The coordinates of the point, <i>modulo</i> <code>@@base</code>.
	attr_accessor :X, :Y, :Z

	#
	# Constructors

	# Creates a new point.
    #
    # ==== Attributes
    #
    # * +x+ - The first coordinate. It will be reduced <i>modulo p</i>.
    # * +y+ - The first coordinate. It will be reduced <i>modulo p</i>.
    # * +z+ - The first coordinate. It will be reduced <i>modulo p</i>.
    #
    # ==== Examples
    #
    # Basic usage:
    #
    #    Point.new 0, 1, 0
	def initialize x, y, z
		@X = x % @@base
		@Y = y % @@base
		@Z = z % @@base
	end

	#
	# Instance methods


	# Tests if this point is equal to the passed-in point.
    #
    # ==== Attributes
    #
    # * +point+ - The point to test equality to.
    #
    # ==== Examples
    #
    # Basic usage:
    #
    #    Point.new 0, 1, 0 == Point.new 0, 1, 0
	#        => true
    #    Point.new 0, 0, 0 == Point.new 0, 1, 0
	#        => false
    #
    # If @@base is 13:
    #
    #    Point.new 0, 1, 5 == Point.new 0, -12, 18
	#        => true
	def == point
		return @X == point.X && @Y = point.Y && @Z == point.Z
	end

	#
	# Class definitions
	class << self

		# Gets the base of <i>Z/pZ</i> currently used for points.
		def base
			@@base
		end

		# Sets the base of <i>Z/pZ</i> currently used for points.
		#
		# WARNING: in order to set up a projective space for elliptic curve,
		# the base should be a prime number.
		#
		# ==== Examples
		#
		# Basic usage:
		#
		#    Point.base = 13
		#        => true
		#    Point.new 0, 1, 5 == Point.new 0, -12, 18
		#        => true
		#    Point.base = 7
		#        => true
		#    Point.new 0, 1, 5 == Point.new 0, -12, 18
		#        => false
		def base= base
			@@base = base
		end

	end

end

# This class implements a projective tri-dimensional point in <i>Z/pZ</i>.
#
# == Coordinates
#
# Coordinates are stored as accessible variables <code>@X</code>, <code>@Y</code>, and <code>@Z</code>.
#
# == <i>Z/pZ</i>
#
# Coordinates are integers <i>modulo p</i>. You should set the <code>@@base</code> variable to <i>p</i>.
#
# == Projective space
#
# In this projective space, points whith 0 as third coordinate <code>@Z</code> are <i>infinity points</i>,
# while the others have homogeneous coordinates <code>:x</code> and <code>:y</code>.

class ProjPoint < Point
	include Ellithmetic

	#
	# Constructors

	# Creates a new projective point.
    #
    # ==== Attributes
    #
    # * +x+ - The first coordinate. It will be reduced <i>modulo p</i>.
    # * +y+ - The first coordinate. It will be reduced <i>modulo p</i>.
    # * +z+ - The first coordinate. It will be reduced <i>modulo p</i>. Default value is 1.
    #
    # ==== Examples
    #
    # Basic usage:
    #
    #    ProjPoint.new 0, 1, 0
    #
    #    ProjPoint.new 1, 5
    #
    # You can use homogeneous coordinates transparently:
    #
    #    ProjPoint.new 2, 1 == ProjPoint.new 2, 1, 1
	#        => true
    #
    #    ProjPoint.new 2, 1 == ProjPoint.new 16, 8, 4
	#        => true
	def initialize x, y, z=1
		super x, y, z
		raise ArgumentError,
		      "point (0, 0, 0) is not projective" if
				@X + @Y + @Z == 0
	end

	#
	# Instance methods

	# Tests if this projective point is equal to the passed-in projective point.
    #
    # ==== Attributes
    #
    # * +point+ - The projective point to test equality to.
    #
    # ==== Examples
    #
    # Basic usage:
    #
    #    ProjPoint.new 1, 5 == ProjPoint.new -2, -10
	#        => true
    #
    #    ProjPoint.new 1, 5 == ProjPoint.new -2, 0
	#        => false
    #
    # Infinity points are all equal to each another:
    #
    #    ProjPoint.new 0, 1, 0 == ProjPoint.new 6, -7, 0
	#        => true
	def == point
		if self.isInfty?
			return false unless point.isInfty?
			return point.X == 0 if @X == 0
			return ((divide point.X, @X, @@base) * @Y) % @@base == point.Y
		else
			return false if point.isInfty?
			return point.x == self.x && point.y == self.y
		end
	end

	# Tests if this projective point is an <i>infinity point</i>.
	#
	# ==== Examples
	#
	# Basic usage:
	#
	#    ProjPoint.new(1, 2).isInfty?
	#        => false
	#
	#    ProjPoint.new(1, 2, 0).isInfty?
	#        => true
	#
	#    ProjPoint.new(1, 2, Point.base).isInfty?
	#        => true
	def isInfty?
		return @Z % @@base == 0
	end

	# Gets <code>:x</code>, the first homogeneous coordinate of this projective point.
	#
	# WARNING: calling x on an <i>infinity point</i> will raise a <code>TypeError</code>.
	#
	# ==== Examples
	#
	# Basic usage:
	#
	#    ProjPoint.new(8, 2, 4).x
	#        => 2
	#
	#    ProjPoint.new(Point.base, 2).x
	#        => 0
	def x
		raise TypeError,
		      "infinity cannot have homogeneous coordinates" if
				self.isInfty?
		return divide @X, @Z, @@base
	end

	# Gets <code>:y</code>, the second homogeneous coordinate of this projective point.
	#
	# WARNING: calling y on an <i>infinity point</i> will raise a <code>TypeError</code>.
	#
	# ==== Examples
	#
	# Basic usage:
	#
	#    ProjPoint.new(1, 8, 4).y
	#        => 2
	#
	#    ProjPoint.new(-1, Point.base).y
	#        => 0
	def y
		raise TypeError,
		      "infinity cannot have homogeneous coordinates" if
				self.isInfty?
		return divide @Y, @Z, @@base
	end

	# Tests if this projective point belongs to a specific elliptic curve.
	#
	# WARNING: this method only checks the Weierstraß equation, it does not
	# check whether the elliptic curve is valid (i.e. whether <code>4*a^3+27*b^2 = 0</code>).
	#
	# ==== Attributes
	#
	# * +a+ - The <i>a</i> parameter of the specific elliptic curve.
	# * +b+ - The <i>b</i> parameter of the specific elliptic curve.
	#
	# ==== Examples
	#
	# Basic usage:
	#
	#    ProjPoint.new(0, 1, 0).belongs_to 1, 1
	#        => true
	#
	#    ProjPoint.new(1, 1, 0).belongs_to 3, 2
	#        => false
	#
	#    ProjPoint.new(0, 2).belongs_to 1, 4
	#        => true
	def belongs_to a,b
		return self == ProjPoint.new(0, 1, 0) if self.isInfty?
		return (@X**3 + a * @X * @Z**2 + b * @Z**3 - @Y**2 * @Z) % @@base == 0
	end

end

# This class implements a projective tri-dimensional point of an elliptic curve in <i>Z/pZ</i>.
#
# == Coordinates
#
# Coordinates are stored as accessible variables <code>@X</code>, <code>@Y</code>, and <code>@Z</code>.
#
# == <i>Z/pZ</i>
#
# Coordinates are integers <i>modulo p</i>. You should set the <code>@@base</code> variable to <i>p</i>.
#
# == Projective space
#
# In this projective space, points whith 0 as third coordinate <code>@Z</code> are <i>infinity points</i>,
# while the others have homogeneous coordinates <code>:x</code> and <code>:y</code>.
#
# == Elliptic curve
#
# The elliptic curve is defined by variables <code>@@a</code> and <code>@@b</code>. In order to obtain a valid elliptic curve,
# <code>4*@@a^3 + 27*b^2</code> should not be 0.
#
# == Elliptic calculations
#
# Within this elliptic curve, you can perform operations on points, because they form an abelian group.

class ElliPoint < ProjPoint

	#
	# Constructors

	# Creates a new point from the elliptic curve.
    #
	# WARNING: if the coordinates do not match a point on the curve,
	# an <code>ArgumentError</code> will be raised.
    #
    # ==== Attributes
    #
    # * +x+ - The first coordinate. It will be reduced <i>modulo p</i>.
    # * +y+ - The first coordinate. It will be reduced <i>modulo p</i>.
    # * +z+ - The first coordinate. It will be reduced <i>modulo p</i>. Default value is 1.
    #
    # ==== Examples
    #
    # Basic usage:
    #
    #    ElliPoint.new 0, 1, 0
    #
    #    ElliPoint.new 1, 5
	def initialize x, y, z=1
		super x, y, z
		raise ArgumentError,
		      "creating point out of curve (" + @@a.to_s + ", " + @@b.to_s + ")" unless
				self.belongs_to @@a, @@b
	end

	#
	# Instance methods

	# Returns the opposite of this point.
	#
	# ==== Examples
	#
	# Basic usage:
	#
	#    -ElliPoint.new(0, 1, 0) == ElliPoint.new(0, 1, 0)
	#        => true
	#
	#    -ElliPoint.new(1, 1, 0) == ElliPoint.new(1, 1, 0)
	#        => false
	def -@
		return ElliPoint.infty if self.isInfty?
		return ElliPoint.new self.x, -self.y
	end

	# Returns the result of the combination of this elliptic point
	# with another, using the <i>star</i> law.
	#
	# ==== Examples
	#
	# Basic usage:
	#
	#    ElliPoint.new(0, 1, 0) ** ElliPoint.new(0, 1, 0) == ElliPoint.new(0, 1, 0)
	#        => true
	#
	#    ElliPoint.new(1, 1) ** ElliPoint.new(0, 1, 0) == ElliPoint.new(1, -1)
	#        => true
	def ** p
		return -p if self.isInfty?
		return -self if p.isInfty?
		if self == p
			l = divide (3 * self.x**2 + @@a), (2 * self.y), @@base
			k = l**2 - 2 * self.x
			return ElliPoint.new k, (l * (k - self.x) + self.y)
		end
		return ElliPoint.infty if self.x == p.x
		l = divide (p.y - self.y), (p.x - self.x), @@base
		k = l**2 - self.x - p.x
		return ElliPoint.new k, (l * (k - self.x) + self.y)
	end

	# Returns the result (addition) of the combination of this elliptic point
	# with another, using the <i>plus</i> law.
	#
	# ==== Examples
	#
	# Basic usage:
	#
	#    ElliPoint.new(1, 1) + ElliPoint.new(1, -1) == ElliPoint.new(0, 1, 0)
	#        => true
	#
	#    ElliPoint.new(1, 1) + ElliPoint.new(0, 1, 0) == ElliPoint.new(1, 1)
	#        => true
	def + p
		return ElliPoint.infty ** (self ** p)
	end

	# Returns the result (substraction) of the combination of this elliptic point
	# with another, using the <i>plus</i> law and the opposite operation.
	#
	# ==== Examples
	#
	# Basic usage:
	#
	#    ElliPoint.new(1, 1) - ElliPoint.new(1, 1) == ElliPoint.new(0, 1, 0)
	#        => true
	#
	#    ElliPoint.new(1, 1) - ElliPoint.new(0, 1, 0) == ElliPoint.new(1, 1)
	#        => true
	def - p
		return self + -p
	end

	# Returns the result (multiplication) of the combination of this elliptic point
	# with an integer, using the opposite operation if needed, and iterating over the <i>plus</i> law.
	#
	# ==== Examples
	#
	# Basic usage:
	#
	#    ElliPoint.new(0, 1, 0) * 4 == ElliPoint.new(0, 1, 0)
	#        => true
	#
	#    ElliPoint.new(2, 3) * 0 == ElliPoint.new(0, 1, 0)
	#        => true
	#
	#    ElliPoint.new(1, 1) * -1 == ElliPoint.new(1, -1)
	#        => true
	def * n
		return ElliPoint.infty if n == 0
		return -self * -n if n < 0
		return self + (self * (n - 1))
	end

	#
	# Class definitions
	class << self

		# Returns the <i>infinity point</i>.
		#
		# ==== Examples
		#
		# Basic usage:
		#
		#    ElliPoint.new(0, 1, 0) == ElliPoint.infty
		#        => true
		def infty
			return new 0, 1, 0
		end

		# Gets the <i>a</i> parameter currently used for the elliptic curve.
		def a
			@@a
		end

		# Sets the <i>a</i> parameter currently used for the elliptic curve.
		#
		# WARNING: in order to obtain a valid elliptic curve,
		# <code>4*@@a^3 + 27*b^2</code> should not be 0.

		def a= a
			@@a = a
		end

		# Gets the <i>b</i> parameter currently used for the elliptic curve.
		def b
			@@b
		end


		# Sets the <i>b</i> parameter currently used for the elliptic curve.
		#
		# WARNING: in order to obtain a valid elliptic curve,
		# <code>4*@@a^3 + 27*b^2</code> should not be 0.
		def b= b
			@@b = b
		end

	end

end
