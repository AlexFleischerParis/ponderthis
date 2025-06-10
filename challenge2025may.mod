main
{
  
  // 3 steps : 1 hammer and 2 screwdrivers ( linear programming and constraint programming )
  // We use files to orchestrate the 3 models but we could have used APIs
  // The files we generate are ponder2025mayanswers.dat and ponder2025x.dat
  
  // Call constraint programming in order to get the answers
  
      var source1 = new IloOplModelSource("challenge2025maystep1.mod");
      var cp1 = new IloCP();
      var def1 = new IloOplModelDefinition(source1);
      var opl1 = new IloOplModel(def1,cp1);
      var data1= new IloOplDataSource("challenge2025maystep1.dat");
      opl1.addDataSource(data1);
      opl1.generate();


      if (cp1.solve()) {  
         opl1.postProcess();
      } else {
         writeln("No solution");
      }
     opl1.end();
     
     // Call linear programming with CPLEX to compute x out of the answers, standard equations
     
      var source2 = new IloOplModelSource("challenge2025maystep2.mod");
      var cplex2 = new IloCplex();
      var def2 = new IloOplModelDefinition(source2);
      var opl2 = new IloOplModel(def2,cplex2);
      var data2= new IloOplDataSource("challenge2025mayanswers.dat");
      opl2.addDataSource(data2);
      opl2.generate();

      if (cplex2.solve()) {  
         opl2.postProcess();
      } else {
         writeln("No solution");
      }
     opl2.end();
     
     // Call constraint programming in order to get p out of x
  
     
     var source3 = new IloOplModelSource("challenge2025maystep3.mod");
      var cp3 = new IloCP();
      var def3 = new IloOplModelDefinition(source3);
      var opl3 = new IloOplModel(def3,cp3);
      var data3= new IloOplDataSource("challenge2025mayx.dat");
      opl3.addDataSource(data3);
      opl3.addDataSource(data2);
      opl3.generate();

      if (cp3.solve()) {  
         opl3.postProcess();
      } else {
         writeln("No solution");
      }
     opl3.end();
    
}

/*

which gives


 [2412 7624 637 761 2216 3499 4008 5534 1 6545]
 [2 5 7 13 269 331 353 1409]
p=8999

*/
