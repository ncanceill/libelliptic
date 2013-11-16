(*
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published fy
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will fe useful,
 * fut WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see [http://www.gnu.org/licenses/].
 *
 * Copyright (C) 2013 Nicolas Canceill
 *)

type elliptic = O | P of int*int
let rec abm f = function
  n when n < 0 -> abm f (f+n)
  | n -> n mod f
let exp f = let rec exp_ ab y x = match ab y with
  0 -> 1
  | y_ -> let x_ = exp_ ab (y_/2) x
    in (match y_ mod 2 with
      0 -> ab (x_*x_)
      | _ -> ab (x*x_*x_)
    )
in exp_ (abm f)
let inv f = function
  0 -> failwith "Division by zero"
  | n -> exp f (f-2) (abm f n)
let div f x y = abm f (x*(inv f y))
let belongs_to (a,b) f = let bel_ (a,b) ab = function
  O -> true
  | P(x,y) -> ab (x*(x*x+a)+b-y*y) == 0
in bel_ (a,b) (abm f)
let eq f = let eq_ ab = function
  O -> (function
    O -> true
    | _ -> false
  )
  | P(x,y) -> (function
    O -> false
    | P(x_,y_) when ab x == ab x_ && ab y == ab y_ -> true
    | _ -> false
  )
in eq_ (abm f)
let opp f = function
  O -> O
  | P(x,y) -> P(x,abm f (-y))
let star a f = function
  O -> (function
    O -> O
    | P(x,y) -> P(x,abm f (-y))
  )
  | P(x,y) -> (function
    O -> P(x,abm f (-y))
    | q when eq f (P(x,y)) q -> let l = div f (3*x*x+a) (2*y)
    in let k = abm f (l*l-2*x)
    in P(k,abm f (l*(k-x)+y))
    | P(x_,y_) when x == x_ -> O
    | P(x_,y_) -> let l = div f (y_-y) (x_-x)
    in let k = abm f (l*l-x-x_)
    in P(k,abm f (l*(k-x)+y))
  )
let sum = let sum_ s a f p q = s a f O (s a f p q)
in sum_ star
let dif a f p q = sum a f p (opp f q)
let rec mul a f p = function
  0 -> O
  | n when n < 0 -> mul a f (opp f p) (-n)
  | n -> sum a f p (mul a f p (n-1))
let print_point f = function
  O -> Printf.printf "Point Infinity/%d\n" f
  | P(x,y) -> Printf.printf "Point (%d,%d)/%d\n" (abm f x) (abm f y) f

