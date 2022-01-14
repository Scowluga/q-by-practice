/ A simple tickerplant
/ Usage: q tick.q [LOG_FILE_DST]

\l schema.q
\l internal/ps.q

il:{[dst]                           / init logs
  L::`$":",dst,"/",string .z.D;     / L - tp log filename, e.g. `:./2008.09.11
  if[not type key L::`$(-10_string L),string d;
    .[L;();:;()]];
  j::-11!(-2; L);                   / j - total msg count (log file plus those held in buffer)
  i::j;                             / i - msg count in log file
  if[0<=type i;
    -2 (string L)," is a corrupt log. Truncate to length ",(string last i)," and restart";
    exit 1];
  l::hopen L; }                     / l - handle to log file

upd:{[t; x]
  ce"d"$a:.z.P;
  if[-16<>type first first x;
    a:"n"$a;
    x:$[0>type first x; a,x; (enlist(count first x)#a),x]];
  f:key flip value t;
  .ps.pub[t; (t; $[0>type first x; enlist f!x; flip f!x])]; / publish data
  if[l; l enlist (`upd; t; x); i+:1]; }                     / write to logs

init:{[topic; port]                 / tells the ticker to initialize and subscribe to a feed
  t::tables `.;                     / table names
  w::t!(count t)#();                / dictionary of tables->(handle;syms)
  system"t 1000";                   / start end of day timer
  d::.z.D;                          / current date
  if[not min(`time`sym~2#key flip value@)each t;
    '`timesym];
  @[; `sym; `g#]each t;
  if[count .z.x 0; il[.z.x 0]];     / log directory is specified - initialize logs
  .ps.sub[topic; port; upd]; }

/ End of day ===========================================================================================================

end:{
  .ps.pub[`end; d];                 / publish end of day signal
  system"t 0";                      / stop checking for end of day
  d+:1;                             / move to next day
  if[l; hclose l; l::0(`il; d)]; }  / clean up log file

ce:{[cur]                           / check for end of day
  if[d<cur;
    if[d<cur-1; '"day missing"];
    end[]]; }

.z.ts:{ce .z.D;}                    / when tickerplant is active, check every second for end of day
