/ A simple tickerplant
/ Usage: q tick.q [DST] [-p 5010] [-o h]

\l schema.q
\l internal/ps.q

t:tables `.             / table names
w:t!(count t)#()        / dictionary of tables->(handle;syms)

ld:{
  if[not type key L::`$(-10_string L),string x;
    .[L;();:;()]];
  i::j::-11!(-2; L);
  if[0<=type i;
    -2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";
    exit 1];
  hopen L }

tick:{[dst]
  if[not min(`time`sym~2#key flip value@)each t;
    '`timesym];
  @[; `sym; `g#]each t;
  d::.z.D;
  if[l::count dst;
    L::`$":",dst,"/",string .z.D;
    l::ld d] }

end:{[x]
  (neg union/[w[;;0]]) @\: (`.u.end; x) }
endofday:{
  end d;
  d+:1;
  if[l;
    hclose l;
    l::0(`ld;d)] }
ts:{
  if[d<x;
    if[d<x-1;
      system"t 0";
      '"more than one day?"];
    endofday[]] }

if[system"t";
  .z.ts:{
    {.ps.pub[`tick; (x; y)]}'[t; value each t]; / previously pub'[t; value each t];
    @[`.; t; @[; `sym; `g#]0#];
    i::j;
    ts .z.D };
  upd:{[t; x]
    if[not -16=type first first x;
      if[d<"d"$a:.z.P; .z.ts[]];
      a:"n"$a;
      x:$[0>type first x; a,x; (enlist(count first x)#a),x]];
    t insert x;
    if[l; l enlist (`upd; t; x); j+:1]; }];

if[not system"t";
  system"t 1000";
  .z.ts:{ts .z.D};
  upd:{[t; x]
    ts"d"$a:.z.P;
    if[not -16=type first first x;
      a:"n"$a;
      x:$[0>type first x; a,x; (enlist(count first x)#a),x]];
    f:key flip value t;
    .ps.pub[`tick; (t; $[0>type first x; enlist f!x; flip f!x])];
    if[l; l enlist (`upd; t; x); i+:1]; }];

tick[.z.x 0];

/
Globals
 i - msg count in log file
 j - total msg count (log file plus those held in buffer)
 L - tp log filename, e.g. `:./2008.09.11
 l - handle to tp log file
 d - date
