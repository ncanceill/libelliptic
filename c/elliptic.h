#ifndef __LIBELLIPTIC_LOADED__
#define __LIBELLIPTIC_LOADED__

int mod(int,int);
int expo(int,int,int);
int inverse(int,int);
int divide(int,int,int);

typedef struct {
	int x,y;
} ElliPoint;

ElliPoint *ElliInfty();
int isInfty(ElliPoint *);

ElliPoint *ElliPt(int,int,int);
int Elli_belongsto(ElliPoint *,int,int,int);
int Elli_equal(ElliPoint *,ElliPoint *,int);

ElliPoint *opp(ElliPoint *,int);
ElliPoint *star(ElliPoint *,ElliPoint *,int,int);
ElliPoint *sum(ElliPoint *,ElliPoint *,int,int);
ElliPoint *dif(ElliPoint *,ElliPoint *,int,int);
ElliPoint *mul(ElliPoint *,int,int,int);

#endif

