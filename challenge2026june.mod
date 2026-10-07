/*
 * written by IBM Bob
 * ====================
 *
 * PROBLEM
 * -------
 * n superheroes (labelled 1..n). A movie is an ascending chain: hero h1
 * appears solo, h2 joins, ..., generating cumulative sets {h1}, {h1,h2}, ...
 * Cover every non-empty subset of {1..n} at least once.
 * Minimise total action sequences (= sum of chosen-chain lengths).
 *
 * ENCODING
 * --------
 * Heroes  : integers 1..n  (range Heroes)
 * Subsets : integers 1..2^n-1, each integer s encodes the subset via its
 *           binary representation (bit i-1 set <=> hero i present).
 *           This gives a 1-1 mapping that is easy to compute in OPL.
 *
 * A candidate chain of length k is represented as a tuple
 *   (h1, h2, h3, h4, h5, h6)  with h1 in 1..n, h2..h6 in 0..n
 *   where 0 means "not used at this position".
 * Its length is the number of non-zero entries.
 * Its j-th prefix-subset bitmask is  2^(h1-1) + 2^(h2-1) + ... + 2^(hj-1).
 *
 * The set of all candidate chains (ChainSet) and the coverage relation
 * (Covers[s] = set of chains that cover subset s) are both computed as
 * pure OPL set expressions — no execute blocks.
 *
 * PROVEN OPTIMUM (n=6)
 * --------------------
 * b_j = #{chosen chains of length >= j} >= C(n,j). Monotonicity and
 * C(6,3)=20 > C(6,2)=15 force b_1=b_2=b_3=20, b_4=15, b_5=6, b_6=1.
 * Minimum total = 20+20+20+15+6+1 = 82 across 20 movies.
 */

// ---------------------------------------------------------------------------
// 1.  Configuration
// ---------------------------------------------------------------------------

int n = 6;   // number of heroes — change only this line

// ---------------------------------------------------------------------------
// 2.  Basic ranges and sets
// ---------------------------------------------------------------------------

range Heroes  = 1..n;
range Heroes0 = 0..n;                         // 0 = "empty slot" in a chain tuple
int   nSubsets = ftoi(pow(2, n)) - 1;
range Subsets = 1..nSubsets;

// ---------------------------------------------------------------------------
// 3.  Chain tuples
//
// Each chain is a 6-tuple (h1,h2,h3,h4,h5,h6) with:
//   h1 in Heroes  (first hero, always present)
//   h2..h6 in Heroes0  (0 = slot unused)
// Constraint: if hk = 0 then hk+1 = 0  (no gaps)
// Constraint: all non-zero entries are distinct
//
// We build ChainSet as a set comprehension over all valid tuples.
// ---------------------------------------------------------------------------

tuple Chain {
  int h1;   // hero added at step 1  (1..n)
  int h2;   // hero added at step 2  (0 = chain ends here)
  int h3;
  int h4;
  int h5;
  int h6;
}

// All valid candidate chains: h1 set, remaining slots either 0 or a fresh hero,
// no gaps (once a 0 appears, all later slots are 0), all non-zero values distinct.
{Chain} ChainSet = {
  <h1,h2,h3,h4,h5,h6> |
    h1 in Heroes,
    h2 in Heroes0, h3 in Heroes0, h4 in Heroes0, h5 in Heroes0, h6 in Heroes0 :
    // no gaps
    (h2 == 0 => (h3 == 0 && h4 == 0 && h5 == 0 && h6 == 0)) &&
    (h3 == 0 => (h4 == 0 && h5 == 0 && h6 == 0)) &&
    (h4 == 0 => (h5 == 0 && h6 == 0)) &&
    (h5 == 0 => h6 == 0) &&
    // all non-zero entries distinct
    (h2 == 0 || (h2 != h1)) &&
    (h3 == 0 || (h3 != h1 && h3 != h2)) &&
    (h4 == 0 || (h4 != h1 && h4 != h2 && h4 != h3)) &&
    (h5 == 0 || (h5 != h1 && h5 != h2 && h5 != h3 && h5 != h4)) &&
    (h6 == 0 || (h6 != h1 && h6 != h2 && h6 != h3 && h6 != h4 && h6 != h5))
};

// ---------------------------------------------------------------------------
// 4.  Chain length and prefix-bitmasks (pure OPL functions)
// ---------------------------------------------------------------------------

// Length of a chain (number of non-zero hero slots)
int chainLen[c in ChainSet] =
  1
  + (c.h2 != 0 ? 1 : 0)
  + (c.h3 != 0 ? 1 : 0)
  + (c.h4 != 0 ? 1 : 0)
  + (c.h5 != 0 ? 1 : 0)
  + (c.h6 != 0 ? 1 : 0);

// The bitmask of the j-th prefix of chain c:
//   prefix_j = 2^(h1-1) + 2^(h2-1) + ... + 2^(hj-1)
// We precompute the 6 prefix bitmasks for each chain.
// prefix1 is always set; prefix2..6 are 0 when the slot is unused.
int prefix1[c in ChainSet] = ftoi(pow(2, c.h1 - 1));
int prefix2[c in ChainSet] = (c.h2 != 0) ? prefix1[c] + ftoi(pow(2, c.h2 - 1)) : 0;
int prefix3[c in ChainSet] = (c.h3 != 0) ? prefix2[c] + ftoi(pow(2, c.h3 - 1)) : 0;
int prefix4[c in ChainSet] = (c.h4 != 0) ? prefix3[c] + ftoi(pow(2, c.h4 - 1)) : 0;
int prefix5[c in ChainSet] = (c.h5 != 0) ? prefix4[c] + ftoi(pow(2, c.h5 - 1)) : 0;
int prefix6[c in ChainSet] = (c.h6 != 0) ? prefix5[c] + ftoi(pow(2, c.h6 - 1)) : 0;

// ---------------------------------------------------------------------------
// 5.  Coverage relation
//
// Covers[s] = set of chains that cover subset s
// (i.e. s equals one of the chain's non-zero prefix bitmasks)
// ---------------------------------------------------------------------------

{Chain} Covers[s in Subsets] = {
  c | c in ChainSet :
    prefix1[c] == s ||
    prefix2[c] == s ||
    prefix3[c] == s ||
    prefix4[c] == s ||
    prefix5[c] == s ||
    prefix6[c] == s
};

// ---------------------------------------------------------------------------
// 6.  Decision variables
// ---------------------------------------------------------------------------

// x_use[c] = 1  iff chain c is selected as a movie
dvar boolean x_use[ChainSet];

// ---------------------------------------------------------------------------
// 7.  Objective: minimise total action sequences
// ---------------------------------------------------------------------------

minimize
  sum(c in ChainSet) chainLen[c] * x_use[c];

// ---------------------------------------------------------------------------
// 8.  Constraints: every non-empty subset must be covered
// ---------------------------------------------------------------------------

subject to {

  forall(s in Subsets)
    ct_cover:
      sum(c in Covers[s]) x_use[c] >= 1;

}

// ---------------------------------------------------------------------------
// 9.  Solution display (pure OPL — no scripting)
// ---------------------------------------------------------------------------

// Hero-number to letter: named string array indexed by Heroes
string heroNames[1..6] = ["A","B","C","D","E","F"];
string heroLabel[h in Heroes] = heroNames[h];

execute PRINT {
  writeln("");
  writeln("============================================");
  writeln("  Superhero Franchise Optimum  (n=", n, ")");
  writeln("============================================");
  writeln("Minimum total action sequences: ", cplex.getObjValue());
  writeln("");

  var movieNo = 0;
  var compact = "";
  for (var c in ChainSet) {
    if (x_use[c] != 1) continue;
    movieNo++;
    // Per-movie line
    write("Movie " + movieNo + " (len=" + chainLen[c] + "): ");
    write(heroLabel[c.h1]);
    if (c.h2 != 0) write("-" + heroLabel[c.h2]);
    if (c.h3 != 0) write("-" + heroLabel[c.h3]);
    if (c.h4 != 0) write("-" + heroLabel[c.h4]);
    if (c.h5 != 0) write("-" + heroLabel[c.h5]);
    if (c.h6 != 0) write("-" + heroLabel[c.h6]);
    writeln();
    // Accumulate compact string: "0" separator then hero letters in order
    compact += "0" + heroLabel[c.h1];
    if (c.h2 != 0) compact += heroLabel[c.h2];
    if (c.h3 != 0) compact += heroLabel[c.h3];
    if (c.h4 != 0) compact += heroLabel[c.h4];
    if (c.h5 != 0) compact += heroLabel[c.h5];
    if (c.h6 != 0) compact += heroLabel[c.h6];
  }
  writeln("");
  writeln("Total movies  : ", movieNo);
  writeln("Compact format: ", compact);
  writeln("============================================");
}

/*
which gives

// solution (optimal) with objective 82

============================================
  Superhero Franchise Optimum  (n=6)
============================================
Minimum total action sequences: 82

Movie 1 (len=4): A-C-E-F
Movie 2 (len=5): A-D-C-F-E
Movie 3 (len=5): B-A-E-F-D
Movie 4 (len=5): B-D-C-F-A
Movie 5 (len=3): B-E-D
Movie 6 (len=3): B-E-F
Movie 7 (len=3): C-A-F
Movie 8 (len=5): C-B-A-E-D
Movie 9 (len=4): C-D-E-A
Movie 10 (len=4): C-E-B-D
Movie 11 (len=4): C-F-B-E
Movie 12 (len=3): C-F-E
Movie 13 (len=4): D-A-B-C
Movie 14 (len=4): D-F-C-E
Movie 15 (len=4): E-A-F-D
Movie 16 (len=4): E-D-A-B
Movie 17 (len=4): F-A-D-B
Movie 18 (len=6): F-B-A-C-E-D
Movie 19 (len=5): F-B-D-E-C
Movie 20 (len=3): F-E-D

Total movies  : 20
Compact format: 0ACEF0ADCFE0BAEFD0BDCFA0BED0BEF0CAF0CBAED0CDEA0CEBD0CFBE0CFE0DABC0DFCE0EAFD0EDAB0FADB0FBACED0FBDEC0FED
============================================

*/

