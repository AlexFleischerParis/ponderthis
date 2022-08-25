using CP;

int n=10;
range r=1..n;

int start[r]=[855661, 1395050, 1402703, 1575981, 2956165, 
4346904, 5516627, 5693538, 6096226, 7359806];

int nbsteps=20;
range steps0=0..nbsteps;
range steps=1..nbsteps;

// values in each cell at a given step
dvar int+ x[steps0][r] ; 
// size of the move at a given step
dvar int+ move[steps];


dvar int o[steps] in r; // origin at a given step
dvar int d[steps] in r; // destination at a given step


// Search phase for branching on o and d
execute {
var f = cp.factory;

var phase1 = f.searchPhase(o); 
 var phase2 = f.searchPhase(d);          

cp.setSearchPhases(phase1,phase2);

}


minimize min(i in r) (x[nbsteps][i]);
subject to
{
  // step 0
  forall(i in r) x[0][i]==start[i] ;

  // additional constraint to limit growth
  forall(i in r) count(d,i)<=3;
  
  forall(s in steps)
    {
      // origin is not destination
      o[s]!=d[s];
      
      // we move cells from step s-1 and d
      move[s]==x[s-1][d[s]];
      // and we add them to step s d
      x[s][d[s]]==x[s-1][d[s]]+move[s];
      // that we take from step s o
      x[s][o[s]]==x[s-1][o[s]]-move[s];
      
      // if no origin nor destination then no change
      forall(i in r) ((i!=o[s]) && (i!=d[s])) => (x[s][i]==x[s-1][i]);
       //x[s][d[s]]==2*x[s-1][d[s]]; // redundant
      

    }
    
     
    
}

assert forall(s in steps) x[s][d[s]]==2*x[s-1][d[s]];
assert forall(s in steps) sum(i in r) x[s][i]==sum(i in r) start[i];

execute display_solution
{
  
  function f(X,Y)
  {
   
    if (X<Y) return -1;
    else if (X==Y) return 0;
    else return 1;
  }
  
  write("[");
  for(var s in steps0)
  {
    var ar=new Array(n);
    for(var i in r) ar[i-1]=x[s][i];
    ar.sort(f);
    write("(");
    for(var i in r) 
    {
       write(ar[i-1]); 
       if (i!=n) write(",");
    }
    writeln("),");
  }
  writeln("]");
}

execute
{
  writeln();
  writeln("o=",o);
  writeln("d=",d);
}


/*

That gives

subo= [9 8 7 6 6 8 7 8 10 10 7 3]
subd= [6 9 3 8 3 7 3 6 7 8 10 7]
subzerocell = 3
subnbsteps=12

*/

/*

[(855661,1395050,1402703,1575981,2956165,4346904,5516627,5693538,6096226,7359806),
(855661,1402703,1575981,2790100,2956165,4346904,5516627,5693538,5964756,6096226),
(855661,1387397,1575981,2805406,2956165,4346904,5516627,5693538,5964756,6096226),
(579599,855661,1387397,1575981,2805406,2956165,4346904,5693538,5964756,11033254),
(531736,579599,1575981,1711322,2805406,2956165,4346904,5693538,5964756,11033254),
(531736,579599,1380184,1711322,2805406,3151962,4346904,5693538,5964756,11033254),
(531736,800585,1159198,1711322,2805406,3151962,4346904,5693538,5964756,11033254),
(531736,800585,1711322,2318396,2805406,3151962,3187706,5693538,5964756,11033254),
(531736,607074,800585,2805406,3151962,3187706,3422644,5693538,5964756,11033254),
(531736,800585,1214148,2544888,2805406,3187706,3422644,5693538,5964756,11033254),
(260518,531736,800585,1214148,3187706,3422644,5089776,5693538,5964756,11033254),
(271218,521036,800585,1214148,3187706,3422644,5089776,5693538,5964756,11033254),
(271218,271218,521036,800585,1214148,3187706,3422644,5089776,11033254,11387076),
(0,521036,542436,800585,1214148,3187706,3422644,5089776,11033254,11387076),
(0,521036,542436,800585,1214148,3187706,3422644,5089776,11033254,11387076),
(0,542436,693112,800585,1042072,3187706,3422644,5089776,11033254,11387076),
(0,542436,693112,800585,1042072,3187706,3422644,5089776,11033254,11387076),
(0,542436,693112,1042072,1601170,3187706,3422644,5089776,10232669,11387076),
(0,542436,693112,1042072,3187706,3202340,3422644,5089776,8631499,11387076),
(0,220304,542436,693112,1042072,3187706,5089776,6404680,8631499,11387076),
(0,220304,542436,693112,1042072,3187706,3541723,6404680,10179552,11387076),
]

o= [10 2 9 2 5 5 6 9 4 3 2 10 2 10 9 9 7 7 1 7]
d= [2 3 7 1 4 9 9 1 9 4 3 8 10 2 3 2 5 5 5 4]

*/

