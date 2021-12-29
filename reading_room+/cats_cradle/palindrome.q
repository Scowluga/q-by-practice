/ Is x a palindrome?
p:{x~reverse x}

p:{all x=reverse x}

p:{
  h:(count x) div 2;    / only check first half of characters
  (h#x)~reverse (neg h)#x }
