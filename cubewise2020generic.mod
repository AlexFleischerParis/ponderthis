    using CP;
    string maxobjective="ROI";
    string equation="CUBE+WISE==MORE";
    

     

    {string} unknown={};
    {string} nonzeros={};
    {string} figures={};

    execute
    {

    // ""SEND" ==> 1000*S+100*E+10*N+1*D
    function getFormula(figure)
    {
    var res="";

    for(var i=0;i<figure.length;i++)
    {
      if (i!=0) res+="+";
      res+="1";
      for(var j=i+1;j<figure.length;j++) res+="0";
      res+="*";
      res+=figure.charAt(i);
    }
    return res;
    }
    }

     

     
    execute parse
    {
        

        var previousFigureNotAnUnknown=1;
        var figure="";

        for(var i=0;i<=equation.length;i++)
        {
            if (("A"<=equation.charAt(i)) && (equation.charAt(i)<="Z")
            || ("a"<=equation.charAt(i) && equation.charAt(i)<="z")
             )
            {
                    figure+=equation.charAt(i);        
                    unknown.add(equation.charAt(i));
                    if (previousFigureNotAnUnknown==1) nonzeros.add(equation.charAt(i));;
                    previousFigureNotAnUnknown=0;
            }    
            else
            {
                  previousFigureNotAnUnknown=1;    
                  if (figure!="") figures.add(figure);
                  figure="";
           }        
        }    
        figures.add(maxobjective);
        
    }

    {string} figuresthatcouldbe0=unknown diff nonzeros;

    assert card(unknown)<=10;

    execute
    {
    var quote="\"";

    var f=new IloOplOutputFile("cryptainstance.mod");
    f.writeln("// This model is generated by some OPL code out of ",equation);
    f.writeln("using CP;");
    f.writeln();

    f.writeln("range r=0..9;");
    f.writeln("range rwithout0=1..9;");
    for(var i in nonzeros)
        f.writeln("dvar int ",i," in rwithout0;");
    for(var i in figuresthatcouldbe0)
        f.writeln("dvar int ",i," in r;");    
    f.writeln();
    for(var i in figures)
      f.writeln("dvar int ",i,";");
    f.writeln();  
    f.writeln("maximize ",maxobjective,";");
    f.writeln("subject to {");

    f.writeln(equation,";");
    f.writeln();

    for(var i in figures)
        f.writeln(i," == ",getFormula(i),";");
    f.writeln();

    f.write("allDifferent(append(");
    for(var i in unknown)
    {
      f.write(i);
      if (i!=Opl.last(unknown)) f.write(",");
    }
    f.writeln("));");

    f.writeln("}");

    f.writeln();
    f.writeln("execute {");

    for(var i in figures)
        f.writeln("writeln(",quote,i," = ",quote,",",i,");");    
    f.writeln("}");
        
    f.close();    
    }

     


   
     main
    {
   

    var source = new IloOplModelSource("cryptainstance.mod");
   
    var def = new IloOplModelDefinition(source);
    var opl = new IloOplModel(def,cp);
     
    opl.generate();
     
    cp.solve();
    opl.postProcess();
    }

/*



*/
