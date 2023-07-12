int consta = 1103515245;
int constc = 12345;
int constm = ftoi(pow(2,31));

int n=100;
int a=3;
int b=5;
int c=1;

{int} stest={t | t in 1..n,x in 0..n div 2-1
 : t==((consta*(a*b*c+x)+constc) mod constm) mod n};
 
 execute
 {
   writeln(stest);
 }
 
 int k=30;
 range K=1..k;
 range T=1..n;
 

 sorted {int} s[a in K][b in K][c in K];
 
 range rangex=0..n div 2 -1;
 
 execute
 {
   
   function f(x)
   {
     return ((consta*x+constc) % constm);
   }
   
   for(var a in K)
   for(var b in K)
   for(var c in K)
   {
     for(var x in rangex) 
     {
       var v=f(a*b*c+x) % n;
       if (v==0) v=n;
       
         if (v >=a+b+c-2) // time to reach a cell
         if (v<=a+b+c+20)
         if (a<=b) // break sym
         if (b<=c)
        s[a][b][c].add(v);
     }
   }  
 }
 
 
 
 int timeforcheese[a in K][b in K][c in K][t in T]=t in s[a][b][c];

 // 2 minutes time limit
 execute
 {
   cp.param.timelimit=120; 
 }
 
 
 
using CP;

range move=1..4;

int xmove[move]=[1,0,0,0];
int ymove[move]=[0,1,0,0];
int zmove[move]=[0,0,1,0];

// The main decisioin variable
dvar int moves[1..n-1] in move;

// Where is the mouse at a given time ? x,y,z
dvar int x[T] in K;
dvar int y[T] in K;
dvar int z[T] in K;

// Time to eat cheese ?
dvar boolean eats[T];



execute{
  var f = cp.factory;
 
   var phase1 = f.searchPhase(moves,f.selectSmallest(f.varIndex(moves))
   ,f.selectRandomValue() ); 
             
                                                                                                     
   cp.setSearchPhases(phase1);
   
   
  
}

dexpr int totalcheese=count(eats,1);

// The goal
maximize totalcheese;

subject to
{
// in order to help not to get lost
 forall(i in 36..99) eats[i]==1;
  count(moves,4)<=12;
 

  // Can help the solve too
  
  count(moves,1)<=k-1;
  count(moves,2)<=k-1;
  count(moves,3)<=k-1;
  
  
  // the mouse is starting at cell 1,1,1
  
  x[1]==1;
  y[1]==1;
  z[1]==1;
  
  forall(t in T:t>=2)
  {
    x[t]==1+count(all(i in 1..t-1)moves[i],1);
    y[t]==1+count(all(i in 1..t-1)moves[i],2);
    z[t]==1+count(all(i in 1..t-1)moves[i],3);
    
    // break sym
    x[t]<=y[t];
    y[t]<=z[t];
    
    
  }
    
  // moves
 
  forall(i in 1..n-1)
  {
    x[i]+xmove[moves[i]]==x[i+1];
    y[i]+ymove[moves[i]]==y[i+1];
    z[i]+zmove[moves[i]]==z[i+1];
  }  
  
  // To eat cheese you need to have the right cheese at the right time
  forall(t in T)
    eats[t]<=timeforcheese[x[t]][y[t]][z[t]][t];
    
    
// You cannot eat twice the same cheese
     
forall(ordered i,j in 1..n)
 ((eats[i]==1) && (eats[j]==1) ) =>
  (x[i]+y[i]+z[i]!=x[j]+y[j]+z[j]) ;




}

// Display solution

string conv2[1..4]=["R","U","F","W"];

execute
{
  writeln(totalcheese);
  for(i in T) if (i!=n) write(conv2[moves[i]]);
  writeln();
}

/*

gives

87
WFWWWUFWUFWRWWWFFFFWURFFFWFFUFFWUURRFFRFUUURRUFUUUFRUFURFFUFRUFUUUURRRURURFRRFRRUUFURRRRRRRFFURUURR


*/




