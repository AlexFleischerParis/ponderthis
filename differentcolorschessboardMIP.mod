/*

Suppose you do have an n*n chess board (assume 10*10).
Paint the cells with minimum number of colours satisfying the following condition :
Each colour can't be repeated more than once in every row and column

*/

int n=50;
range r=1..n;
range r2=n..n*n;
range r3=1..n*n;

dvar boolean x[r][r][r3];
dvar boolean usedcolor[r3];
dvar int obj in r2;

minimize obj;
subject to
{
  obj==sum(k in r3) usedcolor[k];
  
  forall(i in r) forall(k in r3)
   {
     sum(j in r) x[i][j][k]<=1;
     sum(j in r) x[j][i][k]<=1;
   }
   
   forall(i,j in r) forall(k in r3) x[i][j][k]<=usedcolor[k];
}
