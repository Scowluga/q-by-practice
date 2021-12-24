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
/ Each verse starts with the intro line, then various gifts
verses:(enlist intro),/:@[gifts; 0; {"And a",1_x}]@{reverse til x+1}each til count days

/ We customize the lyrics by populating the day
/ Then we replace the "And a" with "A" on only the second line of the lyrics
lyrics:@[; 1; {"A",5_x}] raze verses{@[x; 0; ssr[; "%day"; days[y]]]}'til count days

1 "\n"sv lyrics;
