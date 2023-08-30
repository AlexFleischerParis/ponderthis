int boardSize=5;
range board=1..boardSize;

int nbBlocks=9;
range blocks=1..nbBlocks;

int sizes[blocks]=[2,3,3,2,1,1,2,4,2];

assert sum(b in blocks) sizes[b]==boardSize*(boardSize-1);

tuple t
{
  int x;
  int y;
}

{t} shapes1[b in blocks]={<0,0>};
{t} shapes2[blocks]=[{<0,1>},{<1,0>,<0,1>},{<1,0>,<1,-1>},{<0,1>},{},{},{<1,0>},
{<1,0>,<2,0>,<2,-1>},{<1,0>}];

{t} shapes[b in blocks]=shapes1[b] union shapes2[b];

int xstart[blocks]=[1,2,3,5,1,2,3,3,1];
int ystart[blocks]=[1,1,2,1,3,3,3,4,4];

int xend[blocks]=[4,4,2,5,1,2,1,3,2];
int yend[blocks]=[3,1,3,2,4,5,1,5,4];

int cellstart[board][board];
int cellstart2[i in board][j in board];

execute
{
  for(b in blocks) 
  {
    for(v in shapes[b]) cellstart[xstart[b]+v.x][ystart[b]+v.y]=b;
  }
  for(i in board) for(j in board) cellstart2[i][j]=cellstart[j][i];
writeln("start :");
writeln(cellstart2);
}

int cellend[board][board];
int cellend2[i in board][j in board];

execute
{
  for(b in blocks) 
  {
    for(v in shapes[b]) cellend[xend[b]+v.x][yend[b]+v.y]=b;
  }
  for(i in board) for(j in board) cellend2[i][j]=cellend[j][i];
writeln("end :");
writeln(cellend2);
}


int nbSteps=33;

range steps=0..nbSteps;



dvar boolean xmovep[1..nbSteps][blocks];
dvar boolean ymovep[1..nbSteps][blocks];

dvar boolean xmovem[1..nbSteps][blocks];
dvar boolean ymovem[1..nbSteps][blocks];
dvar int which[1..nbSteps] in 0..nbBlocks;

dvar boolean ok[blocks];


dvar int x[steps][blocks] in board;
dvar int y[steps][blocks] in board;

dexpr int countmove[b in blocks]=sum(s in 1..nbSteps) 
(xmovem[s][b]+ymovem[s][b]+xmovep[s][b]+ymovep[s][b]);

dexpr int cost=sum(s in 1..nbSteps,b in blocks) (5-sizes[b])*
(xmovep[s][b]+xmovem[s][b]+ymovep[s][b]+ymovem[s][b]);



maximize sum(b in blocks) ok[b];




subject to
{
  cost<=100;
  
  
 
  
  forall(s in 1..nbSteps) sum(b in blocks) 
  (xmovep[s][b]+xmovem[s][b]+ymovep[s][b]+ymovem[s][b])<=1;
  forall(s in 1..nbSteps) which[s]==sum(b in blocks) b*(xmovep[s][b]+xmovem[s][b]+ymovep[s][b]+ymovem[s][b]);

  // init
  
  forall(b in blocks)
    {
      x[0][b]==xstart[b];
      y[0][b]==ystart[b];
    }
    
  
  
  // move
  
  forall(s in 1..nbSteps,b in blocks) 
  {
    
    (x[s][b]==x[s-1][b]+xmovep[s][b]-xmovem[s][b]);
   
    (y[s][b]==y[s-1][b]+ymovep[s][b]-ymovem[s][b]);
    
    (x[s][b]==xstart[b]+sum(s2 in 1..s)(xmovep[s2][b]-xmovem[s2][b]));
   
    (y[s][b]==ystart[b]+sum(s2 in 1..s)(ymovep[s2][b]-ymovem[s2][b]));
  }
  
  // no overlap
         
    forall(s in 1..nbSteps)
    forall(ordered b1,b2 in blocks)
       forall(c1 in shapes[b1],c2 in shapes[b2])
         (x[s][b2]+c2.x!=x[s][b1]+c1.x) || (y[s][b2]+c2.y!=y[s][b1]+c1.y)   ;
  
 
   
   forall(b in blocks:b in {2,3,8})
     {
       ok[b]==((x[nbSteps][b]==xend[b])
       && (y[nbSteps][b]==yend[b]));
     }
     
     ok[1]==((x[nbSteps][1]==xend[1])
       && (y[nbSteps][1]==yend[1])) || ((x[nbSteps][1]==xend[4])
       && (y[nbSteps][1]==yend[4]));
       
       ok[4]==((x[nbSteps][4]==xend[1])
       && (y[nbSteps][4]==yend[1])) || ((x[nbSteps][4]==xend[4])
       && (y[nbSteps][4]==yend[4]));
       
       ok[5]==((x[nbSteps][5]==xend[5])
       && (y[nbSteps][5]==yend[5])) || ((x[nbSteps][5]==xend[6])
       && (y[nbSteps][5]==yend[6]));
       
       ok[6]==((x[nbSteps][6]==xend[5])
       && (y[nbSteps][6]==yend[5])) || ((x[nbSteps][6]==xend[6])
       && (y[nbSteps][6]==yend[6]));
       
       ok[7]==((x[nbSteps][7]==xend[7])
       && (y[nbSteps][7]==yend[7])) || ((x[nbSteps][7]==xend[9])
       && (y[nbSteps][7]==yend[9]));
       
       ok[9]==((x[nbSteps][9]==xend[7])
       && (y[nbSteps][9]==yend[7])) || ((x[nbSteps][9]==xend[9])
       && (y[nbSteps][9]==yend[9]));
          
       
     
  
   
   forall(s in 1..nbSteps) forall(b in blocks) forall(c in shapes[b])
   {
     1<=(x[s][b]+c.x) <=boardSize;
      1<=(y[s][b]+c.y) <=boardSize;
   }
   
   // What we got from playing with lego
  

  which[1]==9;
   which[2]==5;
   which[3]==6;
   which[4]==7;
   which[5]==7;
   which[6]==8;
   which[7]==4;
   which[8]==3;
   which[9]==2;
   which[10]==3;
  which[11]==2;
  which[12]==1;
   which[13]==1;
   which[14]==7;
   which[15]==7;   
   which[16]==5;
   which[17]==6;
   which[18]==5;
 
  countmove[4]==1;
  countmove[8]==1;

 
}



int celllast[board][board];
int celllast2[i in board][j in board];

execute
{
  
 
  writeln();
  for(b in blocks) 
  {
    for(v in shapes[b]) celllast[x[nbSteps][b]+v.x][y[nbSteps][b]+v.y]=b;
  }
  for(i in board) for(j in board) celllast2[i][j]=celllast[j][i];
writeln("end :");
writeln(celllast2);
writeln(which);

for(var s in steps) if (s!=0) if (which[s]!=0)
{
  write(which[s]);
  if (xmovep[s][which[s]]==1) write("R");
  if (xmovem[s][which[s]]==1) write("L");
  if (ymovep[s][which[s]]==1) write("D");
  if (ymovem[s][which[s]]==1) write("U");
}
writeln();
writeln("cost=",cost);
}

/*

which gives

9D5D6D7L7L8D4D3D2R3D2R1R1R7U7U5U6U5U3L6L3L1D1D1R3R3U9U9R6D5D6D5D6R
cost=100

*/






