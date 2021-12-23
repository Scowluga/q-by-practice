gifts:(
  "A partridge in a pear tree.";
  "Two turtle doves";
  "Three french hens";
  "Four calling birds";
  "Five golden rings";
  "Six geese a-laying";
  "Seven swans a-swimming";
  "Eight maids a-milking";
  "Nine ladies dancing";
  "Ten lords a-leaping";
  "Eleven pipers piping";
  "Twelve drummers drumming")

days:" "vs"first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelfth"

introduction:"On the %day day of Christmas, my true love sent to me:"

{[day];
  show ssr[introduction; "%day"; days[day]];
  lyrics:reverse gifts[til 1+day];
  / Can't think of a better solution without control flow - indexing at depth out of bounds (no if) causes 'length error
  / We could amend in place at `(day-1) mod count days` in the general list before truncating, but this seems convoluted   
  if[day>0;lyrics[day-1],:" and"];
  show "--> ",/:lyrics;} each til count days;
