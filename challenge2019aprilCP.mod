/*

Find nine different prime numbers that can be placed in a 3x3 square 
in such a way that the average of every row, 
column, and diagonal is also a prime number.

*/

using CP;

int m=200;
range r=1..m;

// array to know whether a number is prime
int prime[i in r]=(i!=1) &&and(j in 2..ftoi(ceil(sqrt(i-1)))) (0!=i mod j); // is prime ?

// set of primes    
{int} primes={i | i in r : 1==prime[i]};

// the value is each cell of the 3*3 square
dvar int x[1..3,1..3] in 1..m;
dvar int averagetimes3;

subject to
{

// all Different
allDifferent(x);

// 9 primes
forall(i,j in 1..3) x[i,j] in primes;

// sum of rows, columns and diagonals
forall(i in 1..3) averagetimes3==sum(j in 1..3) x[i][j];
forall(j in 1..3) averagetimes3==sum(i in 1..3) x[i][j];
averagetimes3==sum(i in 1..3) x[i][i];
averagetimes3==sum(i in 1..3) x[i][4-i];

// that sum should be a multiple of 3
averagetimes3 mod 3==0;
// and prime
(averagetimes3 div 3) in primes;
} 

/*

which gives

x = [[41 89 83]
             [113 71 29]
             [59 53 101]];
averagetimes3 = 213;

*/
