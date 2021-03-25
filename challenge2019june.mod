/*

step 1 for http://www.research.ibm.com/haifa/ponderthis/solutions/June2019.html

2 steps:

1) Use MIP to find a solution that is less than 1e-5

2) And then use CPO to turn that into a good solution for 1e-15 

*/
main
{
  var source = new IloOplModelSource("challenge2019junestep1.mod");
  var cplex = new IloCplex();
  var def = new IloOplModelDefinition(source);
  var opl = new IloOplModel(def,cplex);
  
  opl.generate();
  if (cplex.solve()) {
     writeln("OBJ = " + cplex.getObjValue());
  } else {
     writeln("No solution");
  }
  opl.postProcess();
  
  var source2 = new IloOplModelSource("challenge2019junestep2.mod");
  var cp = new IloCP();
  var def2 = new IloOplModelDefinition(source2);
  var opl2 = new IloOplModel(def2,cp);
  var data2 = new IloOplDataSource("cubeGoodSquares.dat");
  opl2.addDataSource(data2);
  opl2.generate();
  if (cp.solve()) {
     writeln("OBJ = " + cp.getObjValue());
  } else {
     writeln("No solution");
  }
  opl2.postProcess();
  
}  

/*

which gives

So the two lists are 
 {48020 95703125 512000 8573040 1620304560 47840625 6827950080}
 {14288400 96446700 301327047 4900921200 496011600 408410100}

or

{14288400 96446700 301327047 4900921200 496011600 408410100}
 {512000 62233920 4465125 8573040 1620304560 6827950080 47840625}
 
 */
