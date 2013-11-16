type elliptic = O | P of int * int
val abs : int -> int -> int
val exp : int -> int -> int -> int
val inv : int -> int -> int
val div : int -> int -> int -> int
val belongs_to : int * int -> int -> elliptic -> bool
val eq : int -> elliptic -> elliptic -> bool
val opp : int -> elliptic -> elliptic
val star : int -> int -> elliptic -> elliptic -> elliptic
val sum : int -> int -> elliptic -> elliptic -> elliptic
val dif : int -> int -> elliptic -> elliptic -> elliptic
val mul : int -> int -> elliptic -> int -> elliptic
val print_point : int -> elliptic -> unit

