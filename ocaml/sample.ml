open Elliptic
let f = 7
let a = 2
let b = 1
let p = P(1,2)
let () = print_point f p
let m = mul a f
let q = sum a f (m (m p 3) 6) p
let () = print_point f q

