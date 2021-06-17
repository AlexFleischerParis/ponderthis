/*

Place two equal-sized armies of black and white queens on a chessboard so that 
the queens of different colours do not attack each-other and 
to find the maximum size of two such armies.

*/
using CP;

include "queenarmies.mod";



main
{
  thisOplModel.generate();
  var nbQueens=1;
  while (1==1)
  {
    thisOplModel.nbQueens.LB=nbQueens;
    thisOplModel.nbQueens.UB=nbQueens;
    if (!cp.solve()) break;
    nbQueens=nbQueens+1;
  }
  nbQueens=nbQueens-1;
  thisOplModel.nbQueens.LB=nbQueens;
  thisOplModel.nbQueens.UB=nbQueens;
  cp.solve();
  writeln(nbQueens);
  thisOplModel.postProcess();
}

/*

gives

 BB     
  BB    
     WWW
B       
BB      
BB      
    WWW 
     WWW
     
     */
