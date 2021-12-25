BLOCKS:string`BO`XK`DQ`CP`NA`GT`RE`TG`QD`FS`JW`HU`VI`AN`OB`ER`FS`LY`PC`ZM
WORDS:string`A`BARK`BOOK`TREAT`COMMON`SQUAD`CONFUSE

/ Stress test: 385 ms
/ m:5
/ BLOCKS:upper string (m*3)?`8
/ WORDS:upper {((rand m)+(rand m)+(rand m))?.Q.a} each til 100

backtrack:{[w; bs]
  $[0=count w; 1b;
    any .z.s[w _ 0;] each bs _/:where (upper first w) in/:bs]}

\t sols:backtrack[;BLOCKS] each WORDS
show sols

/ Note: for our recursive search step, we apply a unary each using the `each` keyword
/ We could just as well apply the argument (w _ 0) each right using .z.s, which is arguably more readable
/ i.e. `any (w _ 0).z.s/:bs _/:where (upper first w) in/:bs`
