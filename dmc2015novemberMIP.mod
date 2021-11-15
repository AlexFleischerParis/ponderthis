/*

Sam, who doesn’t like bananas, likes sitting on the grass 
The monkey who sat on the rock ate the apple. The monkey who ate the pear didn’t sit on the tree branch 
Anna sat by the stream but she didn’t eat the pear 
Harriet didn’t sit on the tree branch. Mike doesn’t like oranges. 

*/

//using CP; // CP works fine too with this model, just uncomment this line

{string} monkeys={"Anna","Harriet","Mike","Sam"};
{string} fruits={"apple","banana","pear","orange"};
{string} spots={"grass","rock","stream","branch"};

dvar boolean where[monkeys][spots];
dvar boolean what[monkeys][fruits];

subject to
{
  // monkeys are at a given spot
  forall(m in monkeys) sum(s in spots) where[m][s]==1;
  // which are different
  forall(s in spots) sum(m in monkeys) where[m][s]==1;
  
  // monkeys eat a given fuit
  forall(m in monkeys) sum(f in fruits) what[m][f]==1;
  // which are different
  forall(f in fruits) sum(m in monkeys) what[m][f]==1;
  
  what["Sam"]["banana"]==false;
  where["Sam"]["grass"]==true;
  forall(m in monkeys)
    {
      what[m]["apple"]==where[m]["rock"];
      what[m]["pear"]+where[m]["branch"]<=1;
    }
  
  where["Anna"]["stream"]==true;
  what["Anna"]["pear"]==false;
  
  where["Harriet"]["branch"]==false;
  what["Mike"]["orange"]==false;
}

execute
{
  for(var m in monkeys) 
  {
    write(m," sits ");
    for(var s in spots) if (where[m][s]==1) write(s);
    write(" and eats ");
    for(var f in fruits) if (what[m][f]==1) writeln(f);   
   }  
}

/*

which gives

Anna sits stream and eats orange
Harriet sits rock and eats apple
Mike sits branch and eats banana
Sam sits grass and eats pear

*/
