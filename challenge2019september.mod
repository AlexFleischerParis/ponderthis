/*

IBM Research September 2019 ponder this challenge

The US dollar has five common banknote denominations: 1, 5, 10, 20, and 50.
Each integer dollar value between 0 and 99 dollars can be paid in a unique way with a minimal number of notes.
If Alice and Bob each have different amounts of money, they still can have the same set of notes.
For example, if Alice has $92 and Bob has $74 (in a minimal number of notes), they both have the same set of banknotes {1,20,50}.
Let's assume that Alice and Bob have two different random amounts of money uniformly distributed in the [0,99] range with a minimal number of banknotes.
The probability that they have the same set of banknotes is approximately 3.79798%.

Your task, this month, is to find another set of five banknotes such that:

    Each integer dollar value between 0 and 99 dollars can be paid in a unique way with a minimal number of notes; and
    The probability above (same set of banknotes for two different random amounts of money uniformly distributed in the [0,99] range) would be exactly 4%.


*/

    main {
      var source = new IloOplModelSource("subchallenge2019September.mod");
      var cplex = new IloCplex();
      cplex.mipdisplay=0;
      var def = new IloOplModelDefinition(source);
     
     var n=50; // Should be 99 but let s first try with 50
     
     
      // Loop for banknotes
      for(var a=1;a<=n;a++) 
      for(var b=a+1;b<=n;b++) 
      for(var c=b+1;c<=n;c++) 
      for(var d=c+1;d<=n;d++) 
      for(var e=d+1;e<=n;e++) 
      {
      var opl = new IloOplModel(def,cplex);
        
      var data2= new IloOplDataElements();
      data2.a=a;
      data2.b=b;
      data2.c=c;
      data2.d=d;
      data2.e=e;
      opl.addDataSource(data2);
      opl.generate();

      if (cplex.solve()) {  
         writeln(a, " ",b," ",c," ",d," ",e);
         opl.postProcess();
         if (opl.Ok==1)
         {
         var temp=opl.obj.solutionValue;
         

         opl.totalUB.UB=temp;
         opl.totalUB.LB=temp;
         opl.totalLB.UB=temp; 
         opl.totalLB.LB=temp;
         writeln("obj=",temp);
         opl.ct1.setCoef(opl.obj,-1);
         opl.ct2.setCoef(opl.obj,1);
         cplex.tilim=20;
         
        
         cplex.solve();
         // Use of solution pool to count the number of solutions
         if (cplex.populate()) {
           var nsolns = cplex.solnPoolNsolns;
           writeln("Number of solutions found = ",nsolns);
           writeln();
           if (nsolns==1)
           
           {
             
             writeln("solution");
             writeln(a, " ",b," ",c," ",d," ",e);
             fail();  
           }                   
         }
         
       }         
         
      } else {
         writeln("No solution");
      }
     opl.end();
    }  
     
    }

/*

which gives


solution
1 2 4 30 48

*/


