/ A simple tickerplant
/ Usage: q tick.q [LOG_FILE_DST]

\l schema.q
\l internal/ps.q

upd:{[t; x]
  ce["d"$.z.P];                         / check for day end

  if[-16<>type first first x;           / if no time has been provided in the feed
    c:"n"$.z.P;                         / current timespan
    x:$[0>type first x;                 / if x is single element
      c,x;                              / prepend current timespan
      enlist[(count first x)#c],x]];    / insert a row of the current timespan
    
  cs:key flip value t;                  / list of columns
  tb:$[0>type first x;                  / transform the feed data into a table
    enlist cs!x; 
    flip cs!x];
  
  .ps.pub[t; (t; tb)];                  / publish table
  if[l; l enlist (`upd; t; x); i+:1]; } / write to logs

il:{[dst]                               / init logs
  L::`$":",dst,"/",string .z.D;         / log filename, e.g. `:./2008.09.11
  if[not type key L;                    / if directories/files do not exist
    .[L; (); :; ()]];                   / "touch" to create
  j::-11!(-2; L);                       / total msg count (log file plus those held in buffer)
  i::j;                                 / msg count in log file
  l::hopen L; }                         / open handle to log file

init:{[port]                            / tells the ticker to initialize and subscribe to a feed
  system"t 1000";                       / start end of day timer
  d::.z.D;                              / current date
  @[; `sym; `g#]each tables[`.];        / make `sym column hashed for both tables
  if[count .z.x 0; il[.z.x 0]];         / log directory is specified: initialize logs
  .ps.sub[`feed; port; upd]; }          / subscribe to feed

/ End of day ===========================================================================================================

end:{
  .ps.unsub[`feed];                     / unsub from feed
  .ps.pub[`end; d];                     / publish end of day signal
  system"t 0";                          / stop checking for end of day
  d+:1;                                 / move to next day
  if[l; hclose l; l::0(`il; d)]; }      / clean up log file

ce:{[cur]                               / check for end of day
  if[d<cur;
    if[d<cur-1; '"day missing"];
    end[]]; }

.z.ts:{ce[.z.D];}                       / when tickerplant is active, check every second for end of day
