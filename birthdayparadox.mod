/*

In probability theory, the birthday problem asks for the probability that, 
in a set of n randomly chosen people, at least two will share a birthday. 
The birthday paradox refers to the counterintuitive fact that only 23 people 
are needed for that probability to exceed 50%. (Wikipedia)

https://en.wikipedia.org/wiki/Birthday_problem

Let's compute this probability with Monte Carlo in OPL CPLEX

*/

int nbDays=366; // Olympic year
int nbBirthdays=23;
range rb=1..nbBirthdays;
int n=1000000;
range r=1..n;
int birthdays[i in r][j in rb]=rand(nbDays);

//float ratetwicesamebirthday=1/n*sum(i in r) (!allDifferent(all(j in rb)birthdays[i][j]));
float ratetwicesamebirthday=1/n*sum(i in r) (nbBirthdays!=card({birthdays[i][j] | j in rb}));

execute
{
  var start=new Date();
  writeln("probability : ",ratetwicesamebirthday);
  var end=new Date();
  writeln("time        : ",(end-start)/1000);
}


/*

which gives

probability : 0.506503
time        : 19.075

*/

