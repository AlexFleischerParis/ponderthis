/*

To be listed as a solver - send us a possible "knowing graph"
 where there are at least two people whose 
shortest chain is 27 hops long.
Number the people from 1 to 100 and list the solution in 100 lines of nine numbers each. 

*/

    using CP; // If you comment this then MIP but it will be slower

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

2 3 4 5 6 7 8 9 10 
1 3 4 6 7 8 9 11 13 
1 2 4 5 6 8 9 12 13 
1 2 3 5 7 8 9 10 11 
1 3 4 6 7 9 10 11 13 
1 2 3 5 7 8 10 11 12 
1 2 4 5 6 8 10 12 13 
1 2 3 4 6 7 9 11 12 
1 2 3 4 5 8 10 12 13 
1 4 5 6 7 9 11 12 13 
2 4 5 6 8 10 12 13 14 
3 6 7 8 9 10 11 13 14 
2 3 5 7 9 10 11 12 14 
11 12 13 15 16 17 18 19 20 
14 16 17 19 21 22 23 24 25 
14 15 17 18 19 20 21 24 25 
14 15 16 18 19 20 21 23 24 
14 16 17 19 21 22 23 24 25 
14 15 16 17 18 20 22 23 25 
14 16 17 19 21 22 23 24 25 
15 16 17 18 20 22 24 25 26 
15 18 19 20 21 23 24 25 26 
15 17 18 19 20 22 24 25 26 
15 16 17 18 20 21 22 23 26 
15 16 18 19 20 21 22 23 26 
21 22 23 24 25 27 28 29 30 
26 28 29 30 31 33 34 35 36 
26 27 30 31 32 33 34 36 37 
26 27 30 31 32 33 34 35 37 
26 27 28 29 31 32 33 36 37 
27 28 29 30 32 35 36 37 38 
28 29 30 31 34 35 36 37 38 
27 28 29 30 34 35 36 37 38 
27 28 29 32 33 35 36 37 38 
27 29 31 32 33 34 36 37 38 
27 28 30 31 32 33 34 35 38 
28 29 30 31 32 33 34 35 38 
31 32 33 34 35 36 37 39 40 
38 40 41 42 43 44 45 46 47 
38 39 41 42 43 44 45 46 47 
39 40 42 43 44 45 46 47 48 
39 40 41 43 44 45 46 47 48 
39 40 41 42 44 45 46 47 48 
39 40 41 42 43 45 46 47 48 
39 40 41 42 43 44 46 47 48 
39 40 41 42 43 44 45 47 48 
39 40 41 42 43 44 45 46 48 
41 42 43 44 45 46 47 49 50 
48 50 51 52 53 55 56 57 58 
48 49 51 53 54 55 56 57 58 
49 50 52 53 54 55 56 57 59 
49 51 53 54 55 56 57 58 59 
49 50 51 52 54 56 57 58 59 
50 51 52 53 55 56 57 58 59 
49 50 51 52 54 56 57 58 59 
49 50 51 52 53 54 55 58 59 
49 50 51 52 53 54 55 58 59 
49 50 52 53 54 55 56 57 59 
51 52 53 54 55 56 57 58 60 
59 61 62 63 64 65 66 67 68 
60 62 63 64 65 66 67 68 69 
60 61 63 64 65 66 67 68 69 
60 61 62 64 65 66 67 68 69 
60 61 62 63 65 66 67 68 69 
60 61 62 63 64 66 67 68 69 
60 61 62 63 64 65 67 68 69 
60 61 62 63 64 65 66 68 69 
60 61 62 63 64 65 66 67 69 
61 62 63 64 65 66 67 68 70 
69 71 72 73 74 75 76 77 78 
70 72 73 74 75 76 77 78 79 
70 71 73 74 75 76 77 78 79 
70 71 72 74 75 76 77 78 79 
70 71 72 73 75 76 77 78 79 
70 71 72 73 74 76 77 78 79 
70 71 72 73 74 75 77 78 79 
70 71 72 73 74 75 76 78 79 
70 71 72 73 74 75 76 77 79 
71 72 73 74 75 76 77 78 80 
79 81 82 83 84 85 86 87 88 
80 82 83 84 85 86 87 88 89 
80 81 83 84 85 86 87 88 89 
80 81 82 84 85 86 87 88 89 
80 81 82 83 85 86 87 88 89 
80 81 82 83 84 86 87 88 89 
80 81 82 83 84 85 87 88 89 
80 81 82 83 84 85 86 88 89 
80 81 82 83 84 85 86 87 89 
81 82 83 84 85 86 87 88 90 
89 91 92 93 94 95 96 97 98 
90 92 94 95 96 97 98 99 100 
90 91 93 94 95 96 97 99 100 
90 92 94 95 96 97 98 99 100 
90 91 92 93 95 96 98 99 100 
90 91 92 93 94 97 98 99 100 
90 91 92 93 94 97 98 99 100 
90 91 92 93 95 96 98 99 100 
90 91 93 94 95 96 97 99 100 
91 92 93 94 95 96 97 98 100 
91 92 93 94 95 96 97 98 99 


*/
