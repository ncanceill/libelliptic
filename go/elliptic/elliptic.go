package elliptic

import "fmt"

func Abs(n int,base int) int {
	if n < 0 {
		return n%base+base
	}
	return n%base
}

func Expo(x int, y int, base int) int {
	x_, y_ := Abs(x,base), Abs(y,base)
	if y_ == 0 {
		return 1
	}
	xp := Expo(x_, y_/2, base)
	if y_%2 == 0 {
		return xp * xp % base
	}
	return Abs(x_ * xp * xp, base)
}

func Inverse(n int, base int) (int, error) {
	n_ := Abs(n,base)
	if n_ == 0 {
		return 0, fmt.Errorf("elliptic: divided by zero modulo %d", base)
	}
	return Expo(n_, base-2, base), nil
}

func Divide(n int, q int, base int) (int, error) {
	i,e := Inverse(q, base)
	if e != nil {
		return 0,e
	}
	return Abs(n * i, base),nil
}

var base int

func Base() int {
	return base
}

func SetBase(b int) {
	base = b
}

type Point struct {
	X, Y, Z int
}

func NewPoint(x int, y int, z int) *Point {
	return &Point{X: Abs(x,base), Y: Abs(y,base), Z: Abs(z,base)}
}

func (p *Point) Equals(q *Point) bool {
	return p.X == q.X && p.Y == q.Y && p.Z == q.Z
}

type ProjPoint struct {
	Point
}

func NewProjPoint(c ...int) (*ProjPoint, error) {
	if len(c) < 2 {
		return nil, fmt.Errorf("elliptic: a projpoint needs X and Y")
	}
	var z int
	if len(c) < 3 {
		z = 1
	} else {
		z = c[2]
	}
	p := NewPoint(c[0], c[1], z)
	if (p.X + p.Y + p.Z) == 0 {
		return nil, fmt.Errorf("elliptic: point (0,0,0) is not projective")
	}
	return &ProjPoint{*p},nil
}

func (p *ProjPoint) IsInfty() bool {
	return p.Z == 0
}

func (p *ProjPoint) Equals(q *ProjPoint) (bool,error) {
	if p.IsInfty() {
		if !q.IsInfty() {
			return false,nil
		}
		if p.X == 0 {
			return q.X == 0,nil
		}
		d,e := Divide(q.X, p.X, base)
		if e != nil {
			return false,e
		}
		return d*p.Y%base == q.Y,nil
	}
	if q.IsInfty() {
		return false,nil
	}
	return p.X == q.X && p.Y == q.Y,nil
}

func (p *ProjPoint) HX() (int, error) {
	if p.IsInfty() {
		return 0, fmt.Errorf("elliptic: infinity cannot be homogeneous")
	}
	return Divide(p.X, p.Z, base)
}

func (p *ProjPoint) HY() (int, error) {
	if p.IsInfty() {
		return 0, fmt.Errorf("elliptic: infinity cannot be homogeneous")
	}
	return Divide(p.Y, p.Z, base)
}

func (p *ProjPoint) BelongsTo(a int, b int) bool {
	if p.IsInfty() {
		return p.X == 0 && p.Y == 1 && p.Z == 0
	}
	return (p.X*p.X*p.X+a*p.X*p.Z*p.Z+b*p.Z*p.Z*p.Z-p.Y*p.Y*p.Z)%base == 0
}

var a, b int

func A() int {
	return a
}

func SetA(a_ int) {
	a = a_
}

func B() int {
	return b
}

func SetB(b_ int) {
	b = b_
}

type ElliPoint struct {
	ProjPoint
}

func NewElliPoint(c ...int) (*ElliPoint, error) {
	p, e := NewProjPoint(c...)
	if e != nil {
		return nil, fmt.Errorf("elliptic: invalid projection\n%s", e)
	}
	if !p.BelongsTo(a, b) {
		return nil, fmt.Errorf("elliptic: point out of curve (%d,%d)", a, b)
	}
	return &ElliPoint{*p},nil
}

var ElliInfty *ElliPoint

func init() {
	ElliInfty = &ElliPoint{ProjPoint{Point{X: 0, Y: 1, Z: 0}}}
}

func (p *ElliPoint) Opp() *ElliPoint {
	if p.IsInfty() {
		return ElliInfty
	}
	x,_ := p.HX()
	y,_ := p.HY()
	q,_ := NewElliPoint(x,-y%base)
	return q
}

func (p *ElliPoint) Star(q *ElliPoint) *ElliPoint {
	if p.IsInfty() {
		return q.Opp()
	}
	if q.IsInfty() {
		return p.Opp()
	}
	x,_ := p.HX()
	y,_ := p.HY()
	var k, l int
	equal,_ :=p.Equals(&q.ProjPoint)
	if equal {
		l,_ = Divide(3*x*x+a, 2*y, base)
		k = l*l - 2*x
		r,_ := NewElliPoint(k, l*(k-x)+y)
		return r
	}
	x_,_ := q.HX()
	y_,_ := q.HY()
	if x == x_ {
		return ElliInfty
	}
	l,_ = Divide(y_-y, x_-x, base)
	k = l*l - x - x_
	r,_ := NewElliPoint(k, l*(k-x)+y)
	return r
}

func (p *ElliPoint) Plus(q *ElliPoint) *ElliPoint {
	return ElliInfty.Star(p.Star(q))
}

func (p *ElliPoint) Minus(q *ElliPoint) *ElliPoint {
	return p.Plus(q.Opp())
}

func (p *ElliPoint) Times(n int) *ElliPoint {
	if n == 0 {
		return ElliInfty
	}
	if n < 0 {
		return p.Opp().Times(-n)
	}
	return p.Plus(p.Times(n - 1))
}
