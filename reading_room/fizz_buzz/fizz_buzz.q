/ Start with first 20 natural numbers
x:1+til n:20

/ We can find fizz and buzz conditions using mod
0=x mod 3;
0=x mod 5;

/ We find both at the same time
0=x mod/:3 5;           / each right iterator, unary atomic function = matches argument shape

/ We need one of 4 conditions: neither, multiple of 3, multiple of 5, multiple of both
/ We use binary for this
sum 1 2*0=x mod/:3 5;   / binary atomic function * applies pairwise, like zip

/ We generate 4 lists of output symbols to choose from depending on the values above
(`$string x; n#`fizz; n#`buzz; n#`fizzbuzz);

/ We use the case iterator to generate results
/ Notice the case iterator automatically treats atoms as infinite-repeating
(sum 1 2*0=x mod/:3 5)'[`$string x; `fizz; `buzz; `fizzbuzz]
