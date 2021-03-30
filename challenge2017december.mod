/*

To be listed as a solver - send us a possible "knowing graph"
 where there are at least two people whose 
shortest chain is 27 hops long.
Number the people from 1 to 100 and list the solution in 100 lines of nine numbers each. 

*/

    //using CP; // If you comment this then MIP but it will be slower

    int nb=100;
    int howmanyyouknow=9;

    range r=1..nb;
    int nbHops=27;

    range Rclasses=1..nbHops+1;

    dvar boolean x[r][r]; // Do they know each other ?
    dvar int classes[r] in Rclasses; // Distance to person 1
    dvar int nbPerClass[1..nbHops+1] in 0..nb;

    maximize classes[nb];
    subject to
    {
    classes[1]==1;

    // class partition
    forall(i in 1..nbHops+1) nbPerClass[i]==sum(j in r) (classes[j]==i);
    //forall(i in 1..nbHops+1) nbPerClass[i]==count(classes,i);

    // I know me
    forall(i in r) x[i][i]==1;

    // if I know you, you know me
    forall(ordered i,j in r) x[i][j]==x[j][i];

    // I know some people plus me
    forall(i in r) sum(j in r) x[i][j]==1+howmanyyouknow;
     
     // class increase
    forall(i in r:i!=1) classes[i-1]<=classes[i];

    // Class increases max 1
    forall(i in r:i!=1) classes[i]-classes[i-1]<=1;

    // If i is less than j and i knows j then the difference of classes is no more than 1
    forall(ordered i,j in r) (x[i][j]==1) => ((classes[j]-classes[i])<=1);


    }

    {int} neighbours[i in r]={j | j in r : (i!=j) && (x[i][j]==1)};

    execute
    {

    writeln("result");

    writeln();

    for(var i in r)
    {
    for(var j in neighbours[i]) write(j," ");
    writeln();
    }


    } 


/*

gives

// solution with objective 28
result




*/
