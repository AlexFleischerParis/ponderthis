// Solution to the Cubewise 2020 challenge

/*

CUBE+WISE=MORE

Use each number between  0 -> 9 only once, to replace the letters in the sentence.

(for example C=1, U=3, W=4, ….)

The sum must be correct, each number must be used EXACTLY once. 
With the correct sum, there are many solutions. 
But which solution has the highest value for the letters R, O and I?

Target: Maximize the value of ROI. There is only 1 correct maximum value for ROI. 
What number (like 123) corresponds to the letters ROI?

*/

{int} f=asSet(0..9);
{int} fwithout0=f diff {0};

tuple t
{
  int C; int U; int B; int E; int W; int I; int S; int M; int O; int R;
}

{t} cubewisemore={<c,u,b,e,w,i,s,m,o,r> | 
c in fwithout0,w in fwithout0 diff {c}, m in fwithout0 diff {c,w}, 
u in f diff {c,w,m} ,b in f diff {c,w,m,u} ,e in f diff {c,w,m,u,b},
i  in f diff {c,w,m,u,b,e},s in f diff {c,w,m,u,b,e,i} ,o in f diff {c,w,m,u,b,e,i,s},
r in f diff {c,w,m,u,b,e,i,s,o}
    : 1000*c+100*u+10*b+1*e+1000*w+100*i+10*s+1*e==1000*m+100*o+10*r+1*e};
    
int maxROI=max(sol in cubewisemore) (sol.R*100+sol.O*10+sol.I);
{t} solutions={sol | sol in cubewisemore: sol.R*100+sol.O*10+sol.I==maxROI};

execute
{
  writeln("ROI = ",maxROI);
  writeln();
  for(var sol in solutions)
  {
    maxCUBE=1000*sol.C+100*sol.U+10*sol.B+sol.E;
    maxWISE=1000*sol.W+100*sol.I+10*sol.S+sol.E;
    maxMORE=1000*sol.M+100*sol.O+10*sol.R+sol.E;
    writeln("CUBE = ",maxCUBE);
    writeln("WISE = ",maxWISE);
    writeln("MORE = ",maxMORE);
    writeln();
  }
}

/*

which gives

ROI = 958

CUBE = 1730
WISE = 2860
MORE = 4590

CUBE = 1760
WISE = 2830
MORE = 4590

CUBE = 2730
WISE = 1860
MORE = 4590

CUBE = 2760
WISE = 1830
MORE = 4590

*/
    
