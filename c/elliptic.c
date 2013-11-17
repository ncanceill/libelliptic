#include <stdlib.h>
#include <stdio.h>

int mod(int n, int base) {
	int m;
	m = n % base;
	if (m < 0) return -m;
	return m;
}

int expo(int base,int x,int y) {
	int x_,y_,xp;
	x_ = mod(x,base);
	y_ = mod(y,base);
	if (y_ == 0) return 1;
	xp = expo(base,x_,y_/2);
	if (y_ % 2 == 0) {
		return mod(xp * xp,base);
	}
	return mod(x_ * xp * xp,base);
}

int inverse(int base,int n) {
	if (n == 0) return -1;
	return expo(base,n,base-2);
}

int divide(int base,int x,int y) {
	int i;
	i = inverse(base,y);
	if (i == -1) return -1;
	return mod(x * i,base);
}

typedef struct {
	int x,y;
} ElliPoint;

ElliPoint *ElliInfty() {
	ElliPoint *p;
	p = malloc(sizeof(ElliPoint));
	p->x = -1;
	p->y = -1;
	return p;
}

int isInfty(ElliPoint *p) {
	if (p->x == -1 && p->y == -1) return 0;
	return 1;
}

ElliPoint *ElliPt(int x_,int y_,int base) {
	ElliPoint *p;
	p = malloc(sizeof(ElliPoint));
	p->x = mod(x_,base);
	p->y = mod(y_,base);
	return p;
}

int Elli_belongsto(ElliPoint *p,int a,int b,int base) {
	if (p->x == -1) return 0;
	if (mod((p->x) * ((p->x)*(p->x)+a) + b - (p->y)*(p->y),base) == 0) {
		return 0;
	}
	return 1;
}

int Elli_equal(ElliPoint *p,ElliPoint *q,int base) {
	if (p->x == -1 && q->x == -1) return 0;
	if (mod(p->x,base) == mod(q->x,base) && mod(p->y,base) == mod(q->y,base)) {
		return 0;
	}
	return 1;
}

ElliPoint *opp(ElliPoint *p,int base) {
	if (p->x == -1) return ElliInfty();
	return ElliPt(p->x,-(p->y),base);
}

ElliPoint *star(ElliPoint *p,ElliPoint *q,int a,int base) {
	int l,k;
	if (isInfty(p) == 0) return opp(q,base);
	if (isInfty(q) == 0) return opp(p,base);
	if (Elli_equal(p,q,base) == 0) {
		l = divide(3 * (p->x) * (p->x) + a,2 * (p->y),base);
		k = l * l - 2 * (p->x);
		return ElliPt(k,l * (k - (p->x)) + (p->y), base);
	}
	if (mod(p->x,base) == mod(q->x,base)) {
		return ElliInfty();
	}
	l = divide((q->y) - (p->y),(q->x) - (p->x),base);
	k = l * l - (p->x) - (q->x);
	return ElliPt(k,l * (k - (p->x)) + (p->y), base);
}

ElliPoint *sum(ElliPoint *p,ElliPoint *q,int a,int base) {
	ElliPoint *o,*r;
	o = ElliInfty();
	r = star(o,star(p,q,a,base),a,base);
	free(o);
	return r;
}

ElliPoint *dif(ElliPoint *p,ElliPoint *q,int a,int base) {
	ElliPoint *o,*r;
	o = opp(q,base);
	r = sum(p,o,a,base);
	free(o);
	return r;
}

ElliPoint *mul(ElliPoint *p,int n,int a,int base) {
	ElliPoint *q,*r;
	if (n == 0) return ElliInfty();
	if (n < 0) {
		q = opp(p,base);
		r = mul(q,-n,a,base);
		free(q);
		return r;
	}
	q = mul(p,n-1,a,base);
	r = sum(p,q,a,base);
	free(q);
	return r;
}

