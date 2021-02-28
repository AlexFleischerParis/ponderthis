
int n=50;
range r=0..n-1;

main
{
  
var maxnb2=0;
var maxax=0;
var maxay=0;
var maxbx=0;
var maxby=0;

var source = new IloOplModelSource("subchallenge2021january.mod");
  var cplex = new IloCplex();
  var def = new IloOplModelDefinition(source);
 
  // iterate on starting cells
  for(var ax in thisOplModel.r) for(bx=ax+1;bx++;bx<=thisOplModel.n-1)
  for(ay in thisOplModel.r) for(by in thisOplModel.r) 
  {
     
     var opl2 = new IloOplModel(def,cplex);
     var data2= new IloOplDataElements();
     data2.ax=ax;
     data2.ay=ay;
     data2.bx=bx;
     data2.by=by;
     opl2.addDataSource(data2);
     opl2.generate();
     // And then call submodel without solve
     // We store the solution only if we improve number of 2 vaccinations cells
     if (opl2.nb2>maxnb2)
     {
       maxnb2=opl2.nb2;
       maxax=ax;
       maxbx=bx;
       maxay=ay;
       maxby=by;
       writeln("max ",maxnb2);
       writeln("[(",ax,",",ay,"),(",bx,",",by,")]");
       if (opl2.nb2==opl2.n*opl2.n-2)
       {
         writeln();
         writeln("And the solution is ");
         writeln("[(",ax,",",ay,"),(",bx,",",by,")]");
         fail();
       }
     }
  }  
}

/*

which gives

max 1873
[(0,0),(2,0)]
max 2340
[(0,2),(2,1)]
max 2381
[(0,2),(2,49)]
max 2445
[(0,3),(2,6)]
max 2456
[(0,6),(2,47)]
max 2462
[(0,8),(2,14)]
max 2474
[(0,11),(2,28)]
max 2478
[(0,42),(2,13)]
max 2480
[(0,11),(3,14)]
max 2498
[(0,32),(3,31)]

And the solution is
[(0,32),(3,31)]

*/