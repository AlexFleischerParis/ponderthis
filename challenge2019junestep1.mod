/*

step 1 for http://www.research.ibm.com/haifa/ponderthis/solutions/June2019.html

2 steps:

1) Use MIP to find a solution that is less than 1e-5

2) And then use CPO to turn that into a good solution for 1e-15 

Here step 1

*/



{int} p={2,3,5,7};
int n=1;
int n2=2;
int nbRootsMax=4;
int maxy=10;


range r=0..n;
range r2=0..n2;

{int} optionsy={ si*ftoi(pow(i,a))| i in p,a in r2,si in -1..1};


sorted {int} smooths={ ftoi(pow(2,a)*pow(3,b)*pow(5,c)*pow(7,d)) | a,b,c,d in r:a+b+c+d<=3};


{float} sqr={ sqrt(i) | i in smooths} diff {1.0};

 



dvar int y[sqr] in -maxy..maxy;

dexpr float delta=sum(i in sqr) y[i]*i;

minimize max(i in sqr) abs(y[i]*i); 


subject to
{
1<=sum(i in sqr) (y[i]!=0)<=nbRootsMax;
-1e-5<=delta<=1e-5;


forall(i in sqr) (sum(j in optionsy) (y[i]==j))==1;
}

 



execute
{

 

for(var i in sqr) if (y[i]!=0) writeln("sqrt(",i*i,") * ",y[i]);
writeln();

}

{int} goodsquares={sgn(y[i])*y[i]*y[i]*ftoi(round(i*i)) | i in sqr : y[i]!=0};

int nbCubeGoodSquares=ftoi(pow(card(goodsquares),3));

execute
{
writeln(goodsquares);
}

// But let 's use power 3 in order to get the difference less than 10 power -15

float cubeGoodSquares[i in goodsquares][j in goodsquares][k in goodsquares]=
   1.0*i*j*k;
   
execute
{
var output=new IloOplOutputFile("cubeGoodSquares.dat");
output.write("nbCubeGoodSquares=");
output.write(nbCubeGoodSquares);
output.writeln(";");
output.write("cubeGoodSquares=[");
for(var i in goodsquares) for(var j in goodsquares) for(k in goodsquares)
  output.writeln(cubeGoodSquares[i][j][k],",");
  output.writeln("];");
  output.close();

}
