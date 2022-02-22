/*********************************************
 * OPL 20.1.0.1 Model
 * Author: Alex Fleischer
 * Creation Date: 22 févr. 2022 at 15:31:52
 *********************************************/
 
 // French data format dd/mm/yyyy
 range figures=0..9;
 {int} monthswith30days={4,6,9,11};
 dvar int day in 1..31;
 dvar int month in 1..12;
 dvar int year in 2023..9999;
 
 dvar int d1 in 0..3;
 dvar int d2 in figures;
 dvar int m1 in 0..1;
 dvar int m2 in figures;
 dvar int y1 in figures;
 dvar int y2 in figures;
 dvar int y3 in figures;
 dvar int y4 in figures;
 
 minimize staticLex(year,month,day);
 subject to
 {
   day==10*d1+d2;
   month==10*m1+m2;
   year==1000*y1+100*y2+10*y3+y4;
   
   d1==y4;
   d2==y3;
   m1==y2;
   m2==y1;
   
   /*
   // US Format mm/dd/yyyy
   m1==y4;
   m2==y3;
   d1==y2;
   d2==y1;
   */
    
   (month==2)=>(day<=29);
   forall(m in monthswith30days) (month==m)=>(day<=30);
 }
 
 float date1;
 float date2;
 execute
 {
   writeln(day,"/",month,"/",year);
   
   date1=new Date(   year,month,day);
   date2=new Date(2022,2,22);
   var nbDays=Opl.round((date1-date2)/3600/24/1000);
   writeln("So we will have to wait ",nbDays," days");
 }
 
 /*
 
 which gives
 
 3/2/2030
 So we will have to wait 2903 days
 
 or
 
 2/3/2030
So we will have to wait 2933 days

if we choose US format
 
 */
