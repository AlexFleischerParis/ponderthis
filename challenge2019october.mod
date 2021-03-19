/*

IBM Research October 2019 ponder this challenge

Let's assume that Alice and Bob have two (possibly the same) integer amounts of money, uniformly distributed in the [0,99] range 
with a minimal number of banknotes.
Using the standard US dollar banknotes denominations of 1, 5, 10, 20, and 50, if the set of notes of Alice and Bob is the same 
- the probability of the amount being the same is about 21%.
Your task, this month, is to find the set of five banknote denominations that uniquely determines the set with the minimal 
number of notes while maximizing the above probability. 

*/

main {
      var source = new IloOplModelSource("subchallenge2019october.mod");
      var cplex = new IloCplex();
      
      var def = new IloOplModelDefinition(source);
     
     var n=51;
     
     var maxProba=0;
     
      // loop on possible banknotes
      for(var a=1;a<=n;a++) 
      for(var b=a+1;b<=n;b++) 
      for(var c=b+1;c<=n;c++) 
      for(var d=c+1;d<=n;d++) 
      for(var e=d+1;e<=n;e++) 
      
      {
      writeln(a, " ",b," ",c," ",d," ",e);      
      
      var opl = new IloOplModel(def,cplex);
        
      var data2= new IloOplDataElements();
      data2.a=a;
      data2.b=b;
      data2.c=c;
      data2.d=d;
      data2.e=e;
      opl.addDataSource(data2);
      opl.generate();
      cplex.mipdisplay=0;
      cplex.tilim=2;
      

      if (cplex.solve()) { 
       
         
         //opl.postProcess();
         var p=opl.proba;
         if (p>maxProba)
         {
         
         
         
         var temp=opl.obj.solutionValue;
         opl.obj.UB=temp;
         opl.obj.LB=temp;
         // and now we want to check that there is only one solution
         cplex.tilim=0.5;
          cplex.solve();
         if (cplex.populate()) {
           // solution pools
           var nsolns = cplex.solnPoolNsolns;
           //writeln("Number of solutions found = ",nsolns);
           //writeln();
           if (nsolns==1)
           {
           
           {
             maxProba=p;
             //writeln(a, " ",b," ",c," ",d," ",e);
             writeln("new max proba = ",maxProba);
             writeln(); 
         
             var o=new IloOplOutputFile("result.txt",false);
             o.writeln(a, " ",b," ",c," ",d," ",e);
             o.writeln(maxProba);
             o.close();       
            }           
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

1 2 8 18 32
0.297619048

*/