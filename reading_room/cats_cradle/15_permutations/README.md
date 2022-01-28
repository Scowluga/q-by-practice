# [Is it more fun to permute](https://code.kx.com/q/learn/reading/strings/#its-more-fun-to-permute)
It appears there are a few issues with the "find all permutations" solutions provided. 
Primarily, none of solutions deal with duplicates, which is incredibly important. I have inserted `distinct` operators
to ensure no duplicate permutations. 

Opened https://github.com/KxSystems/docs/issues/56 to track this issue.

List of solutions:
- `mine.q` my initial attempt, inserting chars into words. 
- `solution1.q` the first provided solution, which is completely incorrect. I fixed it.
- `solution2.q` the second provided solution, which is quite interesting. I added `distinct` to it.

## Unique permutations without `distinct`
I believe this is doable, however we'd have to processing the input word in sorted order and deal with "runs" of chars.
This is project TODO next time.
