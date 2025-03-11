 using CP;
 
 int m=100000;
 range r=1..m;
 int prime[i in r]=(i!=1) &&and(j in 2..ftoi(ceil(sqrt(i-1)))) (0!=i mod j); // is prime ?
 
 // List of prime numbers
 {int} primes={i | i in r : prime[i]==1};
 
 int N=5;
 range rN=1..N;
 
 
 
 dvar int x[1..N][1..N] in 0..9;
 dvar int+ A; // The sum of all columns, rows and diags
 
 dvar boolean takethispintoaccount[2..2*N+2];
 dvar int figuresp[1..2*N+2][1..N] in 0..9; // figures of the primes
 dvar int figuresp2[1..2*N+2][1..N] in 0..10; // figures of the primes to take into account
 dvar int+ freqdigit[0..9];
 
 dvar int+ cost;
 
 execute {
   cp.param.LogVerbosity="Quiet";
   var f = cp.factory;
   // 1 search phase
   cp.setSearchPhases(f.searchPhase(x));
}

tuple t
{
  int i1;
  int i2;
  int i3;
  int i4;
  int i5;
}

{int} rightPrimes={i | i in primes : i in 10000..99999};
{t} rightPrimesTuples;
execute
{
  // Loop to turn rightPrimes into a tuple set
  for(pr in rightPrimes)
  {
    var s=""+pr;
    var i1=s.charAt(0);
    var i2=s.charAt(1);
    var i3=s.charAt(2);
    var i4=s.charAt(3);
    var i5=s.charAt(4);
    rightPrimesTuples.add(i1,i2,i3,i4,i5)
  }
}

// Trick to do the min and max
dvar int plusorminusone in 1..1;
 
// by changing plusorminusone you can turn minimize into maximize and conversely 
minimize plusorminusone*cost;
 
 subject to
 {
   
   // allowed assignments
   forall(i in 1..N*2+2) allowedAssignments(rightPrimesTuples,
   figuresp[i][1], figuresp[i][2], figuresp[i][3], figuresp[i][4], figuresp[i][5]);
 
   forall(i in rN)
     {
       x[i][1]!=0;
       x[1][i]!=0;
     }
   
   // All lines, columns and diagonals lead to the same sum : A
   forall(i in 1..N) A==sum(j in 1..N) x[i][j];
   forall(i in 1..N) A==sum(j in 1..N) x[j][i];
   A==sum(i in 1..N) x[i][i];
   A==sum(i in 1..N) x[i][N+1-i]; 
   
   // Copy the values in figuresp   
   forall(i,j in rN) figuresp[i][j]==x[i][j];
   forall(i,j in rN) figuresp[i+N][j]==x[j][i];
   forall(i in rN,j in rN) figuresp[2*N+1][j]==x[j][j];
   forall(i in rN,j in rN) figuresp[2*N+2][j]==x[j][N+1-j];
   
   // Which numbers are unique ?
   forall(i in 2..2*N+2)
   {
       takethispintoaccount[i]==and(j in 1..i-1) or(k in rN)(figuresp[i][k]!=figuresp[j][k]);
   }
   
   // And then copy values that are unique to figuresp2
   forall(i in rN) figuresp2[1][i]==figuresp[1][i];
   
   forall(i in 2..2*N+2)
      forall(j in 1..N) 
      (takethispintoaccount[i]==1)=>(figuresp2[i][j]==figuresp[i][j]);
      
   forall(i in 2..2*N+2)
      forall(j in 1..N) 
      (takethispintoaccount[i]==0)=>(figuresp2[i][j]==10);
      
   // now let's compute the frequencies   
   forall(i in 0..9) freqdigit[i]==count(figuresp2,i);
   
   // And then count
   cost==sum(i in 0..9) (freqdigit[i]*(freqdigit[i]-1))  div 2;
   
 }
 
 execute display_result
 {
   for(var i in rN )
   {
     for(var j in rN) write(x[i][j]);
     writeln();
   }
  writeln(cost); 
  writeln();
   
 }
 
 main
 {
   // minimize 
   thisOplModel.generate();
   
   cp.solve();
   thisOplModel.postProcess();
   
   // and now maximize
   thisOplModel.plusorminusone.LB=-1;
   thisOplModel.plusorminusone.UB=-1;
   
   cp.solve();
   thisOplModel.postProcess();
   
 }
 
 /*
 
 which gives in less than 3 minutes
 
28643
89051
60737
45329
31793
61
 


17333
41813
33317
23291
73133
488

*/
 
 

   


