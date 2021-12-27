/ For the display of small numbers
ones:``one`two`three`four`five`six`seven`eight`nine;
from10to20:``eleven`twelve`thirteen`fourteen`fifteen`sixteen`seventeen`eighteen`nineteen;
tens:``ten`twenty`thirty`forty`fifty`sixty`seventy`eighty`ninety;

/ `itos_small` converts a small natural number 0<x<100 to a string
itos_small:{
  $[(x>=11) and x<=19; string from10to20 x-10;
    trim (string tens bin[10*til count tens; x])," ",(string ones bin[til count ones; x mod 10])]}

/ `denom` represents applying a denomination during integer to string conversion
/ Denoms are represented by a symbol `sym` and value `val`, and are applied to number `x` and converted string `s`
denom:{[sym; val; x; s]
  if[x>=val;
    s:s,(itos x div val)," ",(string sym)," ";
    x:x mod val];
  (x; s)}

/ `itos` converts a natural number to a string
/ We use a binary while accumulator to apply each function to the initial state
itos:{trim last (x; `char$()){y . x}/(
  denom[`trillion; 1000000000000;;];
  denom[`billion; 1000000000;;];
  denom[`million; 1000000;;];
  denom[`thousand; 1000;;];
  denom[`hundred; 100;;];
  {[x; s]if[x>0; s,:itos_small x]; (0; s)})}
