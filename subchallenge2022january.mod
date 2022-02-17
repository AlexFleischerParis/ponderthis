tuple t
{
  int d1;
  int d2;
  int d3;
  int d4;
  int d5;
}

// turn into figures
{t} primes=...;

int circle[1..7]=...;

{int} figures={circle[i] | i in 1..7};

assert card(figures)==7;

{t} filteredPrimes={<d1,d2,d3,d4,d5> | <d1,d2,d3,d4,d5> in primes : 
(d1 in figures) && (d2 in figures) && (d3 in figures) && (d4 in figures) 
&& (d5 in figures) };

int distance[f1 in figures][f2 in figures]=
ftoi(minl(abs(ord(figures,f1)-ord(figures,f2)),abs(7-abs(ord(figures,f1)-ord(figures,f2)))));

int score=sum(<d1,d2,d3,d4,d5> in filteredPrimes)
(distance[d1,d2]+distance[d2,d3]+distance[d3,d4]+distance[d4,d5]);





