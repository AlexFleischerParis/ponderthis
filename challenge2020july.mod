using CP;


int fib[0..40];

// use scripting to compute Fibonacci numbers
execute
{
  fib[0]=0;
  fib[1]=1;
  for (var i=2;i<41;i++) 
  {
   
  fib[i]=fib[i-1]+fib[i-2];
 }  
}

// let s try first with 10 letters max
int nbLetters=10;
range letters=1..nbLetters;

int nbLevels=10;
range levels=0..nbLevels;

//"A": "ALF", "L": "LMD", "F": "FA", "M": "MM", "D": "DLT", "T": "TAV", "V": "VAV"

// how many times do we use the second letter for the first letter ? x[1][2] means 
// how many times do we use letter 2 to name the letter 1
dvar int+ x[letters][letters] in 0..20;

// how many of that letter is used at that level
dvar int+ y[levels][letters];

dvar int nbUsedLetters;

minimize nbUsedLetters;
subject to
{
  forall(i in 1..nbLetters) (i>=nbUsedLetters+1) => (0==sum(l in letters) x[i][l]);
  forall(i in 1..nbLetters) (i>=nbUsedLetters+1) => (0==sum(l in letters) x[l][i]);

  y[0][1]==1;
  forall(i in letters:i!=1) y[0][i]==0;

  // compute y
  forall(l in levels:l!=0,l1 in letters) 
     y[l][l1]==sum(l2 in letters) x[l2][l1]*y[l-1][l2];

  // link y and Fibonacci numbers
  forall(l in levels) fib[l+1]*fib[l+2]==sum(l1 in letters) y[l][l1];
}

execute
{
  
  function visu(i)
  {
    
    return String.fromCharCode(64+i);
  }  
  
 
  writeln("fib = ",fib);
 
  
  write("{");
  for(var l in letters) if (l<=nbUsedLetters)
  {
    write("\"",visu(l),"\":");
    write("{");
    for(var l2 in letters) if (x[l][l2]>=1) write(visu(l2));
    for(var l2 in letters) if (x[l][l2]==2) write(visu(l2));
    write("},");
  }
  writeln("}");
}

/*

which gives

{"A":{AB},"B":{AC},"C":{ACA},

*/
