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



from docplex.mp.model import Model

mdl = Model(name='cubewise')

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

mdl.add(C!=U)
mdl.add(C!=B)
mdl.add(C!=E)
mdl.add(C!=W)
mdl.add(C!=I)
mdl.add(C!=S)
mdl.add(C!=M)
mdl.add(C!=O)
mdl.add(C!=R)

mdl.add(U!=B)
mdl.add(U!=E)
mdl.add(U!=W)
mdl.add(U!=I)
mdl.add(U!=S)
mdl.add(U!=M)
mdl.add(U!=O)
mdl.add(U!=R)

mdl.add(B!=E)
mdl.add(B!=W)
mdl.add(B!=I)
mdl.add(B!=S)
mdl.add(B!=M)
mdl.add(B!=O)
mdl.add(B!=R)

mdl.add(E!=W)
mdl.add(E!=I)
mdl.add(E!=S)
mdl.add(E!=M)
mdl.add(E!=O)
mdl.add(E!=R)

mdl.add(W!=I)
mdl.add(W!=S)
mdl.add(W!=M)
mdl.add(W!=O)
mdl.add(W!=R)

mdl.add(I!=S)
mdl.add(I!=M)
mdl.add(I!=O)
mdl.add(I!=R)

mdl.add(S!=M)
mdl.add(S!=O)
mdl.add(S!=R)

mdl.add(M!=O)
mdl.add(M!=R)

mdl.add(O!=R)

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
