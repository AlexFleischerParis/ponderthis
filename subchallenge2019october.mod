int a=...;
int b=...;
int c=...;
int d=...;
int e=...;

{int} notes={a,b,c,d,e};

int n=99;
range r=0..n;

// how many banknote n to make amount r
dvar int+ x[r][notes];
// shall we use the banknote n to make amount r
dvar boolean  y[r][notes];

dvar int obj;
minimize obj; 

subject to
{
obj==sum(s in r,n in notes) x[s][n]; 


forall(s in r) 
{
s==sum(n in notes) n*x[s][n];
forall(n in notes) y[s][n]==(x[s][n]>=1);
}
}

int  total=
sum(s1,s2 in r) (card(notes)==sum(k in notes) (y[s1][k]==y[s2][k]));

// The probability of amounts being the same is
// the number of times s1==s2 (n+1) divided
// by how many times we use the same set og banknotes 
float proba=(n+1)/total;

execute
{
writeln(proba);
}