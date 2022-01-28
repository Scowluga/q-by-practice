/ ----- Provided solution -----
/ This solution is obviously incorrect so I investigated to try and fix it
/ It looks like the core technique is quite nice: we use `vs` to list all same-length boolean representations
/ We treat these as indices and then filter the list to apply to the input
f0:{x {flip[y]where x=sum y}[s;] s vs til"j"$s xexp s:count x}

/ ----- Fixing -----
/ Problem 1: filter criterion
/ We consider a binary representation of equal length to the input. The solution filters by checking count = sum
/ This is obviously incorrect. Consider length 3 and boolean representation 1 1 1 with equal sum 3
/ Instead, we must check that for each til the count, it is contained in the list - we do precisely this

/ Problem 2: distinct permutations
/ This solution completely ignores the input values, and instead naively enumerates all indices
/ As a hack, we can remove duplicates by just applying `distinct` to the output

/ ----- Finished -----
/ After solving the two main problems, and modifying a bit of syntax, we arrive at a (hopefully) correct solution
f:{distinct x @ b where all each (til c) in/:b:flip c vs til `int$c xexp c:count x}
