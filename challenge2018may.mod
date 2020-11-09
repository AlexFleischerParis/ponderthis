using CP;

int nbTrials=4;
range trials=1..nbTrials;

int n=11;
range coins=1..n;

tuple comb // the light ones
{
int x;
int y;
}

{comb} combs={<i,j> | ordered i,j in coins}; // i and j are the bad coins

dvar boolean x[trials][coins][1..2]; // 4 trials n coins right and left side

dvar int y[combs][trials] in -1..1; // result of the weight -1 : less 0 : equal 1 : more


subject to
{
// same number of coins both side

forall(i in trials) sum(j in coins) x[i][j][1]==sum(j in coins) x[i][j][2];

// a coin is either left or right or not there

forall(i in trials) forall(j in coins) x[i][j][1]+x[i][j][2]<=1;

// not empty
forall(i in trials) sum(j in coins) x[i][j][1]!=0;

// results of the balance
forall(c in combs) 
	forall(i in trials) 
		y[c][i]
		==
		sgn(x[i][c.x][1]+x[i][c.y][1]-x[i][c.x][2]-x[i][c.y][2]);

// To be able to find the fraud
forall(ordered c1,c2 in combs) or(i in trials) (y[c1][i]!=y[c2][i]);

}

execute
{
function display(v)
{
return String.fromCharCode(64+v);
}

for(i in trials)
{
  for(var j in coins) if (x[i][j][1]==1) write(display(j));
  write("-");
  for(var j in coins) if (x[i][j][2]==1) write(display(j));
  writeln();
}
}
