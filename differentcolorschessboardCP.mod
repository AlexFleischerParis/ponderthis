/*

Suppose you do have an n*n chess board (assume 10*10).
Paint the cells with minimum number of colours satisfying the following condition :
Each colour can't be repeated more than once in every row and column

*/

using CP;

int n=50;
range r=1..n;
range r2=n..n*n;

dvar int+ x[r][r] in 1..n*n;
dvar int obj in r2;

minimize obj;
subject to
{
  obj==max(i,j in r) x[i][j];
  
  forall(i in r)
   {
     allDifferent(all(j in r)x[i][j]);
     allDifferent(all(j in r)x[j][i]);
   }   
}


