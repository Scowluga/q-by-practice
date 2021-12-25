BLOCKS:string`BO`XK`DQ`CP`NA`GT`RE`TG`QD`FS`JW`HU`VI`AN`OB`ER`FS`LY`PC`ZM
WORDS:string`A`BARK`BOOK`TREAT`COMMON`SQUAD`CONFUSE

/ Stress test: 105 ms
/ m:5
/ BLOCKS:upper string (m*3)?`8
/ WORDS:upper {((rand m)+(rand m)+(rand m))?.Q.a} each til 100

backtrack:{[w; bs]                                       / w:word; bs:blocks
  .done::0b;                                             / flag to terminate subproblem searching 
  {[w; bs]
    $[.done; 1b;                                         / solution reached - skip subproblem
      0=count w; .done::1b;                              / base case - mark problem as .done and return it
      any .z.s[w _ 0;] each bs _/:where (upper first w) in/:bs]}[w; bs]}

\t sols:backtrack[;BLOCKS] each WORDS
show sols
