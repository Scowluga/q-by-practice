/ Spread the characters of x to the positions of 1s in y and fill with underscores
e:{("_",x)y*sums y}

/ This is a truly beautiful solution. The straightforward iterative approach definitely works, but is verbose.
/ I guessed we should use `sums y`, but didn't make the connection to multiply `y*sums y`.
/ Multiple indexing on `("_",x)` to avoid a cond is just the icing on top.
