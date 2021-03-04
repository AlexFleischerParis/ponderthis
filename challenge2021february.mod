string s="0a8301b11b01\
1bda41b24d78\
37c09e8d5998\
60473283d3b8\
13279043d9bc\
371bf4c021c1\
1d122e800ee1\
5bc967265d88\
5f1998f5915d\
628dff094034\
39effbe6ecc8\
2c440c20e0a0";

int n=12;
int nbsteps=n*n;
range steps=1..nbsteps;

range r=1..n;
int trust[r][r];

{string} directions={"up","right","down","left"};

int movey[directions]=[0,1,0,-1];
int movex[directions]=[-1,0,1,0];

// Does i,j trust neighbour in direction d ?
int trustdir[i in r][j in r][d in directions];

// parse string s to build trustdir matrix
execute
{
  writeln(s.length);
  var s2=s;
  if (s.length!=n*n) fail();
  var index=0;
  for(var i in r) for(var j in r)
  {
    var f=parseInt(s.charAt(index),16);
    trust[i][j]=f;
    index++;
    if (f>=8)
    {
      trustdir[i][j]["up"]=1;
      f=f-8;
    }
    if (f>=4)
    {
      trustdir[i][j]["right"]=1;
      f=f-4;
    }
    if (f>=2)
    {
      trustdir[i][j]["down"]=1;
      f=f-2;
    }
    trustdir[i][j]["left"]=f;
    
  }
  
  writeln(trust);
}


// Does i,j trust neighbour in direction d and that neighbourn is in the grid ?
int trustdir2[i in r][j in r][d in directions]=(trustdir[i][j][d]==1) 
&& ((i+movex[d]) in r) && ((j+movey[d]) in r);

// number of trusted directions
int nbTrustDir[i in r][j in r]=sum(d in directions) trustdir2[i][j][d];

// set for all i,j in the grid of directions(i,j) trusts
{string} trustdirections[i in r][j in r]={d | d in directions : trustdir2[i][j][d]==1};

// people we vaccinate as a start
dvar boolean initx[r][r];

// who got the vaccine at step s
dvar boolean x[steps][r][r];

// minimize initial vaccination set
minimize sum(i,j in r) initx[i][j];

subject to
{
  // Initial vaccination
  forall(i,j in r:0!=nbTrustDir[i][j]) x[1][i][j]==initx[i][j];
  
  // If no neighbour to trust then convinced
  forall(s in steps,i,j in r: 0==nbTrustDir[i][j]) x[s][i][j]==1;
  
  // Recursive function to compute step s out od step s-1
  forall(i,j in r,s in steps:s!=1 && 0!=nbTrustDir[i][j]) 
  ((nbTrustDir[i][j]==
  sum(d in trustdirections[i][j]) x[s-1][i+movex[d]][j+movey[d]]) 
  || (initx[i][j]==1))
  == (x[s][i][j]);
  
  // everybody gets the vaccine
  forall(i,j in r:0!=nbTrustDir[i][j]) x[nbsteps][i][j]==1;
}

execute display_solution
{
  write("[");
  for(var i in r) for(var j in r) if (initx[i][j]==1) write("(",j,",",n+1-i,"),");
  writeln("]");
}

assert forall(i,j in r) as:(initx[i,j]==1) => (nbTrustDir[i][j]!=0);

/*

which gives

// solution (optimal) with objective 35
[(2,11),(4,11),(6,11),(7,11),(10,11),(8,10),(10,10),(11,10),(4,9),(10,9),(5,8),(8,8),(10,8),
(11,8),(3,7),(4,7),(11,7),(2,6),(11,6),(2,5),(4,5),(5,5),(8,5),(10,5),(2,4),(6,4),(7,4),(9,4),
(12,4),(2,3),(5,3),(11,3),(4,2),(6,2),(9,1),]


*/
