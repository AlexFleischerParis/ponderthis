using CP;


// random generator
execute
{
  var d=new Date();
  var intd=d.getTime() % 100000000;
  Opl.srand(intd);
}

{string} nodes={"A","B","C","D","E"};

string node1=first(nodes);
{string} othernodes=nodes diff {node1};

tuple t
{
  string a;
  string b;
}

int nbdays=10;
range days=0..nbdays;

{t} links with a,b in nodes ={<"A","C">,<"A","D">,
<"C","D">,<"A","B">,<"B","E">,<"D","E">};

{t} allpossiblelinks={<i,j> | ordered i,j in nodes};

// nb of scenarii
int nbScen=5000;
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

// node sick ?
dvar boolean y[nodes][days][scenarii];

dvar int nbInfected[s in scenarii];
dvar int allInfected[s in scenarii];

dexpr float rateInfection=1/card(scenarii)*sum(s in scenarii) allInfected[s];


subject to
{
// symetry
forall(ordered a,b in nodes) x[a][b]==x[b][a];

// no link with self
forall(a in nodes) x[a][a]==0;
  
forall(a,b in nodes:a!=b) x[a][b]==((<a,b> in links)||(<b,a> in links));  
  
// day 0
forall(a in othernodes,s in scenarii) y[a][0][s]==0;
forall(s in scenarii,d in days) y[node1][d][s]==1;

forall(a in othernodes,d in days,s in scenarii:d!=0) 
   y[a][d][s]==
   ((y[a][d-1][s]==1) || 
   (or(b in nodes:b!=a && (z[a][b][s][d]==1)) 
     ((y[b][d-1][s]==1) && (x[a][b]==1))))
     ;
     
forall(s in scenarii)
  {
    
 nbInfected[s]==(sum(a in nodes) y[a][nbdays][s]);
 allInfected[s]==(sum(a in nodes) y[a][nbdays][s]==card(nodes));
}

    
}


execute
{
writeln("infection rate = ",rateInfection);
}
