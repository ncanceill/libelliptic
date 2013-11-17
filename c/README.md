# libelliptic

This is a [C](http://www.open-std.org/jtc1/sc22/wg14/) ANSI library implementing elliptic curves.

## Basic usage

Choose a `base` parameter for your arithmetic operations (a large prime number), and create a point on the curve:

````c
int base = 7;
ElliPoint *p = ElliPt(1,2,base);
printf("(%d,%d)\n",p->x,p->y); //prints "(1,2)"
````

Choose the `a` parameter for your curve, and start playing:

````c
int a = 2;
ElliPoint *q = mul(p,3,a,base);
printf("(%d,%d)\n",q->x,q->y); //prints "(0,6)"
ElliPoint *s = sum(p,q,a,base);
````

## Getting started

Compile the `elliptic.c` file, and use the headers and object files to compile your program, or link the object file to a library. You can do this either by using the included Makefile, or with you own favorite C flags and compiler.

You can check the _non-singularity_ of the curve like this:

````c
int base = 7;
int a = 2;
int b = 1;
if (mod(4*a*a*a+27*b*b,base) == 0) {
	printf("non-singular!\n");
}
````

## Documentation

Documentation is not available yet.

## License information

GCC distributes under [GNU General Public License](http://www.gnu.org/licenses/gpl.html), CLang distributes under [NCSA License](http://opensource.org/licenses/NCSA).

This project, including this README, distributes under [GNU General Public License v3](https://github.com/ncanceill/libelliptic/blob/master/LICENSE.md) from the Free Software Foundation.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

***

Copyright (c) 2013 Nicolas Canceill

