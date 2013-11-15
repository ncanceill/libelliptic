package main

import "fmt"
import "./elliptic"

func main() {
	elliptic.SetBase(7)
	base := elliptic.Base()
	fmt.Printf("sample: Prime base = %d\n", base)
	elliptic.SetA(2)
	elliptic.SetB(1)
	a := elliptic.A()
	b := elliptic.B()
	fmt.Printf("sample: Elliptic curve (%d,%d)\n", a, b)
	var sing string
	if elliptic.Abs(4*a*a*a+27*b*b, base) != 0 {
		sing = "non-"
	}
	fmt.Printf("sample: Curve is %ssingular\n", sing)
	p, _ := elliptic.NewElliPoint(1, 2)
	px, _ := p.HX()
	py, _ := p.HY()
	fmt.Printf("sample: P = (%d,%d)\n", px, py)
	q := p.Times(3).Times(6)
	q = q.Plus(p)
	qx, _ := q.HX()
	qy, _ := q.HY()
	fmt.Printf("sample: P = P * 3 * 6 + P = (%d,%d)\n", qx, qy)
}
