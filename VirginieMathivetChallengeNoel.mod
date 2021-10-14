using CP;

int scale=10000;
int VolumeBilles=1250; // //100 350 420 1250;

dvar int scalex in 0..30*scale;
dvar int scaley in 0..15*scale;
dvar int scalez in 0..5*scale;

dexpr float x=scalex/scale;
dexpr float y=scaley/scale;
dexpr float z=scalez/scale;

minimize (x*y+y*z+x*z)*2;
subject to
{
  x*y*z>=VolumeBilles;
  
}

execute
{
  writeln(x);
  writeln(y);
  writeln(z);
}

/*

which gives

4.6295
4.6409
4.6544

if VolumeBilles = 100

8.3393
8.394
5

if VolumeBilles = 350

9.195
9.1354
5

if VolumeBilles = 420

16.6669
14.9998
5

if VolumeBilles = 1250

*/
