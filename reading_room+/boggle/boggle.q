/ ----- Game information -----
BOXES:()!()
BOXES[`new]:"AAEEGN ELRTTY AOOTTW ABBJOO EHRTVW CIMOTU DISTTY EIOSST DELRVY ACHOPS HIMNQU EEINSU EEGHNW AFFKPS HLNNRZ DEILRX"
BOXES[`old]:"AACIOT AHMORS EGKLUY ABILTY ACDEMP EGINTV GILRUW ELPSTU DENOSW ACELRS ABJMOQ EEFHIY EHINPS DKNOTU ADENVZ BIFORX"

VERSION:`old
DICE:" "vs BOXES VERSION
BS:`int$sqrt count DICE                             / board size

URL:"http://wiki.puzzlers.org/pub/wordlists/unixdict.txt"
UD:upper system"curl -s ",URL                       / Unix dictionary
BD:ssr[; "QU"; "Q"] each UD where 17>count each UD  / Boggle dictionary - replace QU with Q, and filter by length

SC:0 0 0 1 1 2 3 5,9#11                             / scores by word length

/ ----- Helpers -----
BC:til[BS] cross til[BS]                            / board coordinates: 0 0, 0 1, 0 2, ..., 3 2, 3 3

nb:{[BS; c]                                         / neighbors of coordinate `c` in board with dimensions BS x BS
  nbs:(.[cross] -1 0 1+/:c) except enlist c;        / shift each coord by -1, 0, +1 then cross to enumerate neighbors
  nbs where all each nbs within 0,BS-1 }            / filter out-of-bounds

NBI:BS {x sv flip nb[x; y]}'BC                      / indices of neighbors within razed board - using base 4 (sv)

explore:{[b; bd; state]                             / explores a board given a state to collect words
  ci:first state;                                   / current strings as indexes in razed board `b`
  cw:last state;                                    / current words found so far
  ni:raze {x,/:(NBI last x) except x} each ci;      / next strings (as indexes) to try, by appending each NBI
  nw:b[ni];                                         / new words found
  ni:ni where nw in (count first ni)#'bd;           / eliminate duds by ensuring `nw`s exist as prefix in `bd`
  aw:distinct cw,nw where nw in bd;                 / all words consisting of current words and new words
  (ni; aw) }

/ ----- Play Boggle -----
Throw:{[dice]
  (2#BS)#raze 1?/:dice }                            / (roll ?) 1 face per dice; (take #) to arrange into grid
/ (2#BS)#dice@'count[dice]?6 }                      / (roll ?) count[dice] indices; (apply @) dice at (each ') index

Solve:{[board]
  b:raze board;                                     / we deal with a razed board to access positions by single index
  bd:BD where all each BD in b;                     / we use a dictionary subset with only chars appearing on the board
  c:explore[b; bd;]/[(1#'til 16; ())];              / use over convergence to explore board and collect all words
  s:distinct last c;                                / extract list of words from final state
  s:ssr[; "Q"; "QU"] each s;                        / restore "Q"s to "QU"
  s:{x idesc count each x} asc s;                   / sort asc alpha within desc size
  sc:SC @ count each s;                             / score each word found
  s:s where sc>0;                                   / discard words that are too short (have 0 score)
  sc:sc where sc>0;
  show "maximum total score: ",string sum sc;       / output maximum total score with all words
  $[`; s]!sc }                                      / return dictionary with strings as symbols
