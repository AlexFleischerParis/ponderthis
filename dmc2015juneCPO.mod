using CP;

tuple foodItem
{
  key string name;
  float sodium;
  float fat;
  float calories;
  float price;
}

{foodItem} foodItems=
{
  <"Beef Patty"		,50,	17,	220,	0.25>,
  <"Bun"			,330,	9,	260,	0.15>, 
  <"Cheese",		310,	6,	70,		0.10>,
  <"Onions"			,1,		2,	10,		0.09>,
  <"Pickles"		,260,	0,	5,		0.03>,
  <"Lettuce"		,3,		0,	4,		0.04>,
  <"Ketchup"		,160,	0,	20,		0.02>,
  <"Tomato"			,3,		0,	9,		0.04> 
};

//at least one of each item and no more than five of each item. 
dvar int qty[foodItems] in 1..5;

dexpr float cost=sum(f in foodItems) qty[f]*f.price;;

//minimize cost;

subject to


{
// cost 
//cost==sum(f in foodItems) qty[f]*f.price;

//  The final burger must contain less than 3000 mg of sodium, 

sum(f in foodItems) qty[f]*f.sodium<=3000;

//  less than 150 grams of fat, 

sum(f in foodItems) qty[f]*f.fat<=150;

//  and less than 3000 calories. 

sum(f in foodItems) qty[f]*f.calories<=3000;

//  To maintain certain taste quality standards you’ll need 
//  to keep the servings of ketchup and lettuce the same.  

qty[<"Ketchup">]==qty[<"Lettuce">];

//  Also, you’ll need to keep the servings of pickles and tomatoes the same.

qty[<"Pickles">]==qty[<"Tomato">];



}

execute
{
  writeln("cost = ",cost);
  for(var f in foodItems) writeln(qty[f], " ",f.name);
  writeln();
}

main
{
  var costMin=100000;
  var costMax=0;
  var qtyMin=Array(Opl.card(thisOplModel.foodItems));
  var qtyMax=Array(Opl.card(thisOplModel.foodItems));
  
  // find all options
  
  writeln("all possible burgers");
  
  cp.param.SearchType=24;
  cp.param.workers=1;
  var nbsol=0;

  thisOplModel.generate();
  cp.startNewSearch();
  while
  (cp.next()) {  
                nbsol++; 
                if (nbsol<=5) thisOplModel.postProcess();
                if (thisOplModel.cost>=costMax)
                {
                  costMax=thisOplModel.cost.solutionValue;
                  for(var f in thisOplModel.foodItems)
                    qtyMax[Opl.ord(thisOplModel.foodItems,f)]=thisOplModel.qty[f].solutionValue;
                }
                if (thisOplModel.cost<=costMin)
                {
                   costMin=thisOplModel.cost.solutionValue;
                   for(var f in thisOplModel.foodItems)
                    qtyMin[Opl.ord(thisOplModel.foodItems,f)]=thisOplModel.qty[f].solutionValue;
                }
                }
                
   writeln("nbsol = ",nbsol);
   writeln();
   writeln("minimize cost");
   for(var f in thisOplModel.foodItems) writeln(qtyMin[Opl.ord(thisOplModel.foodItems,f)], " ",f.name);
   writeln("cost = ",costMin);
   writeln();
   writeln("maximize cost");
   for(var f in thisOplModel.foodItems) writeln(qtyMax[Opl.ord(thisOplModel.foodItems,f)], " ",f.name);
   
   writeln("cost = ",costMax);
}

/*

gives

all possible burgers
cost = 0.72
1 Beef Patty
1 Bun
1 Cheese
1 Onions
1 Pickles
1 Lettuce
1 Ketchup
1 Tomato

cost = 0.87
1 Beef Patty
2 Bun
1 Cheese
1 Onions
1 Pickles
1 Lettuce
1 Ketchup
1 Tomato

cost = 1.02
1 Beef Patty
3 Bun
1 Cheese
1 Onions
1 Pickles
1 Lettuce
1 Ketchup
1 Tomato

cost = 1.17
1 Beef Patty
4 Bun
1 Cheese
1 Onions
1 Pickles
1 Lettuce
1 Ketchup
1 Tomato

cost = 1.32
1 Beef Patty
5 Bun
1 Cheese
1 Onions
1 Pickles
1 Lettuce
1 Ketchup
1 Tomato

nbsol = 5202

minimize cost
1 Beef Patty
1 Bun
1 Cheese
1 Onions
1 Pickles
1 Lettuce
1 Ketchup
1 Tomato
cost = 0.72

maximize cost
5 Beef Patty
5 Bun
1 Cheese
5 Onions
1 Pickles
3 Lettuce
3 Ketchup
1 Tomato
cost = 2.8

*/
