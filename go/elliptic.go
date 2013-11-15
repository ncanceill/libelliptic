package elliptic

import "fmt"

func Expo(x int, y int, base int) int {
	x_, y_ := x%base, y%base
	if y_ == 0 {
		return 1
	}
	xp := Expo(x_, y_/2, base)
	if y_%2 == 0 {
		return xp * xp % base
	}
	return x_ * xp * xp % base
}

func Inverse(n int, base int) (int, error) {
	n_ := n % base
	if n_ == 0 {
		return 0, fmt.Errorf("elliptic: divided by zero modulo %d", base)
	}
	return Expo(n_, base-2, base), nil
}

func Divide(n int, q int, base int) (int, error) {
	return n * Inverse(q, base) % base
}

var base int

func base() int {
	return base
}

func setBase(b int) {
	base = b
}

type Point struct {
	X, Y, Z int
}

func NewPoint(x int, y int, z int) *Point {
	return &Point{X: x % base, Y: y % base, Z: z % base}
}

func (p *Point) Equals(q *Point) bool {
	return p.X == q.X && p.Y == q.Y && p.Z == q.Z
}

type ProjPoint struct {
	Point
}

func NewProjPoint(c ...int) (*ProjPoint, error) {
	if len(slice) < 2 {
		return nil, fmt.Errorf("elliptic: a projpoint needs X and Y")
	}
	var z int
	if len(slice) < 3 {
		z = 1
	} else {
		z = c[2]
	}
	p := NewPoint(c[0], c[1], z)
	if (p.X + p.Y + p.Z) == 0 {
		return nil, fmt.Errorf("elliptic: point (0,0,0) is not projective")
	}
	return &ProjPoint{p}
}

func (p *ProjPoint) IsInfty() bool {
	return p.Z == 0
}

func (p *ProjPoint) Equals(q *ProjPoint) bool {
	if p.IsInfty() {
		if !q.IsInfty() {
			return false
		}
		if p.X == 0 {
			return q.X == 0
		}
		return Divide(q.X, p.X, base)*p.Y%base == q.Y
	}
	if q.IsInfty() {
		return false
	}
	return p.X == q.X && p.Y == q.Y
}

func (p *ProjPoint) X() (int, error) {
	if p.IsInfty() {
		return 0, fmt.Errorf("elliptic: infinity cannot be homogeneous")
	}
	return Divide(p.X, p.Z, base)
}

func (p *ProjPoint) Y() (int, error) {
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
	p, e := NewProjPoint(c)
	if e != nil {
		return nil, fmt.Errorf("elliptic: invalid projection\n%s", e)
	}
	if !p.BelongsTo(a, b) {
		return nil, fmt.Errorf("elliptic: point out of curve (%d,%d)", a, b)
	}
	return &ElliPoint{p}
}

const ElliInfty *ElliPoint = NewElliPoint(0, 1, 0)

func (p *ElliPoint) Opp() *ElliPoint {
	if p.IsInfty() {
		return ElliInfty
	}
	return NewElliPoint(p.X(), -p.Y())
}

func (p *ElliPoint) Star(q *ElliPoint) *ElliPoint {
	if p.IsInfty() {
		return q.Opp()
	}
	if q.IsInfty() {
		return p.Opp()
	}
	x := p.X()
	y := p.Y()
	var k, l int
	if p.Equals(q) {
		l = Divide(3*x*x+a, 2*y, base)
		k = l*l - 2*x
		return NewElliPoint(k, l*(k-x)+y)
	}
	x_ := q.X()
	y_ := q.Y()
	if x == x_ {
		return ElliInfty
	}
	l = Divide(y_-y, x_-x, base)
	k = l*l - x - x_
	return NewElliPoint(k, l*(k-x)+y)
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
