using CP;


execute
{
  cp.param.workers=1;
  
  var d=new Date();
   intd=Opl.ftoi(Opl.ceil(d.getTime() % 100000000));
  Opl.srand(intd);
}

{string} nodes={"A","B","C","D","E","F","G","H"};

string node1=first(nodes);
{string} othernodes=nodes diff {node1};

tuple t
{
  string a;
  string b;
}

int nbdays=10;
range days=0..nbdays;



{t} allpossiblelinks={<i,j> | ordered i,j in nodes};

int nbScen=100000;
range scenarii=1..nbScen;

int transmit[l in allpossiblelinks][s in scenarii][d in days]=(rand(10)>=9);

float rate=
1/card(allpossiblelinks)/nbScen/(nbdays+1)*sum(l in allpossiblelinks,s in scenarii,d in days)
transmit[l][s][d];

execute
{
  writeln("rate=",rate);
}

// infect or keep healthy
int z[a in nodes][b in nodes][s in scenarii][d in days]=(a==b)?0:((a<b)?transmit[<a,b>,s,d]:transmit[<b,a>,s,d]);


dvar boolean x[nodes][nodes]; // are they linked ?
dvar boolean xx[allpossiblelinks];
// node sick ?
dvar boolean y[nodes][days][scenarii];

// search phase
execute {
var f = cp.factory;

var phase = f.searchPhase(xx);

cp.setSearchPhases(phase);
}

//dvar int nbInfected[s in scenarii];
dvar int allInfected[s in scenarii];

dexpr float rateInfection=1/card(scenarii)*sum(s in scenarii) allInfected[s];

minimize abs(rateInfection-0.7);
subject to
{
// break sym
x["A"]["B"]==1;
x["A"]["C"]==1;


// symetry
forall(ordered a,b in nodes) x[a][b]==x[b][a];

// no link with self
forall(a in nodes) x[a][a]==0;
  
forall(a,b in nodes:a<b) x[a][b]==xx[<a,b>];
forall(a,b in nodes:b<a) x[a][b]==xx[<b,a>];
  
// day 0
forall(a in othernodes,s in scenarii) y[a][0][s]==0;
forall(s in scenarii,d in days) y[node1][d][s]==1;


// day i out of day i-1
forall(a in othernodes,d in days,s in scenarii:d!=0) 
   y[a][d][s]==
   ((y[a][d-1][s]==1) || 
   (or(b in nodes:b!=a && (z[a][b][s][d]==1)) 
     ((y[b][d-1][s]==1) && (x[a][b]==1))))
     ;
     

     
 forall(s in scenarii)
  {
    

 allInfected[s]==(and(a in nodes) (y[a][nbdays][s]==1));
}    
}


execute
{
writeln("infection rate = ",rateInfection);
writeln();
for(var i in nodes)
{
  for(var j in nodes) write(x[i][j]);
  writeln();
  
}
writeln(x);
}

/*

which gives

infection rate = 0.7

01111101
10011110
10011111
11100110
11100111
11111001
01111001
10101110

*/


