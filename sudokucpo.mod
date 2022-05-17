using CP;

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

dvar int x[1..9][1..9] in 1..9; // unfixed variables

subject to {
  forall (i in 1..9, j in 1..9:input[i,j] != 0)
      input[i,j] == x[i,j]; // fix variables

  forall (idx in 1..9)
  {
    allDifferent(all (i in 1..9) x[idx,i]); // horizontal
    allDifferent(all (i in 1..9) x[i,idx]);  // vertical
    allDifferent(all (i in 1..3, j in 1..3) x[((idx-1) div 3)*3 + i][((idx-1) % 3)*3 + j]); // sub squares
 }   
};

