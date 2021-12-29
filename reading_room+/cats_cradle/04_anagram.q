/ Are two strings anagrams?
a:{not any (count each group x)-count each group y}     / we use dictionary subtraction which operates key-wise

a:{(asc x)~asc y}                                       / we sort and check equality
