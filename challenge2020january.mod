// This is an OPL CPLEX CPOptimizer solution to the IBM
// Ponder this challenge January 2020
//
// http://www.research.ibm.com/haifa/ponderthis/challenges/January2020.html
//
// CPLEX : https://www.ibm.com/analytics/cplex-optimizer
//
// other challenges I solved with OPL CPLEX :
// https://www.linkedin.com/pulse/puzzles-having-fun-useful-mathematics-alex-fleischer/
 
// use Constraint Programming instead of Linear Programming 
using CP;

// time limit 120 seconds
execute
{
  cp.param.timelimit=120;  
}

int nbBarrels=12;
range barrels=1..nbBarrels;

int nbDays=3;
range days=1..nbDays;
range daysplusone=1..nbDays+1;
int maxDeaths=4;

range orchids=1..maxDeaths;

tuple t
{
  int i;
  int j;
}

// lethal barrels options
{t} poison={<i,j> | ordered i,j in barrels};

assert card(poison)==nbBarrels*(nbBarrels-1)/2;

// decision variables

// do we throw orchid o day 2 in the barrel b ?
dvar boolean x[orchids][days][barrels];

// out of x we compute

// poison option p kills orchid o day d ?
dvar boolean kill[poison][orchids][days];

// which day will an orchid die with posison option p ? 
dvar int+ daydie[orchids][poison] in daysplusone;


// objective : improve human understanding
minimize sum(o in orchids,d in days, b in barrels) x[o,d,b];
subject to
{
  
  // compute kill out of x
  forall(p in poison,o in orchids,d in days) kill[p][o][d]==
  ((x[o][d][p.i]==1) || (x[o][d][p.j]==1));
 
  // compute daydie out of kill
  forall(p in poison, o in  orchids) (kill[p][o][1]==1) => (daydie[o][p]==1);
  forall(p in poison, o in  orchids) ((kill[p][o][1]==0) && (kill[p][o][2]==1)) => (daydie[o][p]==2);
  forall(p in poison, o in  orchids) ((kill[p][o][1]==0) && (kill[p][o][2]==0) && (kill[p][o][3]==1)) => (daydie[o][p]==3);
  forall(p in poison, o in  orchids) ((kill[p][o][1]==0) && (kill[p][o][2]==0) && (kill[p][o][3]==0)) => (daydie[o][p]==4);

  // in order to spot the 2 poisons, all poisons should give different daydie information
  forall(ordered a,b in poison) or(o in orchids) (daydie[o][a]!=daydie[o][b]);
  
}  

// DISPLAY SOLUTION
string names[barrels]=["A","B","C","D","E","F","G","H","I","J","K","L"];
{string} chosenBarrels[o in orchids][d in days]={names[b] | b in barrels:x[o][d][b]==1};

execute
{
  for(var o in orchids)
  {
    for(var d in days)
    {
      for(var cb in chosenBarrels[o][d]) write(cb);
      if (d!=nbDays) write(".");
    }
    write(";");
  }
}
