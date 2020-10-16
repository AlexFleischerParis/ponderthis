/*

In the classic 3x3 tic-tac-toe game, either player can win or at least force a draw if he plays correctly.
On a 3x4 board, the first player can always win if she plays correctly, but if the players are working together, 
it is possible to get a draw.

This month we define a new game (dic-dac-doe) played on a 10x10 board by three players (X, O, and +), 
where the first to get at least three consecutive squares with their sign (horizontally, vertically or diagonally) 
- wins.Three peace-loving players are playing and trying together to get to a draw, but after 80 moves, 
an intensely competitive win-only demon takes over all of their minds and controls their remaining 20 moves, 
trying to get one of them to win. Can they play the first 80 moves in such a way that even 
the demon won't be able to prevent a draw?

Supply your answer as the status of the game after the 80th move as an 10x10 array of 'X', 'O', '+', and '.', 
where the first three symbols represent the moves of the players and the dots represent empty squares.

*/



int n=10;
range r=1..n;
range o=0..3;

// Which symbol in all cells
//dvar int x [r][r] in o;

// As a binary for MIP
dvar boolean z[r][r][o];

// for a symbol v direction d how many in the 3 cells starting at (a,b)
// all symbols should be max twice
dvar int q[v in o][d in 1..4][a in r][b in 1..n-2] in 0..2;

// opposite of the number of constraint violations
dvar int obj;
maximize obj;
subject to
{
  // exactly one value per cell
  forall(a,b in r) sum(v in o) z[a][b][v]==1;
  
//  count(x,0)==20;
//  count(x,1)==27;
//  count(x,2)==27;
//  count(x,3)==26;

sum(a,b in r) z[a][b][0]==20;
sum(a,b in r) z[a][b][1]==27;
sum(a,b in r) z[a][b][2]==27;
sum(a,b in r) z[a][b][3]==26;
  
  forall(a in r,b in 1..n-2,v in o) 
  {
     q[v][1][a][b]==sum(k in 0..2) z[a,b+k,v];                 
     q[v][2][a][b]==sum(k in 0..2) z[b+k,a,v];
  }  
  forall(a in 1..n-2,b in 1..n-2,v in o) 
  {
     q[v][3][a][b]==sum(k in 0..2) z[a+k,b+k,v];

   q[v][4][a][b]==sum(k in 0..2) z[a+k,b+2-k,v];
}
  
  // allowed triplets
  
  // maximum 1 time 0
  forall(a in r,b in 1..n-2,d in 1..2) q[0][d][a][b]<=1;
  forall(a in 1..n-2,b in 1..n-2,d in 3..4)  q[0][d][a][b]<=1;
   
  
  // if one time 0 then other values should be less than 1 time

  obj==
  
  sum(a in r,b in 1..n-2,d in 1..2) 
      ((q[0][d][a][b]==1) => 
      (3==sum(v in 1..3) (q[v][d][a][b]<=1)))
      +
  sum(a in 1..n-2,b in 1..n-2,d in 3..4) 
      ((q[0][d][a][b]==1) => 
      (3==sum(v in 1..3) (q[v][d][a][b]<=1)))
     
          
      -2*n*(n-2)-2*(n-2)*(n-2); // nb of constraints
  
  
  
}

int x [a in r][b in r]=sum(v in o) v*z[a][b][v];
string display[o]=[".","X","O","+"];

execute
{
  for(var a in r) 
  {
    for(var b in r) write(display[x[a][b]]);
    writeln();
  }
}

/*

which gives

.X+XOX.+O.
+OOX++OXX+
O.X+X.+O+O
X+X.+OOX+.
.X+OOX.+OX
OO+X.+X+.O
+.X+XXOOXX
O+X.O++X+.
.XOO+.O+.O

*/


