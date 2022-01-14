/ Generates random data to feed into the tickerplant

\l internal/ps.q

sn:2 cut (                                      / symbol and name
  `AMD;"ADVANCED MICRO DEVICES";
  `AIG;"AMERICAN INTL GROUP INC";
  `AAPL;"APPLE INC COM STK";
  `DELL;"DELL INC";
  `DOW;"DOW CHEMICAL CO";
  `GOOG;"GOOGLE INC CLASS A";
  `HPQ;"HEWLETT-PACKARD CO";
  `INTC;"INTEL CORP";
  `IBM;"INTL BUSINESS MACHINES CORP";
  `MSFT;"MICROSOFT CORP")
s:first each sn                                 / symbol
n:last each sn                                  / name
p:33 27 84 12 20 72 36 51 42 29                 / price
m:" ABHILNORYZ"                                 / mode
c:" 89ABCEGJKLNOPRTWZ"                          / cond
e:"NONNONONNN"                                  / ex

cnt:count s
pi:acos -1
gen:{exp 0.001 * normalrand x}
normalrand:{(cos 2 * pi * x ? 1f) * sqrt neg 2 * log x ? 1f}
rnd:{0.01*floor 0.5+x*100}                      / rounding
vol:{10+`int$x?90}                              / x random volumes [10, 99]

value "\\S ",string "i"$0.8*.z.p%1000000000;    / randomize feed system
\S 235721                                       / set random seed

/ =====================================================================================================================
batch:{                                         / generate a batch of prices
  d:gen x;
  qx::x?cnt;                                    / index
  qb::rnd x?1.0;                                / margins
  qa::rnd x?1.0;
  n:where each qx=/:til cnt;
  s:p*prds each d n;
  qp::x#0.0;                                    / price
  (qp raze n):rnd raze s;
  p::last each s;
  qn::0 }                                       / position
/ gen feed for ticker plant

len:10000
batch len                                       / generate initial batch

maxn:15                                         / max trades per tick - every tick we send [1, maxn] trades 
qpt:5                                           / avg quotes per trade

/ =========================================================
t:{                                             / generates one tick with `x` trades
  if[not (qn+x)<count qx; batch len];           / renew batch if necessary
  i:qx n:qn+til x;
  qn+:x;
  (s i; qp n; `int$x?99; 1=x?20; x?c; e i) }

q:{                                             / generates one tick with `x` quotes
  if[not (qn+x)<count qx; batch len];           / renew batch if necessary
  i:qx n:qn+til x;
  p:qp n;
  qn+:x;
  (s i; p-qb n; p+qa n; vol x; vol x; x?m; e i) }

/ Bulk init system with data from "earlier today" before system start
feedm:{[time]
  $[rand 2;
    (`trade; (enlist a#time),t a:1+rand maxn);
    (`quote; (enlist a#time),q a:1+rand qpt*maxn)] }

initm:{
  o:"t"$9e5*floor (.z.T-3600000)%9e5;
  d:.z.T-o;
  len:floor d%113;
  rec:feedm each `timespan$o+asc len?d;
  .ps.pub[`feed;] each rec; }

/ Use timer to periodically feed "live" data to tickerplant
feed:{$[rand 2;
  (`trade; t 1+rand maxn);
  (`quote; q 1+rand qpt*maxn)] }

.z.ts:{.ps.pub[`feed; feed[]];}

/ Kickstart the system by telling the tickerplant to subscribe
.ps.postadd:{[t]
  initm[];
  system"t 507";
  show "feed started"; }

h:hopen `::5010
neg[h](`init; `feed; 5009);
