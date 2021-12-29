/ Whether dictionaries are equal
deq:{(asc asc each x)~(asc asc each y)}

/ Indicies of x rotated by y
r:{mod[y+group[x]; count x]}

/ EQual Rotated - is y a rotated version of x?
eqr:{
  rotations:r[y;] each til count y; 
  eqs:deq[group[x];] each rotations;
  any eqs }

/ Unfinished. This solution is extremely verbose. 
