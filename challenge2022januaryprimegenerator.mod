int m=100000; 
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

{int} primes=asSet(r) diff nonPrimes;

// remove less than 5 figures primes
{int} primes2={i | i in primes : (i>=10000) };

tuple t
{
  int d1;
  int d2;
  int d3;
  int d4;
  int d5;
}

// turn into figures
{t} primes3;

execute
{
  for(var i in primes2)
  {
    
    var n=i;
    d1=Opl.floor(n / 10000);
    n=n-d1*10000;
    d2=Opl.floor(n / 1000);
    n=n-d2*1000;
    d3=Opl.floor(n / 100);
    n=n-d3*100;
    d4=Opl.floor(n / 10);
    n=n-d4*10;
    d5=n;
    primes3.add(d1,d2,d3,d4,d5);
  }
}

assert forall(i in primes3) 0<=i.d5<=9;

// 5 different figures
{t} primes4={<d1,d2,d3,d4,d5> | <d1,d2,d3,d4,d5> in primes3 : allDifferent(append(d1,d2,d3,d4,d5)) };

execute
{
  var o=new IloOplOutputFile("challenge2022januaryprimes.dat");
  o.writeln("primes="),
  o.writeln(primes4);
  o.writeln(";");
  o.close();
}
