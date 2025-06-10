/*
Step 1 : use Constraint Programming (screwdriver) 
to compute possible answers from students
*/
using CP;

range persons=1..8;
int nbquestions=10;
range questions=1..nbquestions;
range choice=1..4; // A to D
string givenanswers[persons]=...;
int grades[persons]=...;
int multipleanswers[questions][choice]=...;

int answertoquestions[persons][questions];

execute
{
  for(var pe in persons)
  {
    var s=givenanswers[pe];
    if ((s.size!=nbquestions)) fail;
    for(var q in questions) 
    {  
      var ch=s.charAt(q-1);
      //write(ch);
      var v=0;
      if (ch=="A") v=1;
      if (ch=="B") v=2;
      if (ch=="C") v=3;
      if (ch=="D") v=4;
      if (v==0) fail();
      answertoquestions[pe][q]=v;
      
    }    
    writeln();
  }
}

dvar int+ x[persons];
dvar int+ answers[questions];

subject to
{
  
forall(pe in persons)  
(grades[pe]==sum(q in questions) (answers[q]==multipleanswers[q][answertoquestions[pe][q]]));

forall(q in questions) answers[q] in {multipleanswers[q][c] | c in choice};

}

execute
{
  writeln(answers);
  var o=new IloOplOutputFile("challenge2025mayanswers.dat");
  o.writeln("answers=");
  o.writeln(answers);
  o.writeln(";");
  o.close();
}



