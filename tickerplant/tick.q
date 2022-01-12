/ A simple tickerplant
/ Usage: q tick.q [DST] [-p 5010] [-o h]

\l schema.q                            / load table schemas

/ =====================================================================================================================
/ u.q

\d .u
init:{
  w::t!(count t::tables`.)#() }

del:{[x; y]
  w[x]_:w[x;;0]?y }

.z.pc:{                             / override port close handler
  del[; x]each t }

sel:{[x; y]
  $[`~y; x;select from x where sym in y] }

pub:{[t; x]
  {[t; x; w]
    if[count x:sel[x]w 1; (neg first w)(`upd; t; x)] }[t; x]each w t }

add:{
  $[(count w x)>i:w[x;;0]?.z.w; .[`.u.w;(x;i;1);union;y];
    w[x],:enlist(.z.w; y)]; (x; $[99=type v:value x; sel[v]y; @[0#v; `sym; `g#]]) }

sub:{[x; y]
  if[x~`; :sub[;y]each t];
  if[not x in t; 'x];
  del[x].z.w;
  add[x; y] }

end:{[x]
  (neg union/[w[;;0]]) @\: (`.u.end; x) }
/ =====================================================================================================================
/ tick.q

ld:{
  if[not type key L::`$(-10_string L),string x;
    .[L;();:;()]];
  i::j::-11!(-2; L);
  if[0<=type i;
    -2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";
    exit 1];
  hopen L }

tick:{[dst]
  init[];
  if[not min(`time`sym~2#key flip value@)each t;
    '`timesym];
  @[; `sym; `g#]each t;
  d::.z.D;
  if[l::count dst;
    L::`$":",dst,"/",string .z.D;
    l::ld d] }

endofday:{
  end d;
  d+:1;
  if[l;
    hclose l;
    l::0(`.u.ld;d)] }
ts:{
  if[d<x;
    if[d<x-1;
      system"t 0";
      '"more than one day?"];
    endofday[]] }

if[system"t";
  .z.ts:{
    pub'[t; value each t];
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
    pub[t; $[0>type first x; enlist f!x; flip f!x]];
    if[l; l enlist (`upd; t; x); i+:1]; }];

\d .
.u.tick[.z.x 0];

/
Globals
 .u.w - dictionary of tables->(handle;syms)
 .u.i - msg count in log file
 .u.j - total msg count (log file plus those held in buffer)
 .u.t - table names
 .u.L - tp log filename, e.g. `:./2008.09.11
 .u.l - handle to tp log file
 .u.d - date
