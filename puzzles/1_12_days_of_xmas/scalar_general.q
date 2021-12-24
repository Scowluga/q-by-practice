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

days:" "vs"first second third forth fifth sixth seventh eighth ninth tenth eleventh twelfth"

intro:"On the %day day of Christmas, my true love sent to me:"

/ Inspiration from https://code.kx.com/q/learn/pb/xmas-days/#q-eye-for-the-scalar-guy
/ We organize possible lines into a stanza, and "apply at" with multiple indexing to get lyrics for each verse
stanza:gifts,enlist intro
verses:stanza@reverse each {(til x+1),count gifts}each til count days

/ Then we customize the lyrics by populating the day, and managing the "and" on the last line of every verse
lyrics:raze verses{[v; d]@[@[v; 0; ssr[; "%day"; days[d]]]; (count v)-1; {y,1_x}; $[d>0; "And a"; "A"]]}'til count days

1 "\n"sv lyrics;
