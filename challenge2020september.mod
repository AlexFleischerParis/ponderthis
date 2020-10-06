// This is an OPL CPLEX CPOptimizer solution to the IBM
// Ponder this challenge September 2020
//
// https://www.research.ibm.com/haifa/ponderthis/challenges/September2020.html
//
// CPLEX : https://www.ibm.com/analytics/cplex-optimizer
//
// other challenges I solved with OPL CPLEX :
// https://www.linkedin.com/pulse/puzzles-having-fun-useful-mathematics-alex-fleischer/
 
// use Constraint Programming instead of Linear Programming 
using CP;

range r=0..8;

range r2=1..4;

int nbPerm=10;
range rPerm=1..nbPerm;

// for all i in r (weapons) the 4 (in r2) other weapons that lose against that weapon
dvar int beats[r][r2] in r; 
// the nbPerm permutations
dvar int perm[rPerm][r] in r;
// results after trandform
dvar int permbeats[rPerm][r][r2] in r;

subject to
{
 // you cannot beat yourself
 forall(i in r) forall(j in r2) beats[i][j]!=i; 
 
 // if a beats b then b cannot beat a
 forall(i in r) forall(j in r2) forall(k in r2) beats[beats[i][j]][k]!=i;
  
 // break sym and all 4 are different
 forall(i in r) forall(j in r2:j!=1) beats[i][j-1]<beats[i][j]; 
 
 // a permutation needs allDiff
 forall(p in rPerm) allDifferent(all(k in r) perm[p][k]);
 
 // permutations should not be doing nothing
 forall(p in rPerm) or(k in r) perm[p][k]!=k;
 
 // and should be different from one another
 forall(ordered p1,p2 in rPerm) or(k in r) perm[p1][k]!=perm[p2][k];
 
 // automorphism
 forall(p in rPerm) forall(i in r) forall(j in r2) permbeats[p][perm[p][i]][j]==perm[p][beats[i][j]];
 forall(p in rPerm) forall(i in r) forall(j in r2) or(k in r2) beats[i][j]==permbeats[p][i][k];
  
}

execute display
{
  for(var i in r)
  {
    write(i," -> ");
    for(var j in r2) 
    { 
    write(beats[i][j]);
    if (j!=4) write(", ");
    }  
    writeln();  
  }
  
  
}

/*

which gives

0 -> 1, 2, 7, 8
1 -> 4, 5, 6, 8
2 -> 1, 3, 7, 8
3 -> 0, 1, 7, 8
4 -> 0, 2, 3, 6
5 -> 0, 2, 3, 4
6 -> 0, 2, 3, 5
7 -> 1, 4, 5, 6
8 -> 4, 5, 6, 7

in less than 1 minute

*/

