int circle[1..7]=[4, 7, 3, 6, 2, 0, 1];
range r=0..9;

main { 

thisOplModel.settings.mainEndEnabled=1; // not to run in out of memory

var minscore=1000000000;
var maxscore=0;

var c1min;
var c2min;
var c3min;
var c4min;
var c5min;
var c6min;
var c7min;

var c1max;
var c2max;
var c3max;
var c4max;
var c5max;
var c6max;
var c7max;

var data = new IloOplDataSource("challenge2022januaryprimes.dat");

for(var c1 in thisOplModel.r) 
for(var c2 in thisOplModel.r) if (c2!=c1) if (c2>=c1) // break sym
for(var c3 in thisOplModel.r) if ((c3!=c2) && (c3!=c1)) if (c3>=c1) // break sym
for(var c4 in thisOplModel.r) if ((c4!=c3) && (c4!=c2) && (c4!=c1)) if (c4>=c1) // break sym
for(var c5 in thisOplModel.r) if ((c5!=c4) && (c5!=c3) && (c5!=c2) && (c5!=c1)) if (c5>=c1) // break sym
for(var c6 in thisOplModel.r) if ((c6!=c5) && (c6!=c4) && (c6!=c3) && (c6!=c2) && (c6!=c1)) if (c6>=c1) // break sym
for(var c7 in thisOplModel.r) if ((c7!=c6) && (c7!=c5) && (c7!=c4) && (c7!=c3) && (c7!=c2) && (c7!=c1)) if (c7>=c1) if (c7>=c2)// break sym
{
  //writeln(c1,c2,c3,c4,c5,c6,c7);
  var source = new IloOplModelSource("subchallenge2022january.mod");
  var cplex = new IloCplex();
  var def = new IloOplModelDefinition(source);
  var opl = new IloOplModel(def,cplex);
  
  var data2= new IloOplDataElements();
  
  thisOplModel.circle[1]=c1;
  thisOplModel.circle[2]=c2;
  thisOplModel.circle[3]=c3;
  thisOplModel.circle[4]=c4;
  thisOplModel.circle[5]=c5;
  thisOplModel.circle[6]=c6;
  thisOplModel.circle[7]=c7;
  
  
  data2.circle=thisOplModel.circle;
  opl.addDataSource(data);
  opl.addDataSource(data2);
  opl.generate();
  //writeln(opl.score);
  var score=opl.score;
  if (score<minscore)
  {
    minscore=score;
    c1min=c1;
    c2min=c2;
    c3min=c3;
    c4min=c4;
    c5min=c5;
    c6min=c6;
    c7min=c7;
    writeln("max = ",maxscore);
    writeln("min = ",minscore);
  }
  if (score>maxscore)
  {
    maxscore=score;
    c1max=c1;
    c2max=c2;
    c3max=c3;
    c4max=c4;
    c5max=c5;
    c6max=c6;
    c7max=c7;
    writeln("max = ",maxscore);
    writeln("min = ",minscore);
  }
  
  //writeln();
  //writeln("[",c1max,",",c2max,",",c3max,",",c4max,",",c5max,",",c6max,",",c7max,"]");
  //writeln("[",c1min,",",c2min,",",c3min,",",c4min,",",c5min,",",c6min,",",c7min,"]");
  
  opl.end();
  
}
  writeln();
  writeln("--------------------------");
  writeln("max = ",maxscore);
  writeln("min = ",minscore);
  
  writeln("[",c1max,",",c2max,",",c3max,",",c4max,",",c5max,",",c6max,",",c7max,"]");
  writeln("[",c1min,",",c2min,",",c3min,",",c4min,",",c5min,",",c6min,",",c7min,"]");
  
}  

/*

which gives

max = 3051
min = 446
[1,2,5,4,9,3,7]
[0,1,4,5,8,2,6]

*/

