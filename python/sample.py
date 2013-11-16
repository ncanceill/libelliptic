from elliptic import elliptic

def main():
	elliptic.Point.base = 7
	print("Prime base: "+str(elliptic.Point.base))
	elliptic.ElliPoint.curve_set(2,1)
	print("Elliptic curve: ("+str(elliptic.ElliPoint.a)+","+str(elliptic.ElliPoint.b)+")")
	p = elliptic.ElliPoint(1,2)
	print("P: "+str(p))
	q = p*3*6
	q = q+p
	print("Q = P*3*6+P: "+str(q))

if __name__ == '__main__':
	main()

