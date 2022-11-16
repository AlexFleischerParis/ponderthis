int n=6;
range r=1..n;

execute
{
  cplex.mipemphasis=5;
  cplex.tilim=600;
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

dvar boolean x[r][r][r][r]; // x,y,z and colof
dvar int diagobj;
dvar int rowobj;
dvar int edgediagobj;

dvar boolean minCountDiag[1..4];
dvar boolean minCountRow[1..3,r,r];
dvar boolean minCountEdgeDiag[1..6,r];

maximize diagobj+rowobj+edgediagobj;
subject to
{
  forall(i,j,k in r) sum(c in r) x[i,j,k,c]==1; // each cell has exactly ne number

  forall(i in r) x[1][1][i][i]==1;

  forall(i in 1..4) forall(color in r)   minCountDiag[i]<=sum(e in s_diag[i]) x[e.a,e.b,e.c,color];
  
  forall(i in 1..3,j in r,k in r) forall(color in r) minCountRow[i][j][k]<=sum(e in s_rows[i,j,k])x[e.a,e.b,e.c,color];
  
  forall(i in 1..6,j in r) forall(color in r) minCountEdgeDiag[i][j]<=sum(e in s_edgediag[i,j])x[e.a,e.b,e.c,color];
  
  diagobj==sum(i in 1..4)  minCountDiag[i];
  
  rowobj==sum(i in 1..3,j in r,k in r) minCountRow[i][j][k];
 
   edgediagobj==sum(i in 1..6,j in r) minCountEdgeDiag[i][j];
}

int x2[i in r,j in r,k in r]=sum(c in r) (c*x[i,j,k,c]);

execute display
{
  for(var i in r) for(var j in r)
  {
    for(var k in r) write(x2[i][j][k]," ");
    writeln();  
  }
  writeln(diagobj+rowobj+edgediagobj);
}

main
{
  // First let us maximize for rows
  thisOplModel.generate();;
  cplex.setObjCoef(thisOplModel.diagobj,0);
  cplex.setObjCoef(thisOplModel.edgediagobj,0);
  cplex.solve();
  
  // and then for edge diagonals
  cplex.setObjCoef(thisOplModel.edgediagobj,1);
  cplex.solve();
  
  // and then the 4 diagonals
  cplex.setObjCoef(thisOplModel.diagobj,1);
  cplex.solve();
  
  thisOplModel.postProcess();
}

/*

which gives

1 2 3 4 5 6
3 6 2 5 1 4
6 5 4 3 2 1
4 1 5 2 6 3
5 4 6 1 3 2
2 3 1 6 4 5
2 3 1 6 4 5
4 1 5 2 6 3
5 3 6 1 4 2
6 5 4 3 2 1
1 2 3 4 5 6
3 6 2 5 1 4
6 5 4 3 2 1
5 2 6 1 5 2
2 4 1 6 3 5
3 6 2 5 1 4
1 3 4 3 4 6
4 1 5 2 6 3
3 6 2 5 1 4
1 4 3 4 3 6
4 1 5 2 6 3
5 3 6 1 4 2
4 5 1 6 2 3
1 2 4 3 5 6
4 1 5 2 6 3
6 5 4 3 2 1
1 2 3 4 5 6
2 4 1 6 3 5
3 6 2 5 1 4
5 3 6 1 4 2
5 4 6 1 3 2
2 3 1 6 4 5
3 6 2 5 1 4
1 2 3 4 5 6
4 1 5 2 6 3
6 5 4 3 2 1
129
*/



