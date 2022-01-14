/ A simple real-time database

\l schema.q
\l internal/ps.q

/
TODO: figure out hdb and end of day functionality
/ end of day: save, clear, hdb reload
/ something about "cd to hdb(so client save can run)" - maybe have to cd to save somehow?
end:{
  t:tables`.;
  t@:where `g=attr each t@\:`sym;
  .Q.hdpf[`$"::5012"; `:.; x; `sym];
  @[; `sym; `g#] each t;}
\

.ps.sub[`tick; 5010; insert];       / insert tickerplant entries into the rdb
