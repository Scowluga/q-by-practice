/ ----- My attempt -----
/ Insert element `e` at index `i` into list `l`
ins:{[l; e; i]
  l[til i],e,i _ l}

perword:{[w; c]
  w ins[;c;]/:where ({x<>z}[;;c]':)("!",w)}           / each prior to identify where to insert

/ All permutations of input
p:{(enlist 1#x){raze perword[; y] each x}/(x _ 0)}    / accumulator over each char in input

/ ----- Provided solution -----
