// http://burningmath.blogspot.com/2013/09/magic-age-cards-age-prediction-trick.html

using CP;

int n=6; // nb cards
range r=1..n;

range r2=1..63; // numbers

dvar boolean x[r][r2]; // is the number in the card ?
dvar int mincard[r] in r2; // minimum number on a given card


subject to
{
  // all numbers should have a unique set of answers
  forall(ordered i,j in r2) or(k in r) x[k][i]!=x[k][j];
  
  // compute mincard
  forall(i in r) x[i][mincard[i]]==1;
  forall(i in r) forall(j in r2) (j<mincard[i]) => x[i][j]==0;
  
  forall(i in r2) i==sum(j in r) mincard[j]*x[j][i];
  
  // break sym
  forall(i in r:i!=1) mincard[i-1]<=mincard[i];
}

{int} cards[i in r]={j | j in r2 : x[i][j]==1};

execute
{
  for(var i in r)
  writeln("card ",i," : ",cards[i]);
}

/*

which gives

card 1 :  {1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 37 39 41 43 45 47 49 51 53
     55 57 59 61 63}
card 2 :  {2 3 6 7 10 11 14 15 18 19 22 23 26 27 30 31 34 35 38 39 42 43 46 47 50 51
     54 55 58 59 62 63}
card 3 :  {4 5 6 7 12 13 14 15 20 21 22 23 28 29 30 31 36 37 38 39 44 45 46 47 52 53
     54 55 60 61 62 63}
card 4 :  {8 9 10 11 12 13 14 15 24 25 26 27 28 29 30 31 40 41 42 43 44 45 46 47 56 57
     58 59 60 61 62 63}
card 5 :  {16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 48 49 50 51 52 53 54 55 56
     57 58 59 60 61 62 63}
card 6 :  {32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56
     57 58 59 60 61 62 63}
     
     */



