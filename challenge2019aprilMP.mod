/*

Find nine different prime numbers that can be placed in a 3x3 square 
in such a way that the average of every row, 
column, and diagonal is also a prime number.

*/

    int m=200;
    range r=1..m;

    // array to know whether a number is prime
    int prime[i in r]=(i!=1) &&and(j in 2..ftoi(ceil(sqrt(i-1)))) (0!=i mod j); // is prime ?

    // set of primes    
    {int} primes={i | i in r : 1==prime[i]};

    // the value is each cell of the 3*3 square
    dvar int x[1..3,1..3] in 1..m;
    dvar int averagetimes3;
    dvar int average;

    subject to
    {

    // all Different
    forall(i,j,i2,j2 in 1..3:(i!=i2) || (j!=j2)) x[i][j]!=x[i2][j2];

    // 9 primes
    forall(i,j in 1..3) 1<=sum(p in primes ) (x[i,j]==p);

    // sum of rows, columns and diagonals
    forall(i in 1..3) averagetimes3==sum(j in 1..3) x[i][j];
    forall(j in 1..3) averagetimes3==sum(i in 1..3) x[i][j];
    averagetimes3==sum(i in 1..3) x[i][i];
    averagetimes3==sum(i in 1..3) x[i][4-i];

    // that sum should be a multiple of 3
    averagetimes3 ==3 * average;
    // and prime
    1<=sum(p in primes ) (p==average);
    } 
    
    /*
    
    which gives
    
    x = [[103
             7 109]
             [79 73 67]
             [37 139 43]];
averagetimes3 = 219;
average = 73;

*/
