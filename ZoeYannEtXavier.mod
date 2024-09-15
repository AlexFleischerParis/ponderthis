/*

"Zoé, Yann et Xavier se présentent à l'élection des délégués. 
Trois camarades Alex, Bob et Chloé discutent.
 Alex dit : si Bob vote pour Zoé, je voterai pour Xavier. 
 Mais si Chloé vote pour Xavier, je voterai pour Yann.
  Bob dit : si Alex vote pour Yann, je ne voterai pas pour Xavier.
   Mais si Chloé vote pour Zoé, je voterai pour Xavier.
    Chloé dit : si Alex vote pour Xavier, je ne voterai pas pour Yann.
     Le jour de l'élection, Alex, Bob et Chloé votent pour des candidats distincts.
      Pour qui ont-ils voté ?
      
*/

using CP;

{string} camarades={"Alex","Bob","Chloe"};
{string} nomsdesvotes={"Xavier","Yann","Zoe"};

dvar int vote[camarades] in 0..card(nomsdesvotes)-1;

subject to
{
  ((vote["Bob"]==ord(nomsdesvotes,"Zoe") && 
  vote["Chloe"]!=ord(nomsdesvotes,"Xavier")))
  =>
   (vote["Alex"]==ord(nomsdesvotes,"Xavier"));
   
    (vote["Chloe"]==ord(nomsdesvotes,"Xavier"))
  =>
   (vote["Alex"]==ord(nomsdesvotes,"Yann"));

 
  ((vote["Alex"]==ord(nomsdesvotes,"Yann") && 
  vote["Chloe"]!=ord(nomsdesvotes,"Zoe")))
  =>
   (vote["Bob"]==ord(nomsdesvotes,"Xavier"));
   
    (vote["Chloe"]==ord(nomsdesvotes,"Zoe"))
  =>
   (vote["Bob"]==ord(nomsdesvotes,"Xavier"));
 //  Chloé dit : si Alex vote pour Xavier, je ne voterai pas pour Yann
  (vote["Alex"]==ord(nomsdesvotes,"Xavier"))
  =>
   (vote["Chloe"]!=ord(nomsdesvotes,"Yann"));
   
   
allDifferent(vote);  
}

execute display 
{
  for(var c in camarades)
  writeln(c," vote pour ",Opl.item(nomsdesvotes,vote[c]));
}

/*

donne

Alex vote pour Zoe
Bob vote pour Xavier
Chloe vote pour Yann

*/