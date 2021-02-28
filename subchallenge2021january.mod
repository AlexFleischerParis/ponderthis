// size of the board
int n=50;
range r=0..n-1;
// steps in propagation
range steps=1..20000;

// cells status
int cell[i in r][j in r]=0;

// stating cells
int ax=...;
int bx=...;
int ay=...;
int by=...;

execute
{
  cell[ax][ay]=-1;
  cell[bx][by]=-1;
}

tuple move
{
  int deltax;
  int deltay;
}

// 4 possible moves for the robot
move moves[1..4]=[<0,-1>,<1,0>,<0,1>,<-1,0>];

// starting point of the robot
int x=0;
int y=0;
int direction=1;

execute
{
  function display()
  {
    for(var j in r) 
    {
      

      for(var i in r) 
      {
        var ch="";
        if (cell[i][j]!=-1) ch=cell[i][j];
        else ch="B";
        if ((i==x) && (j==y)) write("[",ch,"]");
        else write(" ",ch," ");
      }      
      writeln();
    }
    writeln();
  }
  
  // move the robot
  
  /*
  
  If the cell was vaccinated 0 times, it administers one dose 
  (raising the cell's status from "0" to "1") and turns 90 degrees CLOCKWISE.
  If the cell was vaccinated 1 time, it administers one dose 
  (raising the cell's status from "1" to "2") and turns 90 degrees COUNTERCLOCKWISE.
  If the cell was vaccinated 2 times, the robot does not change direction.

  The robot then takes one step in the direction it is currently facing. 
  If the step takes it out of the grid, it returns from the other side 
  (i.e., coordinate arithmetic is modulo N).
  Here is an example of how the robot acts on a 4x4 grid for the first few steps 
  (the cell (0,0) is pictured at the top-left corner). 
  The current cell is marked by square brackets; recall that the robot begins by facing upwards.
  
  */
  function process()
  {
    
    
    if (cell[x][y]==0)
    {
      cell[x][y]=1;
      direction+=1;
      if (direction==5) direction=1;
    }
    else if (cell[x][y]==1)
    {
      cell[x][y]=2;
      direction-=1;
      if (direction==0) direction=4;
    }
    else if (cell[x][y]==-1)
    {
      direction-=1;
      if (direction==0) direction=4;
    }
    
    x+=moves[direction].deltax;
    y+=moves[direction].deltay;
    if (x==-1) x=n-1;
    if (y==-1) y=n-1;
    if (x==n) x=0;
    if (y==n) y=0;
  }
  
  //display();
  for (var i in steps)
  {
    process();
  //display();
  }
  //display();
}

// Number of cells where they got 2 vaccines
int nb2=sum(i,j in r) (2==cell[i][j]);

execute
{
  nb2;
  //writeln("nb2=",nb2);
}



