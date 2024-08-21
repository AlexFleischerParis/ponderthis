using CP;

execute
{
  cp.param.timelimit=300;
}

 range r=1..4;
 range rotations=0..3;
 range syms=0..1;

// rotations
int xrota[i in 1..4][j in 1..4]=j;
int yrota[i in 1..4][j in 1..4]=5-i;

int xrota2[i in 1..4][j in 1..4]=5-i;
int yrota2[i in 1..4][j in 1..4]=5-j;

int xrota3[i in 1..4][j in 1..4]=5-j;
int yrota3[i in 1..4][j in 1..4]=i;

// symetries
int xsym[i in 1..4][j in 1..4]=i;
int ysym[i in 1..4][j in 1..4]=5-j;

int xrotar[i in 1..4][j in 1..4][rota in 0..3]=
(rota==0)?(i):((rota==1)?xrota[i][j]:((rota==2)?xrota2[i][j]:xrota3[i][j]));
int yrotar[i in 1..4][j in 1..4][rota in 0..3]=
(rota==0)?(j):((rota==1)?yrota[i][j]:((rota==2)?yrota2[i][j]:yrota3[i][j]));

int xrotarsym[i in 1..4][j in 1..4][rota in 0..3][sym in 0..1]=
(sym==0)?xrotar[i][j][rota]:xsym[xrotar[i][j][rota]][yrotar[i][j][rota]];
int yrotarsym[i in 1..4][j in 1..4][rota in 0..3][sym in 0..1]=
(sym==0)?yrotar[i][j][rota]:ysym[xrotar[i][j][rota]][yrotar[i][j][rota]];

int n=16;
range board=1..n;

dvar boolean x[i in board][j in board]; 
dvar int+ obj;

minimize obj;
subject to
{
  
// each tile has an equal number of black and white squares.

forall(I in r,J in r)
  count(all(i in r,j in r)x[(I-1)*4+i][(J-1)*4+j],1)==8;  
  
// All tiles included in the tiling must be non-equivalent,

forall(I in r,J in r,I2 in r,J2 in r:
(I-1)*4+J-1<(I2-1)*4+J2-1)
  forall(rota in rotations,sym in 0..1)
    or(i in r,j in r) x
    [(I-1)*4+xrotarsym[i][j][rota][sym]]
    [(J-1)*4+yrotarsym[i][j][rota][sym]]
    !=x[(I2-1)*4+i][(J2-1)*4+j];
  
//  In each row and column, there are no more than
// two consecutive squares of the same color.

forall(i in board)
    forall(j in board:(j+2) in board) forall(v in 0..1) 
     {
      ((x[i][j]==v) && (x[i][j+1]==v)) =>  (x[i][j+2]==1-v);
      ((x[j][i]==v) && (x[j+1][i]==v)) =>  (x[j+2][i]==1-v);
   }      
  
//The total number of pairs of adjacent same color squares is minimal. 
//Remember to count both vertical and horizontal pairs.

obj==sum(i in board,j in board:(j+1) in board) ((x[i][j]==x[i][j+1])+(x[j][i]==x[j+1][i]));
}

execute
{
  writeln(obj);
  for(var i in board)
  {
    for(var j in board) write(x[i][j]);
    writeln();
  }
}

/*

gives

66
1001010011010101
0110101101001010
1010101010101001
0101010101010101
1010101010101010
1101010101010101
0010101010101010
0101010101101010
1010101010010101
0101010101101010
1001001010010010
0110110101101101
1001001010010010
0101010101101011
1010101011010101
0110110100101010

*/


