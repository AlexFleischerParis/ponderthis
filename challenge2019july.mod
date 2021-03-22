/*********************************************
 * OPL 12.9.0.0 Model
 * Author: ALEXFleischer
 * Creation Date: 2 juil. 2019 at 08:17:27
 *********************************************/
using CP;

execute
{
cp.param.timelimit=10;
}

int n=8;
range N=1..n;
int m=5;
range M=1..m;

// Knigts move
int xmove[1..8]=[2,2,1,1,-1,-1,-2,-2];
int ymove[1..8]=[1,-1,2,-2,2,-2,1,-1];

int l=14;
range L=1..l;

int xsym[0..8]=[0,7,8,5,6,3,4,1,2];
int ysym[0..8]=[0,2,1,4,3,6,5,8,7];


dvar int x[L] in N;
dvar int y[L] in M;
dvar int move[L] in 1..8;

dvar int move2[N][M] in 0..8; // 0 empty otherwise the move
dvar int move2b[N][M] in 0..8; // 0 empty otherwise the move if we were going backward

// With symetries
dvar int move3[1..4][N][M] in 0..8; // 0 empty otherwise the move
dvar int move3b[1..4][N][M] in 0..8; // 0 empty otherwise the move if we were going backward


dvar int z[L];

dvar int+ areatimes2;
dvar int minmax in 1..1; //1 or -1 according to maximize or minimize

maximize minmax*abs(areatimes2)/2;

subject to
{

count(move2,0)==m*n-l;
forall(i in L) move2[x[i],y[i]]==move[i];

count(move2b,0)==m*n-l;
forall(i in L:i!=1) move2b[x[i],y[i]]==(9-move[i-1]);
forall(i in L:i==1) move2b[x[i],y[i]]==(9-move[l]);

areatimes2==sum(i in 1..l-1) (x[i]*y[i+1]-x[i+1]*y[i])+x[l]*y[1]-x[1]*y[l];

forall(i in L) z[i]==10*x[i]+y[i];
allDifferent(z);

forall(i in L:i!=1) 
{
x[i]==x[i-1]+xmove[move[i-1]];
y[i]==y[i-1]+ymove[move[i-1]];
}

x[1]==x[l]+xmove[move[l]];
y[1]==y[l]+ymove[move[l]];

 
forall(i in N,j in M)   
{
  move3[1][i][j]==move2[i][j];
  move3b[1][i][j]==move2b[i][j];
} 

forall(i in N,j in M)   
{
  move3[2][i][j]==xsym[move3[1][n+1-i][j]];
  move3b[2][i][j]==xsym[move3b[1][n+1-i][j]];
  
  move3[3][i][j]==ysym[move3[1][i][m+1-j]];
  move3b[3][i][j]==ysym[move3b[1][i][m+1-j]];
  
  move3[4][i][j]==ysym[move3[2][i][m+1-j]];
  move3b[4][i][j]==ysym[move3b[2][i][m+1-j]];
}   

forall(i in N,j in M,k in 1..4:j!=m)  
{
   (move3[k][i][j]==1)  => (move3[k][i][j+1]!=2);
   (move3[k][i][j]==1)  => (move3b[k][i][j+1]!=2);
   (move3b[k][i][j]==1)  => (move3b[k][i][j+1]!=2);
   (move3b[k][i][j]==1)  => (move3[k][i][j+1]!=2);
   
   (move3[k][i][j]==3)  => (move3[k][i][j+1]!=4);
   (move3[k][i][j]==3)  => (move3b[k][i][j+1]!=4);
   (move3b[k][i][j]==3)  => (move3b[k][i][j+1]!=4);
   (move3b[k][i][j]==3)  => (move3[k][i][j+1]!=4);
   
   (move3[k][i][j]==1)  => (move3[k][i][j+1]!=4);
   (move3[k][i][j]==1)  => (move3b[k][i][j+1]!=4);
   (move3b[k][i][j]==1)  => (move3b[k][i][j+1]!=4);
   (move3b[k][i][j]==1)  => (move3[k][i][j+1]!=4);
   
   (move3[k][i][j]==3)  => (move3b[k][i][j+1]!=4);
   (move3[k][i][j]==3)  => (move3b[k][i][j+1]!=4);
   (move3b[k][i][j]==3)  => (move3b[k][i][j+1]!=4);
   (move3b[k][i][j]==3)  => (move3[k][i][j+1]!=4);
   
   (move3[k][i][j]==3)  => (move3[k][i][j+1]!=1);
   (move3[k][i][j]==3)  => (move3b[k][i][j+1]!=1);
   (move3b[k][i][j]==3)  => (move3b[k][i][j+1]!=1);
   (move3b[k][i][j]==3)  => (move3[k][i][j+1]!=1);
   
   (move3[k][i][j]==3)  => (move3[k][i][j+1]!=2);
   (move3[k][i][j]==3)  => (move3b[k][i][j+1]!=2);
   (move3b[k][i][j]==3)  => (move3b[k][i][j+1]!=2);
   (move3b[k][i][j]==3)  => (move3[k][i][j+1]!=2);
}

forall(i in N,j in M,k in 1..4:i!=n)  
{
   (move3[k][i][j]==3)  => (move3[k][i+1][j]!=5);
   (move3[k][i][j]==3)  => (move3b[k][i+1][j]!=5);
   (move3b[k][i][j]==3)  => (move3b[k][i+1][j]!=5);
   (move3b[k][i][j]==3)  => (move3[k][i+1][j]!=5);
   
   (move3[k][i][j]==1)  => (move3[k][i+1][j]!=7);
   (move3[k][i][j]==1)  => (move3b[k][i+1][j]!=7);
   (move3b[k][i][j]==1)  => (move3b[k][i+1][j]!=7);
   (move3b[k][i][j]==1)  => (move3[k][i+1][j]!=7);
   
   (move3[k][i][j]==3)  => (move3[k][i+1][j]!=7);
   (move3[k][i][j]==3)  => (move3b[k][i+1][j]!=7);
   (move3b[k][i][j]==3)  => (move3b[k][i+1][j]!=7);
   (move3b[k][i][j]==3)  => (move3[k][i+1][j]!=7);
   
   (move3[k][i][j]==1)  => (move3[k][i+1][j]!=5);
   (move3[k][i][j]==1)  => (move3b[k][i+1][j]!=5);
   (move3b[k][i][j]==1)  => (move3b[k][i+1][j]!=5);
   (move3b[k][i][j]==1)  => (move3[k][i+1][j]!=5);
   
   (move3[k][i][j]==1)  => (move3[k][i+1][j]!=3);
   (move3[k][i][j]==1)  => (move3b[k][i+1][j]!=3);
   (move3b[k][i][j]==1)  => (move3b[k][i+1][j]!=3);
   (move3b[k][i][j]==1)  => (move3[k][i+1][j]!=3);
   

}

forall(i in N,j in M,k in 1..4:i!=n && j!=m)  
{
   (move3[k][i][j]==1)  => (move3[k][i+1][j+1]!=2);
   (move3[k][i][j]==1)  => (move3b[k][i+1][j+1]!=2);
   (move3b[k][i][j]==1)  => (move3[k][i+1][j+1]!=2);
   (move3b[k][i][j]==1)  => (move3b[k][i+1][j+1]!=2);
   
   (move3[k][i][j]==3)  => (move3[k][i+1][j+1]!=4);
   (move3[k][i][j]==3)  => (move3b[k][i+1][j+1]!=4);
   (move3b[k][i][j]==3)  => (move3[k][i+1][j+1]!=4);
   (move3b[k][i][j]==3)  => (move3b[k][i+1][j+1]!=4);
}

 
}

string letters[1..8]=["a","b","c","d","e","f","g","h"];

// Solution display
execute
{
for(var i in L) write(letters[x[i]],y[i]," ");
writeln(letters[x[1]],y[1]);
}

// Graphical display
execute display_polygone
{
function display_polygone(x,y,L,filename)
{
   var o=new IloOplOutputFile(filename);
   o.writeln("from numpy import *");
   o.writeln("from matplotlib.pyplot import *");
   o.write("x=([");
   for(var i in L) o.write(x[i],",");
   o.write(x[1],",");
   o.writeln("])")
   
   o.write("y=([");
   for(var i in L) o.write(y[i],",");
   o.write(y[1],",");
   o.writeln("])")

   o.writeln("plot(x,y)");
   o.writeln("show()");
   o.close();
   
   var exec="C:\\Python36\\python.exe "+filename;
   IloOplExec(exec);
}


display_polygone(x,y,L,"c:\\POC\\display.py");

}

main
{
var obj1;
var obj2;  

// maximize
thisOplModel.generate();
cp.solve();
thisOplModel.postProcess();
obj1=cp.getObjValue();
// and then minimize
thisOplModel.minmax.UB=-1;
thisOplModel.minmax.LB=-1;
cp.solve();
thisOplModel.postProcess();
obj2=-cp.getObjValue();  
writeln("max-min = ",obj1-obj2);  
}

/*

which gives

h3 g5 e4 f2 d3 b2 c4 e3 d5 b4 a2 c1 e2 g1 h3
e3 c4 d2 b3 a1 c2 e1 d3 f2 e4 g3 h5 f4 d5 e3
max-min = 7

*/


