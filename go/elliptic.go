package elliptic

import "fmt"

func expo(x int, y int, base int) int {
	x_, y_ := x%base, y%base
	if y_ == 0 {
		return 1
	}
	xp := expo(x_, y_/2, base)
	if y_%2 == 0 {
		return xp * xp % base
	}
	return x_ * xp * xp % base
}

func inverse(n int, base int) (int, error) {
	n_ := n % base
	if n_ == 0 {
		return 0, fmt.Errorf("elliptic: divided by zero modulo %d", base)
	}
	return expo(n_, base-2, base), nil
}

func divide(n int, q int, base int) (int error) {
	return n * inverse(q, base) % base
}

type Point struct {
	x int
	y int
	z int
}

func NewPoint(x_ int, y_ int, z_ int) *Point {
	return &Point{x: x_ % base, y: y_ % base, z: z_ % base}
}
