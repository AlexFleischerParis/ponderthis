/*

A wheel of choice is marked with the numbers 1,2,...,n, and a prize is associated with each number.

A player faced with the wheel chooses some number q and starts spinning the wheel k times. On each spin, 
the wheel moves forward q steps in a clockwise direction and the number / prize reached is eliminated 
from the wheel (i.e., the player does not get it). After k such spins, all the prizes remaining 
on the wheel are gifted to the player.
At the beginning, the wheel's arrow points between 1 and n. If the wheel reaches the number t,
 t is removed from the wheel, the size of the remaining numbers are readjusted and evenly spaced,
  and the arrow is moved to the point in between t's left and right neighbors. Each step moves the wheel 
  a little less than one number forward (so the wheel comes to rest on a number and not between two). 
  So, if the wheel is right before 1 and performs 3 steps, it ends up on 3.
  
For a given n, we call a set of k numbers unwinnable if no matter what q the player chooses, 
he will not be able to win exactly this set after n-k spins. 
The game show wants to know the unwinnable sets of a given n to avoid handing out the best prizes.

Your goal: Find an n such that there is a set of unwinnable numbers for seven steps (i.e., the set is of size n-7). In your answer, supply the number n and the elements of the unwinnable set.

*/
int n=...;  
int k=n-7;
int nbspins=7;
int start=1;
range spins=1..nbspins;

// max times we play
int maxq=...;

// how many times do we play
range rq=1..maxq; 

{int} s[q in rq]=asSet(1..n);

execute
{
  
  for(var q in rq)
  {
     var current=start;
     for(sp in spins)
     {
       
       current=Opl.prevc(s[q],current);
       current=Opl.nextc(s[q],current,q);
       
       var newcurrent=Opl.nextc(s[q],current);
       s[q].remove(current);
       current=newcurrent;
       
     }
   }  
}

tuple compt
{
  int a;
  int b;
  int c;
  int d;
  int e;
  int f;
  int g;
  
}

{int} comps[q in rq]=asSet(1..n) diff s[q];

sorted {compt} compwinnable={<item(comps[q],0),item(comps[q],1),item(comps[q],2),
item(comps[q],3),item(comps[q],4),item(comps[q],5),
item(comps[q],6)> | q in rq};

int fact[i in 1..n-k]=prod(j in 2..i) j;
 
int res=(prod(j in k+1..n) j) div fact[n-k];

execute
{
  writeln("non winnable size = ",res-compwinnable.size);
}

{compt} combinations={<e1,e2,e3,e4,e5,e6,e7> | ordered e1,e2,e3,e4,e5,e6,e7 in 1..n};
 
{compt} compunwinnable=combinations diff compwinnable;
 
{int} unwinnable[i in compunwinnable]=asSet(1..n) diff {i.a,i.b,i.c,i.d,i.e,i.f,i.g};

// display of unwinnable rewards 
 execute
 {
   writeln("unwinnable : ",unwinnable);
 }
 
 // Loop where we try different n and q
 main
 {
   var maxq=1000;
   for(var n=10;n<=30;n++)
   for(var maxq=1000;maxq<=10000000;maxq*=10)
   {
     writeln("n=",n);
     writeln("maxq=",maxq);
     var opl = new IloOplModel(thisOplModel.modelDefinition,cplex);
     var data2= new IloOplDataElements();
     data2.n=n;
     data2.maxq=maxq;
     opl.addDataSource(data2);
     opl.generate();
     if (opl.res-opl.compwinnable.size==0) maxq=10000000;
     else if (maxq==10000000)
     {
       fail();
     }
   }
 }
 
 /*
 
 gives
 
 non winnable size = 2
unwinnable :  [{4 5 6 7 10 13 14 15 16 17 18 19 20} {1 2 3 4 5 6 7 8 11 14 15 16 17}]

*/


