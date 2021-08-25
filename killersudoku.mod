using CP;

range r=1..4;

dvar int x[r][r] in r;

subject to
{
  forall(i in r) allDifferent(all(j in r) x[i][j]);
  forall(j in r) allDifferent(all(i in r) x[i][j]);
  allDifferent(append(x[2][2],x[2][3],x[3][2],x[3][3]));
  allDifferent(append(x[1][3],x[1][2],x[1][1],x[2][1]));
  allDifferent(append(x[3][1],x[4][1],x[4][2],x[4][3]));
  
  x[1][4]==3;
  x[2][4]==4;
  x[4][3]==1;
}

int sol[i in r][j in r]=x[j][5-i];

execute
{
  writeln(sol);
}
