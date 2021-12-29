# [Scrabble](https://code.kx.com/q/learn/reading/scrabble/)
As an amateur Scrabble player, I really enjoyed this example and decided to extended it to support features I would
personally use in a real game (and have wanted for a long time).
Obtain a copy of the word list locally, fill in the path to that file, and you are good to go!

Features:
- `by_score` function displaying valid words for a rack, by score.
- `bingo` function displaying valid bingos for a rack, by score.
- Support for wildcard character `"_"` to imitate blanks. Note that the corresponding score does not account for blanks
  scoring 0.
- `twos[]` function to display all two letter words grouped by first letter.
- `valid` to check validity of a word.

Good luck in your next game!
