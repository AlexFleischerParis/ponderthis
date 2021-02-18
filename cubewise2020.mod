// Solution to the Cubewise 2020 challenge

/*

CUBE+WISE=MORE

Use each number between  0 -> 9 only once, to replace the letters in the sentence.

(for example C=1, U=3, W=4, �.)

The sum must be correct, each number must be used EXACTLY once. 
With the correct sum, there are many solutions. 
But which solution has the highest value for the letters R, O and I?

Target: Maximize the value of ROI. There is only 1 correct maximum value for ROI. 
What number (like 123) corresponds to the letters ROI?

*/
using CP;

range r=0..9;
range rwithout0=1..9;
dvar int C in rwithout0;
dvar int W in rwithout0;
dvar int M in rwithout0;
dvar int U in r;
dvar int B in r;
dvar int E in r;
dvar int I in r;
dvar int S in r;
dvar int O in r;
dvar int R in r;

dvar int CUBE;
dvar int WISE;
dvar int MORE;
dvar int ROI;

maximize ROI;
subject to {
CUBE+WISE==MORE;

ROI==100*R+10*O+I;
CUBE == 1000*C+100*U+10*B+1*E;
WISE == 1000*W+100*I+10*S+1*E;
MORE == 1000*M+100*O+10*R+1*E;

// all letters are different
allDifferent(append(C,U,B,E,W,I,S,M,O,R));
}

execute {
writeln("CUBE = ",CUBE);
writeln("WISE = ",WISE);
writeln("MORE = ",MORE);
writeln("ROI=",ROI);
writeln();
}

