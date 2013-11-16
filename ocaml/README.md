# libelliptic

This is a [OCaml](http://ocaml.org) library implementing elliptic curves.

## Basic usage

Create a point on the curve:

````ocaml
let p = P(1,2);;
let () = print_point p;; (* Prints "Point(1,2)" *)
````

Play with it:

````ocaml
let q = m (m p 3) 6;; (* Multiplication *)
let r = s p q;; (* Sum *)
let () = print_point q;; (* Prints "Point(1,5)" *)
````

## Getting started

Open the module:

````ocaml
open Elliptic;;
````

Just set the `base` of the projective space (a large prime number), the `a` and `b` parameters of the curve, and define your functions:

````ocaml
let base = 7;;
let (a,b) = (2,1);;
let s = sum a base;;
let m = mul a base;;
````

You can check the _non-singularity_ of the curve like this:

````ocaml
abm 7 (4*a*a*a+27*b*b) == 0;; (* Must return false *)
````

You can use the Makefile to build the library, or follow detailed steps below.

### Toplevel

You will need to compile and load the library:

````bash
$ ocamlc -c elliptic.mli
$ ocamlc -c elliptic.ml
$ ocaml
# #load "/path/to/elliptic.cmo"
````

### Module

You will need to compile your module against the library, for intance with `sample.ml`:

````bash
$ ocamlc -c elliptic.mli
$ ocamlopt -c elliptic.ml
$ ocamlopt -o elliptic-sample elliptic.ml sample.ml
````

## Documentation

Documentation is not available yet.

## Contribution

General rule: any contributions are welcome.

Do not hesitate to [drop an issue](https://github.com/ncanceill/libelliptic/issues/new) if you found a bug, if you either want to see a new feature or wish to suggest an improvement, or even if you simply have a question.

## License information

This project, including this README, distributes under [GNU General Public License v3](https://github.com/ncanceill/libelliptic/blob/master/LICENSE.md) from the Free Software Foundation.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

***

Copyright (c) 2013 Nicolas Canceill

