using CP;   
// Data   
range Letters      = 1..18; 
range Permutations = 1..13; 
string letter[Letters] = [
"A", 
"B", 
"C", 
"E", 
"F", 
"H", 
"I", 
"J", 
"L", 
"M", 
"N", 
"P", 
"Q", 
"T", 
"V", 
"X", 
"Y", 
"Z"];   
tuple Pair   
{ 

int l1; 

int l2; 
} tuple Triple 
{ 

int l1; 

int l2; 

int l3; 
} 
{Pair
}   Pairs   = 
{ <l1,l2> | l1,l2 in Letters : l1!=l2 
}; 
{Pair
}   OPairs  = 
{ <l1,l2> | l1,l2 in Letters : l1<l2  
}; 
{Triple
} Triples = 
{ <l1,l2,l3> | l1,l2,l3 in Letters : l1!=l2 && l1!=l3 && l2!=l3 
};   
// CP Optimizer model   

dvar int b[p in Permutations][OPairs] in ((p==1)?1:0)..1; 
// Symmetry breaking for first permutation (p=1) 
dexpr int before[p in Permutations][<l1,l2> in Pairs] = (l1<l2)?b[p][<l1,l2>]:(1-b[p][<l2,l1>]); 

dexpr int contains[p in Permutations][<l1,l2,l3> in Triples] = minl(before[p][<l1,l2>], before[p][<l2,l3>]); subject to 
{ forall(p in Permutations, <l1,l2,l3> in Triples) 
{ contains[p][<l1,l2,l3>] <= before[p][<l1,l3>]; 
} 
// Transitive closure 
forall(<l1,l2,l3> in Triples) 
{ sum(p in Permutations) contains[p][<l1,l2,l3>] >= 1; 
} 
}   
// Post-processing: display solution   

int position[p in Permutations][l in Letters] = 1+sum(l1 in Letters: l1!=l) before[p][<l1,l>]; 

int solution[Permutations][Letters];   execute 
{ 

for(var p in Permutations) 

for(var l in Letters) solution[p][position[p][l]]=l; 

for(var p1 in Permutations) 
{ 

for(var l1 in Letters) write(letter[solution[p1][l1]]); writeln(); 
} 
}


/*

which gives

ABCEFHIJLMNPQTVXYZ
FQCLXPHBZYNIAVTMJE
QPMFELYAXZTVBCJNIH
YHBQEVIMJZCTNXLAFP
LEJHAQNXFZCTPMBVYI
CTNMLIFXAVHBEZYQJP
NVQALZJMPIBCYHETXF
JXZVAENTCQHBMFILYP
TJIYEBPZLVFHCMQANX
VPXYILNFJTQMCZEBHA
NHEYCZPFMVJALIBXQT
ZIHXMPTACVQJFNYBLE
BFTAZYPXEMQHLINJVC

*/