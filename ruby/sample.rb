require './elliptic.rb'

Point.base = 7
printf "Prime base: %d\n", Point.base
ElliPoint.curve_set(2, 1)
printf "Elliptic curve: (%d,%d)\n", ElliPoint.a, ElliPoint.b
p = ElliPoint.new 1,2
printf "P: %s\n", p.to_s
q = p * 3 * 6
q += p
printf "Q = P*3*6+P: %s\n", q.to_s

