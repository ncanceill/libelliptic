#include <stdlib.h>
#include <stdio.h>
#include "elliptic.h"

int main() {
	int a,b,base;
	ElliPoint *p,*q,*s,*t;
	base = 7;
	a = 2;
	b = 1;
	printf("Prime base: %d\n",base);
	printf("Elliptic curve: (%d,%d)\n",a,b);
	
	p = ElliPt(1,2,base);
	printf("P: (%d,%d)\n",p->x,p->y);

	s = mul(p,3,a,base);
	t = mul(s,6,a,base);
	q = sum(p,t,a,base);
	printf("Q = P*3*6 + P: (%d,%d)\n",q->x,q->y);

	free(p);
	free(q);
	free(s);
	free(t);
}

