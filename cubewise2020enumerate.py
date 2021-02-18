'''

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

'''

MAXROI=0
MAXCUBE=0
MAXWISE=0
MAXMORE=0

r=range(0,10)
rwithout0=range(1,10)

# loop to check all options and take the best
for C in rwithout0:
 for U in set(r)-set([C]):
  for B in set(r)-set([C,U]):
   for E in set(r)-set([C,U,B]):
    for W in set(rwithout0)-set([C,U,B,E]):
     for I in set(r)-set([C,U,B,E,W]):
      for S in set(r)-set([C,U,B,E,W,I]):
       for M in set(rwithout0)-set([C,U,B,E,W,I,S]):
        for O in set(r)-set([C,U,B,E,W,I,S,M]):
         for R in set(rwithout0)-set([C,U,B,E,W,I,S,M,O]):
          CUBE=1000*C+100*U+10*B+E
          WISE=1000*W+100*I+10*S+E
          MORE=1000*M+100*O+10*R+E
          ROI=100*R+10*O+I
          if (CUBE+WISE==MORE) and (ROI>MAXROI):
            MAXROI=ROI
            MAXCUBE=CUBE
            MAXWISE=WISE
            MAXMORE=MORE
            print(CUBE,"+",WISE,"=",MORE," and ROI = ",ROI)                            

print("The result is ")
print(MAXCUBE,"+",MAXWISE,"=",MAXMORE," and ROI = ",MAXROI) 
