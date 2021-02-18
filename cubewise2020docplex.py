'''

// Solution to the Cubewise 2020 challenge

CUBE+WISE=MORE

Use each number between  0 -> 9 only once, to replace the letters in the sentence.

(for example C=1, U=3, W=4, ….)

The sum must be correct, each number must be used EXACTLY once. 
With the correct sum, there are many solutions. 
But which solution has the highest value for the letters R, O and I?

Target: Maximize the value of ROI. There is only 1 correct maximum value for ROI. 
What number (like 123) corresponds to the letters ROI?

'''


#use of cplex docplex cpoptimizer
from docplex.cp.model import CpoModel

mdl = CpoModel(name='cubewise')

#decision variables
C = mdl.integer_var(1,9,name='C')
U = mdl.integer_var(0,9,name='U')
B = mdl.integer_var(0,9,name='B')
E = mdl.integer_var(0,9,name='E')
W = mdl.integer_var(1,9,name='W')
I = mdl.integer_var(0,9,name='I')
S = mdl.integer_var(0,9,name='S')
M = mdl.integer_var(1,9,name='M')
O = mdl.integer_var(0,9,name='O')
R = mdl.integer_var(0,9,name='R')

CUBE=1000*C+100*U+10*B+E
WISE=1000*W+100*I+10*S+E
MORE=1000*M+100*O+10*R+E
ROI=100*R+10*O+I

#constraints
mdl.add(CUBE+WISE==MORE)
mdl.add(mdl.all_diff(C,U,B,E,W,I,S,M,O,R))

#objective
mdl.maximize(ROI)

#solve
msol=mdl.solve()

CUBE=1000*msol[C]+100*msol[U]+10*msol[B]+msol[E]
WISE=1000*msol[W]+100*msol[I]+10*msol[S]+msol[E]
MORE=1000*msol[M]+100*msol[O]+10*msol[R]+msol[E]
ROI=100*msol[R]+10*msol[O]+msol[I]                      

#display
print("The result is ")
print(CUBE,"+",WISE,"=",MORE," and ROI = ",ROI) 
