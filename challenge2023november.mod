
using CP;

int n=4;
range r=1..4;


// matrix start
int start[i in 1..4][j in 1..4]=((i-1)*n+(j-1)+1) mod 16;

execute
{
  start[4][3]=14;
  start[4][2]=15;
  writeln(start);
}

// number of moves
int nbsteps=50;
range steps=1..nbsteps;
range steps0=0..nbsteps;

int x0=4;
int y0=4;

// 4 kind of moves
range moves=1..4;

int xmove[moves]=[1,-1,0,0];
int ymove[moves]=[0,0,1,-1];

// which move
dvar int move[steps] in moves;
// which cell ?
dvar int x[steps0] in r;
dvar int y[steps0] in r;

// all cells value after step s
dvar int cell[s in steps0][i in r][j in r] in 0..n*n-1;

// goal
dvar boolean ok[steps][1..10];


// search phase to decide how to branch
execute{
  var f = cp.factory;
  
  

   var phase1 = f.searchPhase(move,f.selectSmallest(f.varIndex(move))
  ,f.selectRandomValue() ); 
  
   var f = cp.factory;
  

        
                                                                                                     
  cp.setSearchPhases(phase1);
   
  cp.param.DefaultInferenceLevel=6;
  cp.param.SearchType=24;
}

dexpr int sumok[s in steps]=sum(k in 1..10) ok[s][k];

maximize max(s in nbsteps-10..nbsteps) sum(k in 1..10) ok[s][k];


subject to
{
  // Define what the goal is
  forall(s in steps)
  {  
    forall(k in 1..4) ok[s][k]==(30==sum(i in r) cell[s][i][k]);
    forall(k in 5..8) ok[s][k]==(30==sum(i in r) cell[s][k-4][i]);
    ok[s][9]==(30==sum(i in r) cell[s][i][i]);
    ok[s][10]==(30==sum(i in r) cell[s][i][n+1-i]);
  }   
  
  
  // Starting point
  x[0]==x0;
  y[0]==y0;
  
  ok[nbsteps][1]==1;
  ok[nbsteps][2]==1;
  ok[nbsteps][3]==1;
  ok[nbsteps][4]==1;
  
  
  // x, y and cell are derived from moves
  inferred(cell);
  inferred(x);
  inferred(y);
  
  forall(i,j in r) cell[0][i][j]==start[i][j];
  
  forall(s in steps)
    {
      x[s]==x[s-1]+xmove[move[s]];
      y[s]==y[s-1]+ymove[move[s]];
    }
    
    forall(s in steps) forall(i,j in r) 
    ((i!=x[s]) || (j!=y[s])) && ((i!=x[s-1]) || (j!=y[s-1])) => (cell[s][i][j]==cell[s-1][i][j]);
    
    forall(s in steps) cell[s][x[s]][y[s]]==0;
    forall(s in steps) cell[s][x[s-1]][y[s-1]]==cell[s-1][x[s]][y[s]];
    
    // Do not go back
    forall(s in steps:s!=1)
      {
        (move[s-1]==1) => (move[s]!=2);
        (move[s-1]==2) => (move[s]!=1);
        (move[s-1]==3) => (move[s]!=4);
        (move[s-1]==4) => (move[s]!=3);
      }
      
   forall(ordered s1,s2 in steps) or(i,j in r) cell[s1][i][j]!=cell[s2][i][j];  
   forall(s in steps) allDifferent(all(i,j in r) cell[s][i][j]); // redundant
}

int target=max(s in nbsteps-10..nbsteps) sum(k in 1..10) ok[s][k];

// Display result
execute
{
  
  writeln("Initial situation ");
  for(var i in r)
    {
      for(var j in r) write(cell[0][i][j]," ");
      writeln();
    }
  
  
  var finish=0;
  write("[ ");
  for(var s in steps) if (finish!=1) 
  {
    write(cell[s][x[s-1]][y[s-1]]," , ");
    if (sumok[s]==target) 
    {
    writeln("]");  
    writeln("ok : ",sumok[s]);
    for(var i in r)
    {
      for(var j in r) write(cell[s][i][j]," ");
      writeln();
    }
    
    finish=1;
    }    
  }
}

/*

which gives

1 2 3 4
5 6 7 8
9 10 11 12
13 15 14 0
[ 14 , 11 , 12 , 8 , 7 , 6 , 5 , 9 , 10 , 5 , 9 , 10 , 13 , 15 , 5 , 13 , 15 , 5 , 11 , 14 , 8 , 12 , 13 , 11 , 14 , 13 , 6 , 3 , 4 , 7 , 12 , 6 , 3 , 9 , 2 , 4 , 7 , 12 , 6 , 3 , 13 , 8 , 3 , 6 , 9 , 2 , 4 , 1 , 10 , 15 , ]
ok : 10
10 1 7 12
15 4 2 9
0 11 13 6
5 14 8 3

*/

