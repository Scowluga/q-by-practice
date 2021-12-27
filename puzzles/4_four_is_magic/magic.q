/ For the display of small numbers
ones:``one`two`three`four`five`six`seven`eight`nine;
from10to20:``eleven`twelve`thirteen`fourteen`fifteen`sixteen`seventeen`eighteen`nineteen;
tens:``ten`twenty`thirty`forty`fifty`sixty`seventy`eighty`ninety;

/ `denom` represents applying a denomination during integer to string conversion
/ Denoms are represented by a symbol `sym` and value `val`, and are applied to number `x` and converted string `s`
denom:{[sym; val; x; s]
  $[x<val; (x; s);
    (x mod val; s,(itos x div val)," ",(string sym)," ")]}

/ `itos` converts a natural number to a string
/ We use a binary while accumulator to apply each function to the initial state
/ We can think of function applications like moving the initial value and string along a 1D finite state machine
itos:{trim last (x; `char$()){y . x}/(
  denom[`trillion; 1000000000000;;];
  denom[`billion; 1000000000;;];
  denom[`million; 1000000;;];
  denom[`thousand; 1000;;];
  denom[`hundred; 100;;];
  {[x; s]                               / custom logic to convert values 0<=x<100
    $[x=0; (0; s);
      (x>=11) and x<=19; string from10to20 x-10;
      trim (string tens bin[10*til count tens; x])," ",(string ones bin[til count ones; x mod 10])]})}

magic:{
  list:{count itos x}\[x];              / convergence accumulator
  out:{(itos y)," is ",itos x}':[list]; / each prior
  1 _ out,enlist "four is magic"}
