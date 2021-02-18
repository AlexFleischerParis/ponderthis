// Solution to the Cubewise 2020 challenge

/*

CUBE+WISE=MORE

Use each number between  0 -> 9 only once, to replace the letters in the sentence.

(for example C=1, U=3, W=4, ….)

The sum must be correct, each number must be used EXACTLY once. 
With the correct sum, there are many solutions. 
But which solution has the highest value for the letters R, O and I?

Target: Maximize the value of ROI. There is only 1 correct maximum value for ROI. 
What number (like 123) corresponds to the letters ROI?

*/

range r=0..9;
range rw0=1..9;


execute
{
  var maxROI=0;
  var maxCUBE=0;
  var maxWISE=0;
  var maxMORE=0;
  
  for(var C in rw0) for(var U in r) if (C!=U)
   for(var B in r) if (B!=C) if (B!=U) 
    for(var E in r) if (E!=C) if (E!=U) if (E!=B)
     for(var W in rw0) if (W!=C) if (W!=U) if (W!=B) if (W!=E) 
      for(var I in r) if (I!=C) if (I!=U) if (I!=B) if (I!=E) if (I!=W)
       for(var S in r) if (S!=C) if (S!=U) if (S!=B) if (S!=E) if (S!=W) if (S!=I)
        for(var M in rw0) if (M!=C) if (M!=U) if (M!=B) if (M!=E) if (M!=W) if (M!=I) if (M!=S)
         for(var O in r) if (O!=C) if (O!=U) if (O!=B) if (O!=E) if (O!=W) if (O!=I) if (O!=S) if (O!=M)
          for(var R in r)
            if (R!=C) if (R!=U) if (R!=B) if (R!=E) if (R!=W) if (R!=I) if (R!=S) if (R!=M) if (R!=O)
            {
              var CUBE=1000*C+100*U+10*B+E;
              var WISE=1000*W+100*I+10*S+E;
              var MORE=1000*M+100*O+10*R+E;
        
              if (CUBE+WISE==MORE)
              {
                var ROI=100*R+10*O+I;
                if (ROI>maxROI)
                {
                  maxROI=ROI;
                  maxCUBE=CUBE;
                  maxWISE=WISE;
                  maxMORE=MORE;
                  writeln("CUBE = ",maxCUBE);
                  writeln("WISE = ",maxWISE);
                  writeln("MORE = ",maxMORE);
                  writeln("ROI=",maxROI);
                  writeln();
            
                }
             }
           }
 writeln();
 writeln("The solution is");
 writeln();          
 writeln("CUBE = ",maxCUBE);
 writeln("WISE = ",maxWISE);
 writeln("MORE = ",maxMORE);
 writeln("ROI=",maxROI);     
}
