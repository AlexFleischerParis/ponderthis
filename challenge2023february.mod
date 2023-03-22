/*

February 2023 IBM Ponder This Challenge

Find a placement of n=20 queens on an n times n board such that 
no pair of queens threatens each other, and the number of 
different ways to place n kings on the safe squares 
without any pair of kings currently threatening one another is 48.

*/

using CP;

int n=20;
range r=1..n;

int nboptions=48;

int nbsafe2=4;
int nbsafe3=1;

assert nboptions==ftoi(pow(2,nbsafe2)*pow(3,nbsafe3));

int nbsafe1=n-nbsafe2-nbsafe3;
int nbsafe=nbsafe1+nbsafe2*2+nbsafe3*3;

range safe1=1..nbsafe1;
range safe2=1..nbsafe2;
range safe3=1..nbsafe3;


dvar int y[r] in r; // queens
dvar int s[r] in 2..2*n;
dvar int d[r] in 1-n..n-1;

// Is this cell safe ?
dvar boolean safe[r][r];

// Is this cell safe and then how many safe cells around ?
dvar int safeNeighbours[r][r] in 0..3;

dvar int x3 in r;
dvar int y3 in r;


dvar int+ gap1 in 0..maxint;
dvar int+ gap2 in 0..maxint;

execute {
cp.param.LogVerbosity="terse";


var f = cp.factory;

var phase1 = f.searchPhase(Opl.append(s,d));

cp.setSearchPhases(phase1);}

minimize gap1+gap2;

subject to
{
  
  // n queens 
  allDifferent(y);
  forall(i in r)
    {
      s[i]==i+y[i];
      d[i]==i-y[i];
    }
   allDifferent(s);
   allDifferent(d); 
   
   // safe cells
  
 
   forall(i,j in r) (safe[i][j])==((and(k in r) (i+j!=s[k])) && (and (k in r) (i-j!=d[k])));
   
   // how many neighbours

  forall(i,j in r) safeNeighbours[i][j]==(safe[i][j]) *
  sum(i2 in i-1..i+1,j2 in j-1..j+1:(i2 in r) && (j2 in r))
     safe[i2][j2];


  
  count(safeNeighbours,1)==gap1+nbsafe1;
  count(safeNeighbours,2)==gap2+nbsafe2*2;
  count(safeNeighbours,3)==nbsafe3*3;
  
  
   
   // The 3 options scheme
   safeNeighbours[x3][y3]==3;
   safeNeighbours[x3+1][y3]==3;
   safeNeighbours[x3][y3+1]==3;
   
   // try this
   
   x3==1;
   y3==9;
   
  

}

int result[i in r][j in r]=safe[i][j]+2*(j==y[i]); 


execute display_solution
{
  
 writeln("Queens");
 writeln();
 write("[");
 for(var i in r)
 {
   write("(",i-1,",",y[i]-1,")");
   if (i!=n) write(",");
 }
 writeln("]");
}

assert count(safe,1)==nbsafe;



    execute DISPLAY
    {

    var python=new IloOplOutputFile("c:/temp/display.py");
    python.writeln("import matplotlib.pyplot as plt");
    python.writeln("import numpy as np");
    python.writeln("grid=np.array(");

    python.writeln("[");
    for(var i in r)
    {
        python.writeln("[");
        for(var j in r) python.write(result[i][j],",");
        python.writeln("],");
        ;
    }
    python.writeln("]");

    python.writeln(")");
    python.writeln("im = plt.imshow(grid, cmap='hot')");
    python.writeln("im.axes.get_xaxis().set_visible(False)");
    python.writeln("im.axes.get_yaxis().set_visible(False)");
    python.writeln("plt.show()");
    python.close();

    IloOplExec("C:\\python\\Python39\\python.exe c:\\temp\\display.py");
    }
    
/*

which gives

Queens

[(0,13),(1,19),(2,17),(3,8),(4,3),(5,7),(6,10),(7,18),(8,6),(9,1),
(10,16),(11,11),(12,5),(13,2),(14,15),(15,9),(16,12),(17,14),(18,0),(19,4)]


*/    


