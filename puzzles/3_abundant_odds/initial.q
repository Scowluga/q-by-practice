/ Checks if a number is abundant and odd
/ When obtaining divisors, we only check odd numbers up to x%3
ao:{(1=x mod 2)&x<sum odds where 0=x mod odds:1+2*til x div 6}

/ Obtains the next abundant odd number
nxt:{{not ao x}{x+2}/x+$[0=x mod 2; 1; 2]}  / Accumulator: while over

/ First 25: 945 1575 2205...
show 24 nxt\nxt 0                           / Accumulator: do scan

/ 1000th: 492975
show 1000 nxt/0                             / Accumulator: do over

/ First greater than 1 billion: 1000000575
show nxt 1000000000
