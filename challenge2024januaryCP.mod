using CP;

range r=1..16;

dvar int x[r] in r;

subject to
{
  allDifferent(x);
  
  x[1]+x[2]-x[3]-x[4]==5;
  x[5]+x[6]+x[7]-x[8]==10;
  x[9]-x[10]+x[11]+x[12]==9;
  x[13]-x[14]+x[15]-x[16]==0;
  
  x[1]+x[5]+x[9]-x[13]==17;
  x[2]+x[6]-x[10]-x[14]==8;
  x[3]-x[7]-x[11]+x[15]==11;
  x[4]+x[8]+x[12]+x[16]==48;
  
  
}

// postprocessing

    execute
    {
    writeln("x=",x);
    }
    
// enumerate    

    main
    {
    var nbsol=0;  
    cp.param.SearchType=24;
    cp.param.workers=1;

    thisOplModel.generate();
    cp.startNewSearch();
    while
    (cp.next()) {  thisOplModel.postProcess(); nbsol++; }
    writeln("nbsol=",nbsol);
    }

/*

gives in 1s

x= [12 9 2 14 6 16 3 15 4 7 1 11 5 10 13 8]
nbsol=84

*/

