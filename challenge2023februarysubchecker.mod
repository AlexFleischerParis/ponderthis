using CP;

int n=20;
range r=1..n;

tuple t
{
  int x[r];
  int y[r];
}

{t} excluded=...;


dvar int y[r] in r; // queens
dvar int s[r] in 2..2*n;
dvar int d[r] in 1-n..n-1;

// where are the kings ?
dvar int kx[r] in r;
dvar int ky[r] in r;



subject to
{
  
 forall(i in r,j in r) kx[i]+ky[i]!=s[j];
 forall(i in r,j in r) kx[i]-ky[i]!=d[j];

 forall(ordered k1,k2 in r)
    maxl(abs(kx[k1]-kx[k2]),abs(ky[k1]-ky[k2]))>=2;
    
    // break sym
    
    forall(i in 1..n-1) ((kx[i]<kx[i+1]) || (kx[i]==kx[i+1]) && (ky[i]<ky[i+1])) ;
  
  allDifferent(y);
  forall(i in r)
    {
      s[i]==i+y[i];
      d[i]==i-y[i];
    }
   allDifferent(s);
   allDifferent(d); 
   
   
   y[1]==19;
  y[2]==8;
  y[3]==15;
  y[4]==2;
  y[5]==20;
  y[6]==11;
   y[7]==7;
  y[8]==5;
  y[9]==10;
  y[10]==17;
  
  y[11]==4;
  y[12]==14;
  y[13]==16;
  y[14]==9;
  y[15]==1;
  y[16]==6;
   y[17]==13;
  y[18]==3;
  y[19]==18;
  y[20]==12;
  
  forall(i in excluded) or(j in r) i.x[j]!=kx[j] ||   or(j in r) i.y[j]!=ky[j];
}

t newt;

execute
 {
   for(var k in r)
   {
     newt.x[k]=kx[k];
     newt.y[k]=ky[k];
   }
   excluded.add(newt);
   writeln(kx);
   writeln(ky);
   writeln(excluded.size);
   
   var o=new IloOplOutputFile("challenge2023februarysubchecker.dat");
   o.writeln("excluded=");
   o.writeln(excluded);
   o.writeln(";");
   o.close();
 }