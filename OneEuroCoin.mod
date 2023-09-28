/*

Suppose you need to pay 1 Euro. In how many different ways you can do it via
1c , 2c, 5c, 10c, 20c, 50c and 1 Euro coins? 

*/

using CP;

{int} coins={1,2,5,10,20,50,100};

dvar int+ nb[coins];

subject to
{
  100==sum(c in coins) nb[c]*c;
}


main
{
    var nb=0;
    cp.param.SearchType=24;
    cp.param.workers=1;

    thisOplModel.generate();
    cp.startNewSearch();
    while
    (cp.next()) {  thisOplModel.postProcess(); nb++; }
    writeln("nb solutions = ",nb);
}

/*

nb solutions = 4563

*/