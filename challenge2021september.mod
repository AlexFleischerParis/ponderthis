using CP;

execute
{
  cp.param.timelimit=360;;
 
}

range heroes=0..9;
range villains=0..9;

int nbv=71;
int nbfights=69; // real fight between a hero and a villain
int groupsize=4;
int nbgroups=5;
int nbusegroups=20;

int v0[1..nbv]=[3,1,4,1,5,9,2,6,5,3,5,8,9,
7,9,3,2,3,8,4,6,2,
6,4,3,3,8,3,2,7,9,
5,0,2,8,8,4,1,9,7,1,6,9,3,9,9,3,7,5,1,0,5,8,2,0,9,7,4,9,4,4
,5,9,2,3,0,7,8,1,6,4];

assert forall(i in 1..nbv) as:v0[i] in (0..9);

dvar int fightposv[1..nbfights] in 1..nbv;

dexpr int v[i in 1..nbfights]=v0[fightposv[i]];

dvar int groups[i in 1..nbgroups][j in 1..groupsize] in heroes;
dvar int usegroup[1..nbusegroups] in 1..nbgroups;

dvar int h0[1..groupsize*nbusegroups];
dvar int fightposh[1..nbfights] in 1..groupsize*nbusegroups;

dexpr int h[i in 1..nbfights]=h0[fightposh[i]];

dvar int realusegroups in 0..nbusegroups;

dvar int damage;

minimize damage;
 
subject to
{
  // villains
  
  forall(i in 2..nbfights) fightposv[i-1]<fightposv[i];
  
  // heroes 
  
  forall(i in 1..nbusegroups) (i<=realusegroups)  =>
  (and(j in 1..groupsize) h0[(i-1)*groupsize+j]==groups[usegroup[i]][j]);
  
  forall(i in 2..nbfights) fightposh[i-1]<fightposh[i];
  fightposh[nbfights]<=realusegroups*groupsize;
   
  forall(g in 1..nbgroups) allDifferent(all(j in 1..groupsize)groups[g][j]);
  
  // damage formula
  
  damage==sum(i in 1..nbfights) ftoi(abs(h[i]-v[i])) 
  +sum(i in 1..nbv) v0[i]
  +sum(i in 1..groupsize*nbusegroups)  (i<=realusegroups*groupsize)*h0[i]
  -sum(i in 1..nbfights) v[i]
  -sum(i in 1..nbfights) h[i];
  
  // additional constraint to make the problem harder but smaller
  forall(i in 1..nbfights) abs(v[i]-h[i])<=2;
  
  allDifferent(fightposh);
  allDifferent(fightposv);
} 

{int} skipv=asSet(1..nbv) diff {fightposv[j] | j in 1..nbfights};
{int} skiph=asSet(1..realusegroups*groupsize) diff {fightposh[j] | j in 1..nbfights};

execute
{
  writeln("skipv =",skipv);
  writeln("skiph =",skiph);
}


execute display
{
  
  write("[");
  for(var g=1;g<=nbgroups;g++)
  {
    write("\"");
    for(var i=1;i<=groupsize;i++) write(groups[g][i]);
    write("\"");
    if (g!=nbgroups) write(",");
  }
  write("]");
  writeln();
  
  
 for(var i=1;i<=nbfights;i++) write(v[i]);
 writeln();  
 for(var i=1;i<=nbfights;i++) write(h[i]);  
 writeln();
     
    
 
 
}

/*

gives

OBJECTIVE: 48
skipv = {2 51}
skiph = {14 15 41 47 51 53 63}
["2516","4238","3479","8309","9265"]
341592653589793238462643383279502884197169399375158209749445923078164
251692653479894238251642383479423883095168398395168309839347925169265

which can be read as

31415926535897--9323846264338327950288419-71693-993-7-5105820974-9445923078164
2-516926534798309423825164238347942388309251683098309251-683098309347925169265


*/
