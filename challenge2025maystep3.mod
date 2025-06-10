/*
Step 3 : use Constraint Programming (screwdriver) 
to compute p
*/
 
 using CP;


int m=1000000;
    range r=1..m;
   
    

    {int} nonPrimes;


    // Eratosthenes
    execute
    {
    for(var i in r) if (i!=1)
     if (!nonPrimes.contains(i))
        {
          j=2*i;
          while (j<=m)
          {
            nonPrimes.add(j);
            j=j+i;      
          }    
        }

    }

{int} primes=asSet(r) diff nonPrimes diff {1};

range persons=1..8;
int nbquestions=10;
range questions=1..nbquestions;

int x[persons]=...;;
dvar int p in 1..10000;
int answers[questions]=...;

subject to
{
  p in primes;
  
  (x[1]*x[2]*x[3]*x[4]*x[5]*x[6]*x[7]*x[8] ) mod p==answers[9];
  (x[1]*x[3]*x[5]*x[7] ) mod p==answers[10];
  
}

execute
{
  writeln("p=",p);
}
