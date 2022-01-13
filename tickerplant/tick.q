/ A simple tickerplant
/ Usage: q tick.q [DST] [-p 5010] [-o h]

\l schema.q
\l internal/ps.q

ld:{
  if[not type key L::`$(-10_string L),string x;
    .[L;();:;()]];
  j::-11!(-2; L);           / j - total msg count (log file plus those held in buffer)
  i::j                      / i - msg count in log file
  if[0<=type i;
    -2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";
    exit 1];
  hopen L }

tick:{[dst]
  t::tables `.;             / table names
  w::t!(count t)#();        / dictionary of tables->(handle;syms)
  .z.ts:{ts .z.D};
  system"t 1000";
  d::.z.D;                  / current date
  if[not min(`time`sym~2#key flip value@)each t;
    '`timesym];
  @[; `sym; `g#]each t;
  if[l::count dst;          / if there is a specified log file
    L::`$":",dst,"/",string .z.D; / tp log filename, e.g. `:./2008.09.11
    l::ld d]; }             / l is handle to the tickerplant log file

end:{[x]
  (neg union/[w[;;0]]) @\: (`end; x) }
endofday:{
  end d;
  d+:1;
  if[l;
    hclose l;
    l::0(`ld; d)] }
ts:{
  if[d<x;
    if[d<x-1;
      system"t 0";
      '"more than one day?"];
    endofday[]] }

upd:{[t; x]
  ts"d"$a:.z.P;
  if[not -16=type first first x;
    a:"n"$a;
    x:$[0>type first x; a,x; (enlist(count first x)#a),x]];
  f:key flip value t;
  .ps.pub[`tick; (t; $[0>type first x; enlist f!x; flip f!x])];
  if[l; l enlist (`upd; t; x); i+:1]; }

init:{[topic; port]                / tells the ticker to subscribe to a feed
  tick[.z.x 0];
  .ps.sub[topic; port; upd]; }
