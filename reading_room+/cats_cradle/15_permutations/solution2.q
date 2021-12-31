/ ----- Provided solution -----
/ This solution takes a unique approach to generating permutations
/ `{raze reverse 0 1 _ x}` is left rotation by one, e.x. "abcd" -> "bcda"
/ `x,'y` appends y to all in x, e.x. ("aa"; "bb"),'"d" -> ("aad"; "bbd")
/ `({}\)` is convergence scan accumulator. Left rotation each time means we generate every rotation
/ So we generate every rotation for each word having each char appended after - this is precisely all permutations
f0:{(1 0#x) {distinct raze({raze reverse 0 1 _ x}\)each x,'y}/ x}

/ This solution appears correct until direct scrutiny
/ Consider input "baa", where we see 6 outputs instead of 3 - each output appears twice
/ This happens because the final "a" appended do "ba" and "ab" does not lead to two unique rotatable strings
/ Instead, rotations for both strings are identical, hence the duplicate result

/ ----- Fixed -----
/ We ensure `distinct` results, and use `rotate` as in the phrasebook
f:{(enlist 0#x){distinct raze (1 rotate) scan'x,'y}/x}
