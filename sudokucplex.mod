using CPLEX;

int input[1..9][1..9] = [
[8, 0, 0, 0, 0, 0, 0, 0, 0],
 [0, 0, 3, 6, 0, 0, 0, 0, 0],
 [0, 7, 0, 0, 9, 0, 2, 0, 0],
 [0, 5, 0, 0, 0, 7, 0, 0, 0],
 [0, 0, 0, 0, 4, 5, 7, 0, 0],
 [0, 0, 0, 1, 0, 0, 0, 3, 0],
 [0, 0, 1, 0, 0, 0, 0, 6, 8],
 [0, 0, 8, 5, 0, 0, 0, 1, 0],
 [0, 9, 0, 0, 0, 0, 4, 0, 0]]; // initial grid

dvar boolean x[1..9][1..9][1..9]; // unfixed variables indexes : x,y,value

subject to {
  forall (i in 1..9, j in 1..9:input[i,j] != 0)
      1 == x[i,j,input[i,j]]; // fix variables
      
  forall(i,j in 1..9) sum(v in 1..9) x[i,j,v]==1;  // one and only one value per cell   

  forall (idx in 1..9) forall(v in 1..9)
  {    
    sum(i in 1..9) x[idx,i,v]==1; // horizontal
    sum(i in 1..9) x[i,idx,v]==1; // vertical
    sum(i in 1..3, j in 1..3) x[((idx-1) div 3)*3 + i][((idx-1) % 3)*3 + j][v]==1; // squares
 }   
};

int result[i in 1..9][j in 1..9]=sum(v in 1..9) v*x[i,j,v];

execute
{
  writeln(result);
}


