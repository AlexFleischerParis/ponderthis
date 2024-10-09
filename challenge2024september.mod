{int} S={}; // Isoceles triangles leading to several triangles with same area
 
 int m=20;
 range r=1..m;
 int prime[i in r]=(i!=1) &&and(j in 2..ftoi(ceil(sqrt(i-1)))) (0!=i mod j); // is prime ?
 
 main {
   
   thisOplModel.settings.mainEndEnabled=true;
   
   function countTriangles(a,b)
   {
      var source = new IloOplModelSource("ponder2024septembersub.mod");
      var def = new IloOplModelDefinition(source);
      var cp = new IloCP();
      cp.param.SearchType=24;
      cp.param.LogVerbosity=20;
      cp.param.workers=1;
      var opl = new IloOplModel(def,cp);
        
      var data2= new IloOplDataElements();
      data2.a=a;
      data2.b=b;
      opl.addDataSource(data2);
      opl.generate();
      var nb=0;
      cp.startNewSearch();
      while (cp.next()) {  opl.postProcess(); nb++; }
      opl.end();
      cp.end();
      return nb;
   }
   
   var N=20;
   for(var i=1;i<=N;i++) if ((thisOplModel.prime[i]) && (countTriangles(i,i)!=0)) thisOplModel.S.add(i);
   writeln(" Isoceles triangles leading to several triangles with same area");
   writeln(thisOplModel.S); 
     
     var M=30;
     var P=2;
     var f1=Opl.first(thisOplModel.S);
     var f2=Opl.item(thisOplModel.S,1);
     var f3=Opl.item(thisOplModel.S,2);
     
     var nb=0;
     for(var p3=0;p3<=P;p3++) for(var p2=0;p2<=P;p2++) for(var p1=0;p1<=P;p1++)
      for(var a=1;a<=M;a++)  for(b=1;b<=a-1;b++) if (nb!=50)
      {        
        
         var A=a*(Math.pow(f1,p1))*(Math.pow(f2,p2))*(Math.pow(f3,p3));
         
         var B=b*(Math.pow(f1,p1))*(Math.pow(f2,p2))*(Math.pow(f3,p3));
         nb=countTriangles(A,B);
        
         if (nb==50) 
		 {
     		writeln("a=",A," and b=",B," ==> nb solutions =",nb);
		 }     
     	
      }       
}
    
/*

which gives

a=143650 and b=127075 ==> nb solutions =50

*/    

/*

the sub model is

using CP;

int a=...;
int b=...;

assert a>=b;

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

*/

