range r=1..16;

dvar int x[r] in r;

dvar boolean y[r][r];

dvar int+ obj1min;
dvar int+ obj2min;
dvar int+ obj3min;
dvar int+ obj4min;

dvar int+ obj1; 
dvar int+ obj2; 
dvar int+ obj3;
dvar int+ obj4;


minimize staticLex(obj1,obj2,obj3,obj4);
subject to
{
  
  obj1==sum(i in 1..4) (x[i]-1)*pow(16,i-1);
 obj2==sum(i in 1..4) (x[i+4]-1)*pow(16,i-1);
 obj3==sum(i in 1..4) (x[i+8]-1)*pow(16,i-1);
 obj4==sum(i in 1..4) (x[i+12]-1)*pow(16,i-1);
  
  (obj1min+1<=obj1) || 
  (obj1min==obj1) && (obj2min+1<=obj2) || 
  (obj1min==obj1) && (obj2min==obj2) && (obj3min+1<=obj3) || 
  (obj1min==obj1) && (obj2min==obj2) && (obj3min==obj3) && (obj4min+1==obj4);
  
  // allDiffernt
  //forall(ordered i,j in r) x[i]!=x[j];
  
  forall(i in r) sum(j in r) y[i][j]==1;
  forall(i in r) sum(j in r) y[j][i]==1;
  forall(i in r) x[i]==sum(j in r) j*y[i][j];
  
  
  x[1]+x[2]-x[3]-x[4]==5;
  x[5]+x[6]+x[7]-x[8]==10;
  x[9]-x[10]+x[11]+x[12]==9;
  x[13]-x[14]+x[15]-x[16]==0;
  
  x[1]+x[5]+x[9]-x[13]==17;
  x[2]+x[6]-x[10]-x[14]==8;
  x[3]-x[7]-x[11]+x[15]==11;
  x[4]+x[8]+x[12]+x[16]==48;
  
  
}

// postprocess

execute
{
  writeln(x);
}

// enumerate

main {
         var nbsol=0;

         thisOplModel.generate();
         while (1==cplex.solve())
         {
           writeln(nbsol);
             thisOplModel.postProcess();
             nbsol++;
             var v1=thisOplModel.obj1.solutionValue;  
             var v2=thisOplModel.obj2.solutionValue; 
             var v3=thisOplModel.obj3.solutionValue;  
             var v4=thisOplModel.obj4.solutionValue; 
             thisOplModel.obj1min.LB=v1;  
             thisOplModel.obj2min.LB=v2;   
             thisOplModel.obj3min.LB=v3;  
             thisOplModel.obj4min.LB=v4;                
         }
                writeln("nb solutions = ",nbsol);
        }
        
/*

gives after 9 min 30 s and after 25 s with the better all Different constraint

[14 16 10 15 6 3 9 8 2 7 1 13 5 4 11 12]
nb solutions = 84

*/        


