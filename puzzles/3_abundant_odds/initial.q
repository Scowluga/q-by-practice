/ Checks if a number is abundant and odd
/ When obtaining divisors, we only check odd numbers up to x%3
abundant_odd:{(1=x mod 2)&x<sum odds where 0=x mod odds:1+2*til ceiling x%6}

/ Obtains the next abundant odd number
nxt:{{x+2}/[{not abundant_odd x}; x+$[0=x mod 2; 1; 2]]}

/ First 25
show 24 nxt\nxt 0 / 945 1575 2205...

/ 1000th
show 1000 nxt/0 / 492975

/ First greater than 1 billion
show nxt 1000000000 / 1000000575
