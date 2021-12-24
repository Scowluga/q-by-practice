gifts:(
  " partridge in a pear tree.";
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

days:" "vs"first second third forth fifth sixth seventh eighth ninth tenth eleventh twelfth"

/ We print the "and" before the last line, except on the first day
/ e.x.
/ Two turtle doves
/ And a partridge in a pear tree.
lyrics:raze {[day]
  enlist["On the ", days[day], " day of Christmas, my true love sent to me:"],
  "> ",/:reverse (day+1)#@[gifts; 0; $[day>0; "And a"; "A"],]} each til count days

1 "\n"sv lyrics;
