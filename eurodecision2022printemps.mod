/*

Ronan Bars, le Directeur G�n�ral d'EURODECISION a oubli� le code de sa valise � 4 chiffres. Il a une m�moire s�lective (et relativement bizarre) et se souvient de quelques d�tails :
 
1. Le code ne contient pas de 0 et les chiffres sont tous diff�rents.
2. Le 1er chiffre est pair et sup�rieur � 5.
3. Le nombre form� par le 1er et 2e est multiple de 3.
4. Le 3e chiffre est 7.
5. Le nombre form� par le 3e et 4e chiffre est multiple de 5.
6. Le code est divisible par 9.


*/

using CP;

dvar int x[1..4] in 1..9;
dexpr int sol=x[1]*1000+x[2]*100+x[3]*10+x[4];

subject to
{
  allDifferent(x);
  x[1]>=5;
  x[1] mod 2==0;
  (x[1]*10+x[2]) mod 3==0;
  x[3]==7;
  (x[3]*10+x[4]) mod 5==0;
  (x[1]+x[2]+x[3]+x[4]) mod 9==0;
  
}


/*

==>

x = [6 9 7 5];

*/
