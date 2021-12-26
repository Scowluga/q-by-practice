/ `sd` computes the sum of divisors for an odd number
sd:{sum odds where 0=x mod odds:1+2*til ceiling x%6}

/ `pair` generates a "pair": a simple list consisting of the number x, and its sum of divisors
/ We use this to avoid recomputing sd when displaying the number and its sum of divisors
pair:{(x; sd x)}

/ `aon` checks if a pair is abundant and odd
aon:{(1=first x mod 2)&first x<last x}

/ `nxt` obtains the next abundant odd pair
nxt:{{not aon x}{pair 2+first x}/pair $[0=(first x) mod 2; 1; 2]+first x}
                                / Accumulator: while over

/ First 25
\t show 24 nxt\nxt pair 0       / Accumulator: do scan

/ 1000th
\t show 1000 nxt/pair 0         / Accumulator: do over

/ First greater than 1 billion
\t show nxt pair 1000000000

/ Note: we can support parallel processing using the peach operator
/ In this solution, in `sd` we would change the `mod` operator to `(mod[x;])':`
/ However, the performance of this even with multiple secondary tasks seems to be orders of magnitude worse
/ Either I am doing something wrong, or perhaps multiple cores are not used and the context switching overhead dominates
