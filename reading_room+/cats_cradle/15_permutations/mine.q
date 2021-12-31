/ ----- My attempt -----
/ Instead of building permutations recursively,
/   we take each character one-by-one and try to "insert" it into every possible slot

ins:{[l; e; i]                                        / insert element `e` at index `i` into list `l`
  l[til i],e,i _ l}                                   / TODO: surely better way

perchar:{[ws; c]
  distinct raze {[w; c]
    w ins[;c;]/:where ({x<>z}[;;c]':)("!",w) }[;c]    / each prior to identify where to insert
  each ws }

/ All permutations of input
p:{(enlist `char$())perchar\x}                        / accumulator over each char in input
