using CP;

int n=6;
range r=1..n;

execute
{
  cp.param.timelimit=7200;
  cp.param.DefaultInferenceLevel=6;
  cp.param.CountInferenceLevel=6;
}



tuple t
{
  int a;
  int b;
  int c;
}

{t} s={<a,b,c> | a,b,c in r};

int val[i in s]=(i.a-1)*n*n+(i.b-1)*n+i.c-1;
execute
{
  val;
}



{t} s_rows[1..3][r][r];
{t} s_edgediag[1..6][r];
{t} s_diag[1..4];


execute
{
  
// add to s all cells between a1,b1,c1 and a2,b2,c2 
function cells(s,a1,b1,c1,a2,b2,c2)
{
  s.add(a1,b1,c1);
  for(var i=1;i<=n-1;i++) s.add(
  Opl.ftoi(Opl.round(a1+(a2-a1)/(n-1)*i)),
  Opl.ftoi(Opl.round(b1+(b2-b1)/(n-1)*i)),
  Opl.ftoi(Opl.round(c1+(c2-c1)/(n-1)*i)));
  s.add(a2,b2,c2);

}  
  
  cells(s_diag[1],1,1,1,n,n,n) ;
  cells(s_diag[2],1,1,n,n,n,1) ;
  cells(s_diag[3],1,n,n,n,1,1) ;
  cells(s_diag[4],1,n,1,n,1,n) ;
  
  for(var i in r) for(var j in r) cells(s_rows[1][i][j],i,j,1,i,j,n);
  for(var i in r) for(var j in r) cells(s_rows[2][i][j],1,i,j,n,i,j);
  for(var i in r) for(var j in r) cells(s_rows[3][i][j],i,1,j,i,n,j);
  
  for(var i in r) cells(s_edgediag[1][i],i,1,1,  i,n,n);
  for(var i in r) cells(s_edgediag[2][i],i,n,1,  i,1,n);
  
  for(var i in r) cells(s_edgediag[3][i],1,i,1,  n,i,n);
  for(var i in r) cells(s_edgediag[4][i],n,i,1,  1,i,n);
  
  for(var i in r) cells(s_edgediag[5][i],1,1,i,  n,n,i);
  for(var i in r) cells(s_edgediag[6][i],n,1,i,  1,n,i);
  
}

assert forall(i in 1..3,j in r,k in r) card(s_rows[i][j][k])==n;
assert forall(i in 1..6,j in r) card(s_edgediag[i][j])==n;
assert forall(i in 1..4) card(s_diag[i])==n;

assert card(s)==n*n*n;

dvar int x[r][r][r] in r;
dvar int diagobj;
dvar int rowobj;
dvar int edgediagobj;


maximize diagobj+rowobj+edgediagobj;
subject to
{

  
  
  diagobj==sum(i in 1..4) and(color in r) 
  (count(all(e in s_diag[i])x[e.a,e.b,e.c],color)==1);
  
 rowobj==sum(i in 1..3,j in r,k in r) and(color in r) 
  (count(all(e in s_rows[i,j,k])x[e.a,e.b,e.c],color)==1);
  
  edgediagobj==sum(i in 1..6,j in r) and(color in r) 
  (count(all(e in s_edgediag[i,j])x[e.a,e.b,e.c],color)==1);
 
 // break symetries
  
  allDifferent(all(e in s_rows[1,1,1])x[e.a,e.b,e.c]);
  allDifferent(all(e in s_rows[2,1,1])x[e.a,e.b,e.c]);
  allDifferent(all(e in s_rows[3,1,1])x[e.a,e.b,e.c]);
  
  allDifferent(all(e in s_rows[1,n,n])x[e.a,e.b,e.c]);
  allDifferent(all(e in s_rows[2,n,n])x[e.a,e.b,e.c]);
  allDifferent(all(e in s_rows[3,n,n])x[e.a,e.b,e.c]);
 
 
}

// display
execute
{
  for(var i in r) for(var j in r)
  {
    for(var k in r) write(x[i][j][k]," ");
    writeln();  
  }
  writeln(diagobj+rowobj+edgediagobj);
}

/*

gives

2 6 4 1 3 5
3 1 6 5 4 2
5 4 3 2 6 1
4 5 1 6 2 3
1 3 2 4 5 6
6 2 5 3 1 4
6 2 5 3 1 4
1 3 2 4 5 6
4 5 1 6 2 3
5 4 3 2 6 1
3 1 6 5 4 2
2 6 4 1 3 5
5 4 3 6 2 1
6 2 5 1 3 4
3 1 6 5 4 2
1 3 2 4 5 6
2 6 4 3 1 5
4 5 1 2 6 3
1 3 6 4 5 2
4 5 1 2 6 3
2 6 4 1 3 5
6 2 5 3 1 4
5 4 3 6 2 1
3 1 2 5 4 6
3 1 2 5 4 6
5 4 3 6 2 1
6 2 5 3 1 4
2 6 4 1 3 5
4 5 1 2 6 3
1 3 6 4 5 2
4 5 1 2 6 3
2 6 4 3 1 5
1 3 2 4 5 6
3 1 6 5 4 2
6 2 5 1 3 4
5 4 3 6 2 1
132

*/





