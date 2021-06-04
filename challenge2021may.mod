/*

May 2021 IBM ponder this challenge

https://www.research.ibm.com/haifa/ponderthis/challenges/May2021.html

*/ 
 
 using CP;
 int t=18;
 range K=1..t;
 int maxf=70;
 
 int maxv=1000000;
 range r=1..maxv;
 
 
 
 float F[0..maxf];
 
 
 // compute Fibonacci numbers
 execute
 {
   F[0]=0;
   F[1]=1;
   for(var i=2;i<=maxf;i++) F[i]=F[i-1]+F[i-2];
 }
 
tuple mandprime
{
  int m;
  int primes;
}


{int} possiblems;

 
execute
{
   for(var i=2;i<=maxf;i++)
   {
     // check whether i is only a product of 2,3, and 5s
     var v=i;
     while (v % 2==0) v=v/2;
     while (v % 3==0) v=v/3;
     while (v % 5==0) v=v/5;
     if (v==1)
     {
       possiblems.add(i);
     }
   }
}
 
 
 
range rprime=1..10000; 
 
{int} nonPrimes;


// Eratosthenes
execute
{
  for(var i in rprime) if (i!=1)
     if (!nonPrimes.contains(i))
        {
          j=2*i;
          while (j<=maxv)
          {
            nonPrimes.add(j);
            j=j+i;      
          }    
        }

}

{int} primes=asSet(rprime) diff nonPrimes diff {1};

{mandprime} possiblemandprimes = {<m,p> | m in possiblems, p in primes: ceil(F[m] / p)*p==F[m]};

dvar int m[K] in  2..100;
 
 dvar int a[K] in 1..maxv;
 
 int smallM=1000;
 
 dvar int p[K] in 2..100000;
 dvar int obj;
 minimize obj;
 subject to
 {
   
   
  
   forall(k in K)
     {
       1<=a[k];
       a[k]<=m[k];
       p[k] in primes;
     }
     
     // For every natural number n, we have that for some k, 
     // n is equivalent to a_k modulo m_k (i.e. m_k divides n-a_k )
     
     // Instead of every natural number let us use 1000 and then check 
     // later with many more
     obj==smallM-sum(n in 1..smallM) or(k in K) ((n-a[k]) mod m[k]==0);
     

    allDifferent(p);
    
    forall(k in K) allowedAssignments(possiblemandprimes,m[k],p[k]);
 }
 
 execute
 {
   writeln("m=",m);
   writeln("a=",a);
   writeln("p=",p);
 }
 
 // Let s double check
 int M=10000000;
 int check=sum(n in 1..M) or(k in K) ((n-a[k]) mod m[k]==0);
 
 execute
 {
   writeln(check);
 }
 
 /*
 
 which gives
 
 m= [27 54 5 48 8 30 25 4 16 27 60 10 15 9 18 24 20 3]
a= [26 44 4 5 1 30 16 3 13 8 36 2 3 5 2 21 6 1]
p= [109 5779 5 1103 7 31 3001 3 47 53 2521 11 61 17 19 23 41 2]
10000000

*/
