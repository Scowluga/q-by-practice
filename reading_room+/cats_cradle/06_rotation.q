/ ----- My attempt -----
eqr:{
  rotations:{mod[y+group[x]; count x]}[x;] each til count x;          / use mod to get rotated index
  any {(asc asc each x)~(asc asc each y)}[;group[y]] each rotations } / sort dictionaries to check identity ~

/ ----- Provided solution -----
/ We use scan convergence accumulator to generate all rotations (since convergence means looping back to original)
f1:{x in (1 rotate)scan y}

f2:{x in {raze reverse 0 1 _ x}scan y}
