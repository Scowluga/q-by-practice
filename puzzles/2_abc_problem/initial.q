BLOCKS:string`BO`XK`DQ`CP`NA`GT`RE`TG`QD`FS`JW`HU`VI`AN`OB`ER`FS`LY`PC`ZM
WORDS:string`A`BARK`BOOK`TREAT`COMMON`SQUAD`CONFUSE

find:{[bs; w]$[0=count w; 1b;[                    / base case (blank word)
  candidates:where (first w) in/: bs;             / a candidate block is one that can be used for the first letter of w
  search:{[bs; w; c]find[bs _ c; w _ 0]}[bs; w;]; / `search` recursively explores subproblems given a candidate
  count where search each candidates]]}           / `find` returns the number of valid block permutations

show find[BLOCKS;] each WORDS
