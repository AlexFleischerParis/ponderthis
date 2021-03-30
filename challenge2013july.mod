
/*

When you roll three octahedron (eight sided) dice with the sides numbered 1, 4, 16, 64, 256, 1024, 4096, 16384, 
there are 120 different sums which can be produced. The maximal value, in this example, is 16384.
Find the eight positive integers that could number a octahedral die and minimize the maximum value 
of the eight faces, while still resulting in 120 possible sums when three of the dice are rolled.

*/
using CP;

int vmin   = 1;
int vmax   = 130; // 129 => Infeasible for vmax=129
int nfaces = 8;

tuple Combi { int v1; int v2; int v3; }
{Combi} Combis = { <v1,v2,v3> | v1,v2,v3 in 1..nfaces : v1<=v2 && v2<=v3 };

assert(card(Combis) == 120);

dvar int v[1..nfaces] in vmin..vmax;
dvar int total[c in Combis] in 3*vmin..3*vmax;

execute {
  cp.setSearchPhases(cp.factory.searchPhase(v));
  cp.param.AllDiffInferenceLevel = "Extended";
  cp.param.timelimit=600;
};

minimize max(i in 1..nfaces) v[i];
subject to {
  v[1]==1;
  forall(i in 2..nfaces) { v[i-1] < v[i]; }  
  forall(c in Combis) { total[c] == v[c.v1]+v[c.v2]+v[c.v3]; }
  allDifferent(total);
} 

/*
which gives

v = [1 10 23 56 96 125 128 130];

*/
