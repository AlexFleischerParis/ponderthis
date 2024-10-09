// Find c1 and c2 that with c1!=c2 
//and (a,b,c1) and (a,b,c2) same area

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
