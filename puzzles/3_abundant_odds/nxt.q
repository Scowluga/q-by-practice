/ `sd` computes the sum of divisors for an odd number
sd:{sum odds where 0=x mod odds:1+2*til ceiling x%6}

/ `aon` checks if a number is abundant and odd
aon:{(1=x mod 2)&x<sd x}

/ `nxt` obtains the next abundant odd number
nxt:{{not aon x}(2+)/x+$[0=x mod 2; 1; 2]}  / Accumulator: while over

/ First 25
show 24 nxt\nxt 0                           / Accumulator: do scan

/ 1000th
show 1000 nxt/0                             / Accumulator: do over

/ First greater than 1 billion
show nxt 1000000000

/ Note: we omit displaying the sum of divisors - this can be easily included by recomputing sd, or see `nxt_pair.q`
/ Note: via timing, the 3 operations take about 40ms, 70s, and 9m respectively
