/*

Merci https://www.linkedin.com/in/xavier-aime/ pour ce défi

dans https://www.linkedin.com/posts/xavier-aime_openai-vient-de-rendre-public-son-nouveau-activity-7240237840901574656-amW-?utm_source=share&utm_medium=member_desktop

Zoé, Yann et Xavier se présentent à l'élection des délégués. 
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

int Xavier=ord(nomsdesvotes,"Xavier");
int Yann=ord(nomsdesvotes,"Yann");
int Zoe=ord(nomsdesvotes,"Zoe");

dvar int vote[camarades] in 0..card(nomsdesvotes)-1;

subject to
{
  ((vote["Bob"]==Zoe) &&  (vote["Chloe"]!=Xavier))  =>  (vote["Alex"]==Xavier);
   
   (vote["Chloe"]==Xavier) => (vote["Alex"]==Yann);
 
  ((vote["Alex"]==Yann) &&  (vote["Chloe"]!=Zoe)) =>  (vote["Bob"]==Xavier);
   
    (vote["Chloe"]==Zoe) => (vote["Bob"]==Xavier);

  (vote["Alex"]==Xavier) => (vote["Chloe"]!=Yann);
     
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

ChatGPT, LLama3 et mixtral se trompent!

*/