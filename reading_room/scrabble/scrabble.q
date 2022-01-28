/ Scrabble tile values
TV:(upper .Q.a)!1 3 3 2 1 4 2 4 1 8 5 1 3 1 1 3 10 1 1 1 1 4 4 8 4 10;

/ Word list
WL:read0 `$"/Users/davidlu/q/q-by-practice/reading_room+/scrabble/CSW.txt";

/ Frequency count of a word
fc:{count each group x}

/ Whether one frequency count is a superset of another (contains all chars)
/ The first frequency count is allowed to contain wildcards "_" indicating blanks that match any tile
fss:{
  missing:neg sum diff where 0>diff:x-y;
  missing<=$[x["_"]=0N; 0; x["_"]] }                  / TODO: surely there is a better way of doing this than a cond

/ Table of words sorted in descending order of word scores
DT:`score xdesc ([]
  word:WL;
  length:count each WL;
  freqs:fc each WL;
  score:{sum TV x}each WL);

/ Display valid words given a rack
by_score:{select word,score from DT where fc[upper x]fss/:freqs};
bingo:{select word,score from DT where length>=7|count x,fc[upper x]fss/:freqs};

/ Utility display for two letter words
twos:{[]                                              / nullary function, invoked via `twos[]`
  words:WL where 2=count each WL;                     / filter WL to get two letter words
  changes: where ({first[x]<>first y}':)words;        / use each prior ': to find indices where the first letter changes
  cl:cut[changes; words];                             / use `cut` to partition words by first letter
  show each " "sv/:cl;}                               / join each list by spaces using `sv` applied each right /:

/ Check valid word
valid:{(upper x) in WL}
