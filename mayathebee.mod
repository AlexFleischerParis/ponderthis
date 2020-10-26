//using CP; // works fine with CPOptimizer too
// works fine with the free CPLEX community edition

    int n=7;
     
     tuple link  // a link between 2 cells
     {
     int i1;
     int j1;
     int i2;
     int j2;
     }
     
     // all links between adjacent cells
     {link} links=
     {<i1,j1,i2,j2> | i1,j1,i2,j2 in 1..n :
      ((i1!=i2) || (j1!=j2)) && (abs(i2-i1)<=1) && (abs(j2-j1)<=1)
      && ((j2-j1)!=(i2-i1))      };
     
    int nbLinks[i in 1..n, j in 1..n]=card({<i,j,i2,j2> |<i,j,i2,j2> in links} );  

    assert nbLinks[1,1]==2;
    assert nbLinks[n,n]==2;
    assert nbLinks[1,n]==3;
    assert nbLinks[n,1]==3;

    assert forall(i,j in 2..n-1) nbLinks[i,j]==6; // hex game!
    assert forall(i in 2..n-1) nbLinks[1,i]==4;
    assert forall(i in 2..n-1) nbLinks[i,1]==4;
    assert forall(i in 2..n-1) nbLinks[n,i]==4;
    assert forall(i in 2..n-1) nbLinks[i,n]==4;

     // is a given cell colored ? Yes or no ?
     dvar boolean x[1..n][1..n];
     // the objective
     dvar int nbColoredCells;
     
     maximize nbColoredCells;
     subject to
     {
     
     //objective is the sum of colored cells
     nbColoredCells==sum(i,j in 1..n) x[i][j];
     
     // for all cells if the cell is colored then exactly 2 adjacent cells are colored
      forall(i,j in 1..n)
        (x[i][j]==1)=>(2==sum(i2,j2 in 1..n:<i,j,i2,j2> in links)x[i2][j2]);
     } 

/*

which gives

    nbColoredCells = 30;
    x = [[1 1 0 1 1 1 1]
                 [1 0 1 0 0 0 1]
                 [0 1 0 1 1 0 1]
                 [1 0 1 0 1 0 1]
                 [1 0 1 1 0 1 0]
                 [1 0 0 0 1 0 1]
                 [1 1 1 1 0 1 1]]; 
                 
                 */
