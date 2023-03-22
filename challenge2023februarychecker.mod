using CP;

main {
  
  function write_empty_tuple_set_in_a_file(filename,tuplesetname)
  {
    var f=new IloOplOutputFile(filename);
    f.writeln(tuplesetname,"={};");
    f.close();
  }
  
  write_empty_tuple_set_in_a_file("challenge2023februarysubchecker.dat","excluded")
  for (var i=1;i<=10000;i++)
  {
  var source = new IloOplModelSource("challenge2023februarysubchecker.mod");
  var cp = new IloCP();
  var def = new IloOplModelDefinition(source);
  var opl = new IloOplModel(def,cp);
  var data = new IloOplDataSource("challenge2023februarysubchecker.dat");
    opl.addDataSource(data);
  
  opl.generate();
  if (cp.solve()) {
     //writeln("OBJ = " + cp.getObjValue());
     opl.postProcess();

  } else {
     writeln("No solution");
     writeln("Number of solutions : ",i-1);
     break;
  }
} 
}

/*

which gives

No solution
Number of solutions : 48

*/
