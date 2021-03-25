/*

step 2 for http://www.research.ibm.com/haifa/ponderthis/solutions/June2019.html

2 steps:

1) Use MIP to find a solution that is less than 1e-5

2) And then use CPO to turn that into a good solution for 1e-15 

Here step 2

*/

using CP;

execute
{
cp.param.timelimit=120;
}

{int} p={2,3,5,7};
int n=1;

int maxy=10;

range r=0..n;

sorted {int} smooths={ ftoi(pow(2,a)*pow(3,b)*pow(5,c)*pow(7,d)) | a,b,c,d in r};
{int} sqr=smooths; // diff {1};


int nbCubeGoodSquares=...;

range goodsquares=1..nbCubeGoodSquares;
int cubeGoodSquares[goodsquares]=...;

dvar int y[goodsquares] in 1..1000000;
dvar int squaresmooth[goodsquares];
dvar int s[goodsquares] in -1..1;
dvar int multiplier[smooths];

range r4=1..4;

dvar int power[smooths][r4][p] in 0..8;
dvar boolean needed[smooths][r4]; // do we need that term ?
dvar int term[smooths][r4];

minimize sum(i in smooths,j in r4) needed[i][j];
subject to
{
forall(i in goodsquares)
{
squaresmooth[i] in sqr;
cubeGoodSquares[i]==y[i]*y[i]*s[i]*squaresmooth[i];
}

forall(i in smooths) multiplier[i]==sum(j in goodsquares) (squaresmooth[j]==i)*y[j]*s[j];

// and now decompose the multipliers as sum of smooth numbers

forall(i in smooths)
{
ftoi(abs(multiplier[i]))==sum(j in r4) needed[i][j]*term[i][j];
forall(j in r4)term[i][j]==prod(k in p)ftoi(pow(k,power[i][j][k]));
}

}

execute
{
writeln("the cube");
for(var i in smooths) if (multiplier[i]!=0) writeln(multiplier[i]," * sqr of ",i);
}

 

{int} list1={  term[i][j]*term[i][j]*i     | i in smooths,j in r4 : (multiplier[i]>=1) && (1==needed[i][j])};
{int} list2={  term[i][j]*term[i][j]*i     | i in smooths,j in r4 : (multiplier[i]<=-1) && (1==needed[i][j])};

execute
{
writeln();
writeln("So the two lists are ");

writeln(list1);
writeln(list2);
} 
