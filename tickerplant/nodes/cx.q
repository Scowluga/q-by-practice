/ Simple clients

\l internal/ps.q

x:.z.x 0                  / client type

if[x~"hlcv";              / high low close volume
  hlcv:([sym:()] high:(); low:(); price:(); size:());
  .ps.sub[`trade; 5010; 
    {[t; x]
      hlcv::select max high, min low, last price, sum size by sym from(0!hlcv),
        select sym, high:price, low:price, price, size from x; }]]

if[x~"last";              / last entry
  .ps.sub[`trade`quote; 5010;
    {[t; x]
      .[t; (); ,; select by sym from x]; }]]

if[x~"tq";                / all trades with then current quote
  .ps.sub[`trade; 5010;
    {[t; x] @[{tq,:x lj q}; x; ""]; }];
  .ps.sub[`quote; 5010;
    {[t; x] q,:select by sym from x; }]]

if[x~"vwap";              / volume weighted average price
  partial:([sym:()] wp:(); size:());
  vwap:{select sym, vwap:wp%size, size from partial};
  .ps.sub[`trade; 5010; 
    {[t; x]
      partial+:select wp:size wsum price, sum size by sym from x; }]]

if[x~"show";              / show the number of incoming updates
  tabcount:()!();
  .z.ts:{                 / show the dictionary every t milliseconds
    if[0<count tabcount; 
      -1"current total received record counts at time ",string .z.T;
      show tabcount;
      -1"";] };
  system"t 5000";
  .ps.sub[`trade`quote; 5010;
    {[t; x]
      tabcount+::(enlist t)!enlist count x; }]]
