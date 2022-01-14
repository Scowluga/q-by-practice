/ Simple clients

\l internal/ps.q

x:.z.x 0                  / client type
s:`;                   	  / default all symbols
d:`GOOG`IBM`MSFT          / symbol selection
t:`trade`quote            / default tables

/ high low close volume
if[x~"hlcv";
 t:`trade;
 hlcv:([sym:()]high:();low:();price:();size:());
 upd:{[t;x]hlcv::select max high,min low,last price,sum size by sym
  from(0!hlcv),select sym,high:price,low:price,price,size from x}]

/ last
if[x~"last";
 upd:{[t;x].[t;();,;select by sym from x]}]

/ show only
if[x~"show";
 tabcount:()!();
 / count the incoming updates
 upd:{[t;x] tabcount+::(enlist t)!enlist count x};
 / show the dictionary every t milliseconds
 .z.ts:{if[0<count tabcount; 
	 -1"current total received record counts at time ",string .z.T;
	 show tabcount;
	 -1"";]};
 if[0=system"t"; system"t 5000"]]

/ all trades with then current quote
if[x~"tq";
 upd:{[t;x]$[t~`trade;
  @[{tq,:x lj q};x;""];
  q,:select by sym from x]}]

if[x~"vwap";t:`trade;
 upd:{[t;x]vwap+:select size wsum price,sum size by sym from x}]

.ps.sub[`tick; 5010; upd];
