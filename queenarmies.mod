/*

Place two equal-sized armies of black and white queens on a chessboard so that 
the queens of different colours do not attack each-other and 
to find the maximum size of two such armies.

*/

int n=8;

range r=1..n;

dvar boolean w[r][r]; // white queens
dvar boolean b[r][r]; // black queens

dvar int nbQueens;

maximize nbQueens;

subject to
{
  nbQueens==sum(i,j in r) w[i][j];
  nbQueens==sum(i,j in r) b[i][j];
  
  // the queens of different colours do not attack each-other
  forall(i1,j1,i2,j2 in r:(i1==i2) || (j2==j1) || (j1+i1==j2+i2) || (j1-i1==j2-i2)) w[i1][j1]+b[i2][j2]<=1;
}

string result[i in r][j in r]=(w[i][j]==1)?"W":((b[i][j]==1)?"B":" ");

execute
{
  writeln();
  for(var i in r)
  {
    for(var j in r) write(result[i][j]);
    writeln();
  }
}

/*

which gives

  WW  W 
  WW    
  W    W
   W  W 
 B      
B       
 B  BB  
BB  BB  

*/
