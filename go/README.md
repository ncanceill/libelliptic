# libelliptic

This is a [Go](http://golang.org) library implementing elliptic curves.

## Basic usage

Create a point on the curve:

````go
p, _ := elliptic.NewElliPoint(1, 2)
fmt.Println(p) //prints "1,2,1"
````

Play with it:

````go
q := p.Times(3).Times(6)
q = q.Plus(p)
fmt.Println(q) //prints "1,5,1"
````

## Getting started

Import the library:

````go
import "/path/to/elliptic.rb"
````

Just set the `Base` of the projective space (a large prime number), the `A` and `B` parameters of the curve, and you are good to go:

````go
elliptic.SetBase(7)
elliptic.SetA(2)
elliptic.SetB(1)
````

You can check the _non-singularity_ of the curve like this:

````go
elliptic.Abs(4*a*a*a+27*b*b, base) == 0 // returns false
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

