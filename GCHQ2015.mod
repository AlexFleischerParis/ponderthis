/*
the puzzle is
https://www.gchq.gov.uk/news/christmas-card-cryptographic-twist-charity
*/

using CP;

 

{string} Dimensions = {"Horizontal","Vertical"};

int GridSize = ...;

int MaxBlocks = ftoi(floor((GridSize + 1) / 2));

range GridIndex = 1..GridSize;

range BlockIndex = 1..MaxBlocks;

 

int GridStart[GridIndex][GridIndex] = ...;

int BlockSizesRequired[Dimensions][GridIndex][BlockIndex] = ...;

int nbBlocks[d in Dimensions][g in GridIndex]=sum(b in BlockIndex) 
(0!=BlockSizesRequired[d][g][b]);

int total[d in Dimensions][g in GridIndex]=sum(b in BlockIndex) 
(BlockSizesRequired[d][g][b]);

assert sum(g in GridIndex) total["Horizontal"][g]==
sum(g in GridIndex) total["Vertical"][g];




dvar int start[Dimensions][GridIndex][BlockIndex] in GridIndex;
dvar boolean x[GridIndex][GridIndex];



subject to
{
ctGridStart:
forall(i,j in GridIndex:GridStart[i][j]==1) x[i][j]==1;

ctSpaceBetweenBlocks:
 forall(d in Dimensions)
   forall(g in GridIndex)
   forall(b in 1..nbBlocks[d][g]-1)
     start[d][g][b]+BlockSizesRequired[d][g][b]+1<=start[d][g][b+1];
     
     
ctHorizontal:
forall(g in GridIndex)
   forall(b in 1..nbBlocks["Horizontal"][g])
     forall(i in 1..BlockSizesRequired["Horizontal"][g][b])
       x[g][i-1+start["Horizontal"][g][b]]==1;
       
forall(g in GridIndex)
   forall(b in 1..nbBlocks["Horizontal"][g]-1)
       x[g][BlockSizesRequired["Horizontal"][g][b]+start["Horizontal"][g][b]]==0;
       
ctvertical:
forall(g in GridIndex)
   forall(b in 1..nbBlocks["Vertical"][g])
     forall(i in 1..BlockSizesRequired["Vertical"][g][b])
       x[i-1+start["Vertical"][g][b]][g]==1;
       
       forall(g in GridIndex)
   forall(b in 1..nbBlocks["Vertical"][g]-1)
     
       x[BlockSizesRequired["Vertical"][g][b]+start["Vertical"][g][b]][g]==0;
       
       
forall(g in GridIndex) 
 ctTotalHorizontal:
 count(all(j in GridIndex)x[g][j],1)==total["Horizontal"][g];     
 
 forall(g in GridIndex) 
 ctTotalVertical:
 count(all(j in GridIndex)x[j][g],1)==total["Vertical"][g];  
 
 forall(g in GridIndex) 
 ctTotalHorizontal2:
 count(all(j in GridIndex)x[g][j],0)==GridSize-total["Horizontal"][g];     
 
 forall(g in GridIndex) 
 ctTotalVertical2:
 count(all(j in GridIndex)x[j][g],0)==GridSize-total["Vertical"][g];  
       
} 

execute
{
for(var j in GridIndex)
{
  for(var i in GridIndex) 
  if (x[j][i]==1) write("#"); 
  else write(" ");
  writeln();
}
}


// in order to have a nice display
tuple sequence_like {
   int start;
   int end;
   string label;
   int type;
 };   
 



{sequence_like} array2[i in GridIndex] = {<j-1,j," ",x[i][j]> | j in GridIndex : x[i][j]==1};

  
  execute noname {
    
   array2;
} 
