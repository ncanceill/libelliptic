# libelliptic

This is a [Python](http://python.org) library implementing elliptic curves.

## Basic usage

Create a point on the curve:

````python
>>> p = ElliPoint(1,2)
>>> print(str(p))
ElliPoint(1, 2)
````

Play with it:

````python
>>> q = p * 3 * 6
>>> q = p + q
>>> print(str(q))
ElliPoint(1, 5)
````

## Getting started

Import the library (CWD must be the parent of the "elliptic" dir):

````python
>>> from elliptic import elliptic
````

Package coming soon!

Just set the `base` of the projective space (a large prime number), the `a` and `b` parameters of the curve, and you are good to go:

````python
>>> Point.base = 7
>>> ElliPoint.curve_set(2, 1)
````

You can check the _non-singularity_ of the curve like this:

````python
>>> ( 4 * ElliPoint.a**3 + 27 * ElliPoint.b**2 ) % Point.base == 0
  => false 
````

## Documentation

Coming soon!

## Contribution

General rule: any contributions are welcome.

Do not hesitate to [drop an issue](https://github.com/ncanceill/libelliptic/issues/new) if you found a bug, if you either want to see a new feature or wish to suggest an improvement, or even if you simply have a question.

## License information

This project, including this README, distributes under [GNU General Public License v3](https://github.com/ncanceill/libelliptic/blob/master/LICENSE.md) from the Free Software Foundation.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

***

Copyright (c) 2013 Nicolas Canceill

