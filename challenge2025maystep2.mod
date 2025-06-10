/*
Step 2 : use Linear Programming (hammer) 
to compute x out of answers from students
*/

range persons=1..8;
int nbquestions=10;
range questions=1..nbquestions;

dvar int+ x[persons] in 1..10000;
dvar int p in 1..10000;
int answers[questions]=...;



subject to
{
  
(5*x[2] + 7*x[3] + 5*x[5] + 3*x[6]) == answers[1];
(8*x[1] + 5*x[2] + 2*x[5] + 5*x[8] ) == answers[2];
(7*x[1] + 4*x[2] + 5*x[4] + 2*x[5] ) == answers[3];
(7*x[1] + 9*x[3] + x[6] + x[7] ) ==answers[4];
(8*x[3] + 7*x[4] + 4*x[5] + 3*x[6] ) ==answers[5];
(2*x[3] + 5*x[4] + 5*x[6] + 5*x[7] ) ==answers[6];
(5*x[2] + 4*x[4] + 6*x[5] + 7*x[6] ) ==answers[7];
(7*x[3] + x[4] + 8*x[6] + 8*x[7] ) ==answers[8];

}

execute
{
  writeln(x);
  var o=new IloOplOutputFile("challenge2025mayx.dat");
  o.writeln("x=");
  o.writeln(x);
  o.writeln(";");
  o.close();
}

