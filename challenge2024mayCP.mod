using CP;



int N=4;
int nbcards=1+N+N*N;
range cards=1..nbcards;
int nbSymbols=nbcards;
int nbSymbolsPerCard=N+1;
range symbolsPerCard=1..nbSymbolsPerCard;

dvar int x[1..nbcards][1..nbSymbolsPerCard] in 1..nbSymbols;

subject to
{  
  // break sym
  
  // enumerate math.comb(21,5)/21) times
  // cards {1,2,3,4,5}
  forall(i in 1..5) x[1][i]==i;

  forall(i in 2..5)
    {
  x[6+(i-2)*4][1]==i;
  x[7+(i-2)*4][1]==i;
  x[8+(i-2)*4][1]==i;
  x[9+(i-2)*4][1]==i;
   }  


   // math.comb(16,4)*math.comb(12,4)*math.comb(8,4)/(math.perm(4)) enumerates
   // cards {1,6,7,8,9},{1,10,11,12,13},{1,14,15,16,17},{1,18,19,20,21}
   forall(i in 2..5,j in 2..5) x[i][j]==6+(i-2)*4+(j-2);
   //(math.perm(4))**3 enumerates
   // cards {2,16,10,14,18},{2,7,11,15,19},{2,8,12,16,20},{2,9,13,17,21}
   forall(i in 2..5,j in 2..5) x[i+4][j]==6+(j-2)*4+(i-2);
  
   // break sym within a hand
   forall(i in 1..nbcards) forall(j in 1..nbSymbolsPerCard-1) x[i][j]<x[i][j+1];
  
   // intesection of any couple of cards
   forall(ordered i,j in 1..nbcards) (1==sum(k,l in 1..nbSymbolsPerCard) (x[i][k]==x[j][l]));
  
   // Break sym
  
   // order cards within a game
   forall(i in 1..nbcards-1) 
   lex(all(j in 1..nbSymbolsPerCard)x[i][j],all(j in 1..nbSymbolsPerCard)x[i+1][j]); 
}



execute
{
  writeln("x=",x);
}

main
{
      var nb=0;
    cp.param.SearchType=24;
    cp.param.workers=1;

    thisOplModel.generate();
    cp.startNewSearch();
    while
    (cp.next()) {  thisOplModel.postProcess(); nb++; writeln("nb=",nb);}
}

// which gives 12 so the result is
// 12*math.comb(16,4)*math.comb(12,4)*math.comb(8,4)*(math.perm(4))**2*math.comb(21,5)/21
// Hence the result is
// 422378820864000

