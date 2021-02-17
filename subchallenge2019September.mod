// Banknotes

int a=...;
int b=...;
int c=...;
int d=...;
int e=...;

{int} notes={a,b,c,d,e};

int n=99;
range r=0..n;

// how many banknotes n in notes do we use for value in r
dvar int+ x[r][notes];
// is that given banknote n in notes used for value in r
dvar boolean  y[r][notes];

dexpr int  total=
sum(ordered s1,s2 in r) (card(notes)==sum(k in notes) (y[s1][k]==y[s2][k]));;

// To help do incremental changes to set objective
dvar int totalUB;
dvar int totalLB;

dvar int obj;
minimize obj; 

subject to
{
  
ct1:0<=totalUB;
ct2:0<=-totalLB;

obj==sum(s in r,n in notes) x[s][n]; 


forall(s in r) 
{
// dispatch gives the right amount
s==sum(n in notes) n*x[s][n];
// y is the number of different kind of banknotes 
forall(n in notes) y[s][n]==(x[s][n]>=1);
}
}

// two different random amounts of money uniformly distributed in the [0,99] range) would be exactly 4%.
int Ok=(total*25==(n*(n+1)/2));

//execute
//{
// 
//writeln("Right percentage : ",Ok);
//}

