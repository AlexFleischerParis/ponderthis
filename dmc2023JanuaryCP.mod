using CP;

{string} PEOPLE=  {"Alice", "Bob", "Carol", "Dave", "Eve"};
{string} GIFTS ={"Book", "Toy", "Chocolate", "Wine", "Flowers"};
range rGIFTS=0..card(GIFTS)-1;

int GIFT_COSTS[rGIFTS]=[ 10, 20, 5, 15, 7];



int HAPPINESS[rGIFTS][PEOPLE]=
[[3, 2, 5, 1, 4],
[5, 2, 4, 3, 1],
[1, 3, 4, 5, 2],
[2, 5, 3, 4, 1],
[4,3,1,2,5]];

int BUDGET=50;

// each person can only receive one gift
dvar int whichGift[PEOPLE] in rGIFTS;

dexpr int KPI_HAPPINESS=sum(p in PEOPLE) HAPPINESS[whichGift[p]][p];

maximize KPI_HAPPINESS;

subject to
{
 //  total cost of the gifts must be less than or equal to the budget
 
 sum(p in PEOPLE) GIFT_COSTS[whichGift[p]]<=BUDGET;
}

execute
{
 for(var p in PEOPLE) writeln(p," will get ",Opl.item(GIFTS,whichGift[p]));
 writeln();
 writeln("Total Happiness : ",KPI_HAPPINESS);
}  

/*

which gives

Alice will get Flowers
Bob will get Wine
Carol will get Book
Dave will get Chocolate
Eve will get Flowers

Total Happiness : 24

*/