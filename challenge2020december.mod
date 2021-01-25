using CP;

range r=1..5;



tuple t2
{
  int v1;
  int v2;
  int v3;
  int v4;
  int v5;
}

{t2} s2={<i,j,k,l,m> | i,j,k,m,l in 0..1};

assert card(s2)==32;

range roptions=1..32;

int options[i in 1..32][j in r]=((i-1) div ftoi(2^(5-j))) mod 2;

// number of great electors
int E=1001;


float rate=71.781305;

//0,7178130511463845

// populations
dvar int+ p[r] in 100..150;
// total population 
dvar int pt;
// electors after division
dvar int+ e1[r];
// electors after spread of the reminder
dvar int+ e[r];
// reminder
dvar int reminder;
// votes
dvar int+ v[r];

// 32 options of whether in a state we have the entire votes or just below half
dexpr int v3[o in roptions][i in r]=(options[o][i])*p[i]+(1-options[o][i])*(p[i] div 2);

// total votes
dvar int+ vt;

minimize abs(vt/pt-rate/100);

subject to
{
  

// odd population
forall(i in r) p[i] mod 2==1;

forall(i in r) v[i]<=p[i];
  
  sum(i in r) e[i]==E;
  pt==sum(i in r) p[i];
  vt==sum(i in r) v[i];
  
  forall(i in r) e1[i]==floor((p[i]/pt)*E);
  reminder==E-sum(i in r) e1[i];
  
  forall(i in 1..4) p[i]/pt*E-e1[i]>=p[i+1]/pt*E-e1[i+1];
  
  forall(i in 1..4) e[i]==e1[i]+(reminder>=i);
  e[5]==e1[5];
  
  
  
  // losing vote
  (sum(i in r) e[i]*(v[i]>=(p[i] div 2+1)))
  <=
  (E div 2);
  
  // any vote of a larger size is not losing
  

  
  forall(o in roptions)
    
    (sum(i in r) v3[o][i]>=vt+1) => 
    (
    (sum(i in r) e[i]*(v3[o][i]>=(p[i] div 2+1)))
  >
  (E div 2)
  );
}


execute display_solution
{
  writeln("p = ",p);
  writeln("v = ",v);
  
  write("[");
  for(var i  in r) if (i!=5) write(p[i],","); else write(p[i]);
  writeln("]");
  
  write("[");
  for(var i  in r) if (i!=5) write(v[i],","); else write(v[i]);
  writeln("]");
  

}
