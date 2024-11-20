using CP;
 
// Max number of figures for A and B 
int N=12;
// allowed figures
{int} allowed=asSet(1..9) diff ({5});

dvar int A[1..N] in 0..9;
dvar int B[1..N] in 0..9;

// A and B with 0s replaced by 1s
dvar int Areplaced[1..N] in 0..9;
dvar int Breplaced[1..N] in 0..9;

// a and b
dvar int a;
dvar int b;

// b square
dvar int bs;


dvar int+ p4;
dvar int+ p9;
dvar int+ p49;

// nb figures of A and B
dvar int+ nbFiguresA in 0..N;
dvar int+ nbFiguresB in 0..N;

// Minimize X is the same as minimizing the number of figures and then
// a and then b
minimize staticLex(nbFiguresA+nbFiguresB,a,b);
 
 subject to
 {
   // replacing 0s by 1s
   forall(i in 1..N) (i<=nbFiguresB)=>(B[i] in allowed);
   forall(i in 1..N) (i>=nbFiguresB+1)=>(B[i]==0);
   
   forall(i in 1..N) (i<=nbFiguresA)=>(A[i] in allowed);
   forall(i in 1..N) (i>=nbFiguresA+1)=>(A[i]==0);
   
   //  All the digits \{1,2,3,4,6,7,8,9\} appear 
   // at least once, but \{0, 5\} do not appear at all.
   
   forall(i in allowed) count(A,i)+count(B,i)>=1;
   
   // a and b as the weighted sum of their digits
   a==sum(i in 1..N) A[i]*pow(10,i-1);
   b==sum(i in 1..N) B[i]*pow(10,i-1);
   
   // modulo equations
   
   a mod ftoi(pow(9,p9))==0;
   a mod ftoi(pow(49,p49))==0;
   a mod ftoi(pow(2,2*p4-nbFiguresB))==0;
    
   // b is a perfect square with prime factors 2,3 and 7
   b==bs*bs;
   b==pow(4,p4)*pow(9,p9)*pow(49,p49);
   
   // Replace 0 by 1
   forall(i in 1..N) Areplaced[i]==(A[i])*(A[i]!=0)+(A[i]==0);
   forall(i in 1..N) Breplaced[i]==(B[i])*(B[i]!=0)+(B[i]==0);
   
   // B is the product of the digits of X
   b==prod(i in 1..N)Areplaced[i]*prod(i in 1..N)Breplaced[i];
 }
 
 execute
 {
   writeln("X=",a,b);
 }
 
 // gives X=1817198712146313216
