/ Vowels
V:"AEIOUYaeiouy";

/ Replace all vowels with "_"
s1:{x[where x in V]:"_"; x}             / assignment; in
s2:{x[where (count V)>V?x]:"_"; x}      / assignment; find
s3:{@[x; where x in V; :; "_"]}         / amend at
s4:{(x; "_")x in V} each                / index in list (x; "_"), eliding second argument of `each`
s5:{?[x in V; "_"; x]}                  / vector conditional (https://code.kx.com/q/ref/vector-conditional/)
s6:{(`int$x in V)'[x; "_"]}             / case (implicitly applies input index to cond `x`)
s7:ssr/[; V; "_"]                       / Ternary value scan accumulator using `ssr`
