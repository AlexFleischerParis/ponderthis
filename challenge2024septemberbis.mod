{int} S={}; // Isoceles triangles leading to several triangles with same area
 
 int m=20;
 range r=1..m;
 int prime[i in r]=(i!=1) &&and(j in 2..ftoi(ceil(sqrt(i-1)))) (0!=i mod j); // is prime ?
 
 main {
   
   thisOplModel.settings.mainEndEnabled=true;
   
   // How many triangles (a,b,c1) (a,b,c2) with c1!=c2 and same area
   function countTriangles(a,b)
   {
      
     // Depth first
      cp.param.SearchType=24;
      cp.param.LogVerbosity=20;
      cp.param.workers=1;
      var opl = thisOplModel;
        
      // set a and b in the sub model
      opl.a.UB=a;
      opl.a.LB=a;
      opl.b.LB=b;
      opl.b.UB=b;
      
      
      
      var nb=0;
      cp.startNewSearch();
      while (cp.next()) {  opl.postProcess(); nb++; }
      
      cp.endSearch();
      
      return nb;
   }
   
   thisOplModel.generate();
   // Loop to find Isoceles triangles leading to several triangles with same area
   var N=20;
   for(var i=1;i<=N;i++) if ((thisOplModel.prime[i]) && (countTriangles(i,i)!=0)) thisOplModel.S.add(i);
   writeln(thisOplModel.S);
   
   
  // Loop to find all (a,b) so that we have 50 
   //  triangles (a,b,c1) (a,b,c2) with c1!=c2 
   // and same area
     var M=30;
     var P=2;
     var f1=Opl.first(thisOplModel.S);
     var f2=Opl.item(thisOplModel.S,1);
     var f3=Opl.item(thisOplModel.S,2);
     
     var nb=0;
     for(var p3=0;p3<=P;p3++) for(var p2=0;p2<=P;p2++) for(var p1=0;p1<=P;p1++)
      for(var a=1;a<=M;a++)  for(b=1;b<=a-1;b++) if (nb!=50)
      {        
          // We test A and B with iteration on a and b and isoceles
         // triangles leading to several triangles with same area
         var A=a*(Math.pow(f1,p1))*(Math.pow(f2,p2))*(Math.pow(f3,p3));
         var B=b*(Math.pow(f1,p1))*(Math.pow(f2,p2))*(Math.pow(f3,p3));
         nb=countTriangles(A,B);
        
         if (nb==50) 
		 {
     		writeln("a=",A," and b=",B," ==> nb solutions =",nb);
		 }     
     	
      }       
}
    

using CP;

dvar int+ a;
dvar int+ b;

dvar int+ c1;
dvar int+ c2;


subject to
{
  c1!=c2;
  c1<=c2;
  
  // Regular triangle
  c1<=a+b-1;
  c2<=a+b-1;
  c1>=a-b+1;
  c2>=a-b+1;
  
  // Same area from Heron formula
 2*(a*a+b*b)==c2*c2+c1*c1;
}


/*

which gives

a=143650 and b=127075 ==> nb solutions =50

*/    
