show "hello";

/ `filter` filters list `l` based on function `f` using available secondary threads
filter:{[f; l]l show "hi"; where f peach l}

/ `sd` computes the sum of divisors for an odd number
/ sd:{sum odds where 0=x mod odds:1+2*til ceiling x%6}
sd:{sum filter[{0=x mod y}[x;]; 1+2*til ceiling x%6]}

/ `aon` checks if a number is abundant and odd
aon:{(1=x mod 2)&x<sd x}

/ `nxt` obtains the next abundant odd number
nxt:{{not aon x}{x+2}/x+$[0=x mod 2; 1; 2]} / Accumulator: while over

/ First 25: 945 1575 2205...
\t 24 nxt\nxt 0                          / Accumulator: do scan
/show q1; sd each q1

/ 1000th: 492975
\t q2:1000 nxt/0                            / Accumulator: do over
show (q2; sd q2)

/ First greater than 1 billion: 1000000575
\t q3:nxt 1000000000
show (q3; sd q3)
