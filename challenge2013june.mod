using CP;




int period=11;

int N=60;

dvar int+ x ; 
dvar int+ r[1..N];

dvar int z[k in 1..N] in 0..((k==1)?maxint:9);

dvar int y[1..5] in 0..9;
dvar int Y in 0..100000;
dvar int m in 1..9;
/*dvar int m2 in 1..19;



dvar int cx[1..10] in 0..9;

dexpr int isUsedInX[j in 0..9] = (or (i in 1..5) (cx[i]==j));*/



minimize x;
subject to
{
  
  x==m*111111;
  
 
  
 (9999*10000000+9999*1000+999) mod Y==0;
  y[1]!=0;
  
  allDifferent(y);
  Y==y[1]*10000+y[2]*1000+y[3]*100+y[4]*10+y[5];
  
  r[1] == x mod Y;
  z[1]==x div Y;
  
  forall(i in 2..N) 
  {
   z[i]==(10*r[i-1]) div Y;
   r[i]==(10*r[i-1]) mod Y; 
  } 
  
  forall(i in 30..30+period-1)
    z[i]==z[i+period]; 
    
    sum ( i in 30..30+period-1) z[i] !=0; 
  
  forall(k in 0..9) count(all(i in 30..40) z[i],k)<=2;
 
  forall(k in 0..9) 
  (
  (y[5]==k) => (2==(sum (i in 30..40) (z[i]==k)))
  );
  
  forall(k in 0..9) 
  (
  (y[5]!=k) => (1==(sum (i in 30..40) (z[i]==k)))
  );
  
  
}  

execute
{
  writeln("result = ",x," / ",Y);
}

/*

which gives

result = 333333 / 21649

*/
