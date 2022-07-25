/*

Can linear programming save money on the food budget of the US Army without 
damaging the nutritional health of members of the armed forces?

This example solves a simple variation of the well-known diet problem that 
was posed by George Stigler and George Dantzig: how to choose foods that 
satisfy nutritional requirements while minimizing costs or maximizing satiety.

The problem that is solved in this example is to minimize the cost of a diet 
that satisfies certain nutritional constraints.

OPL version of python example at 

https://ibmdecisionoptimization.github.io/docplex-doc/mp/diet.html

*/


tuple Food
{
	key string name;
	float unit_cost;
	int qmin;
	int qmax;
};

{Food} FOODS=...;

tuple Nutrient 
{
	key string name;
	float qmin;
	float qmax;
}

{Nutrient} NUTRIENTS=...;

tuple food_nutrient_value
{
  string food;
  string nutrient;
  float value;
}

{food_nutrient_value} FOOD_NUTRIENTS=...;;




// Decision variables
dvar int qty[f in FOODS] in f.qmin..f.qmax;

// cost
dexpr float cost=sum (f in FOODS) qty[f]*f.unit_cost;

// KPI
dexpr float amount[n in NUTRIENTS] = sum(f in FOODS)
qty[f] * sum(fn in FOOD_NUTRIENTS:fn.food==f.name && fn.nutrient==n.name) fn.value;

// this KPI counts the number of foods used.
dexpr int nbFood=sum(f in FOODS) (qty[f]>=1);

minimize cost;

subject to
{
// Limit range of nutrients
forall(n in NUTRIENTS) n.qmin<=amount[n]<=n.qmax;
}

execute
{

writeln("quantity = ",qty);
writeln("cost = ",cost);
writeln("amount = ",amount);

writeln("nb food = ",nbFood);

writeln();
for(var f in FOODS) if (qty[f]!=0) writeln("Buy ",qty[f]," ",f.name);

}

/*

which gives

quantity =  [0 2 0 1 0 10 2 0 1]
cost = 2.87
amount =  [2063.3 849 11.3 8201.9 26.9 272 52.3]
nb food = 5

Buy 2 Spaghetti W/ Sauce
Buy 1 Apple,Raw,W/Skin
Buy 10 Chocolate Chip Cookies
Buy 2 Lowfat Milk
Buy 1 Hotdog
*/


