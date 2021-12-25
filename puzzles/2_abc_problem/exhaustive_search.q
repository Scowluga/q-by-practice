BLOCKS:string`BO`XK`DQ`CP`NA`GT`RE`TG`QD`FS`JW`HU`VI`AN`OB`ER`FS`LY`PC`ZM
WORDS:string`A`BARK`BOOK`TREAT`COMMON`SQUAD`CONFUSE

/ Exhaustive search all possible block permutations to form a word
exhaust:{[bs; w]$[0=count w; 1;[                     / base case (blank word)
  candidates:where (upper first w) in/: bs;          / candidates are blocks that can be used for the first letter of w
  search:{[bs; w; c]exhaust[bs _ c; w _ 0]}[bs; w;]; / `search` recursively explores all subproblems given a candidate
  any search each candidates]]}

show sols:exhaust[BLOCKS;] each WORDS
