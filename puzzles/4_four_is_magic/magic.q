/ For the display of numbers less than 100
small:``one`two`three`four`five`six`seven`eight`nine`ten,
  `eleven`twelve`thirteen`fourteen`fifteen`sixteen`seventeen`eighteen`nineteen;
tens:``ten`twenty`thirty`forty`fifty`sixty`seventy`eighty`ninety;

/ `denom` represents applying a denomination during integer to string conversion
denom:{[sym; val; x; s]                   / denom (symbol `sym`, value `val`) applied to state (number `x`, string `s`)
  $[x<val; (x; s);
    (x mod val; s,(itos x div val)," ",(string sym)," ")] }

/ Convert natural number to string
itos:{trim last (x; `char$()){y . x}/(    / binary while accumulator
  denom[`trillion; 1000000000000;;];
  denom[`billion; 1000000000;;];
  denom[`million; 1000000;;];
  denom[`thousand; 1000;;];
  denom[`hundred; 100;;];
  {[x; s]                                 / custom logic to convert values 0<=x<100
    $[x=0; s;
      x<count small; string small x;
      trim (string tens x div 10)," ",(string small x mod 10)] }) }

/ Four is magic
magic:{
  list:(count itos@)\[x];                 / convergence accumulator
  out:{(itos y)," is ",itos x}':[list];   / each prior
  1 _ out,enlist "four is magic" }
