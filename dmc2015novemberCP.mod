/*

Sam, who doesn’t like bananas, likes sitting on the grass 
The monkey who sat on the rock ate the apple. The monkey who ate the pear didn’t sit on the tree branch 
Anna sat by the stream but she didn’t eat the pear 
Harriet didn’t sit on the tree branch. Mike doesn’t like oranges. 

*/

using CP;

{string} monkeys={"Anna","Harriet","Mike","Sam"};
{string} fruits={"apple","banana","pear","orange"};
{string} spots={"grass","rock","stream","branch"};

int monkeysrank[m in monkeys]=ord(monkeys,m)+1;
int fruitsrank[f in fruits]=ord(fruits,f)+1;
int spotsrank[s in spots]=ord(spots,s)+1;

range rmonkeys=1..card(monkeys);
dvar int what[rmonkeys] in 1..card(fruits);
dvar int where[rmonkeys] in 1..card(spots);

dvar int whoeats[1..card(fruits)] in rmonkeys;
dvar int whosits[1..card(spots)] in rmonkeys;

subject to
{
  allDifferent(what);
  allDifferent(where);
  inverse(whoeats,what);
  inverse(whosits,where);
  
  
  what[monkeysrank["Sam"]]!=fruitsrank["banana"];
  where[monkeysrank["Sam"]]==spotsrank["grass"];
  whoeats[fruitsrank["apple"]]==whosits[spotsrank["rock"]];
  whoeats[fruitsrank["pear"]]!=whosits[spotsrank["branch"]];
  where[monkeysrank["Anna"]]==spotsrank["stream"];
  what[monkeysrank["Anna"]]!=fruitsrank["pear"];
  where[monkeysrank["Harriet"]]!=spotsrank["branch"];
  what[monkeysrank["Mike"]]!=fruitsrank["orange"];
}

execute
{
  for(var r in rmonkeys) 
  {
  var m=Opl.item(monkeys,r-1);  
  writeln(Opl.item(monkeys,r-1)," sits ",Opl.item(spots,where[r]-1)," and eats ",Opl.item(fruits,what[r]-1));
  }  
}

/*

which gives

Anna sits stream and eats orange
Harriet sits rock and eats apple
Mike sits branch and eats banana
Sam sits grass and eats pear

*/



