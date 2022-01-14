/ A simple real-time database

\l schema.q
\l internal/ps.q

.ps.sub[; 5010; insert] each `trade`quote;       / insert tickerplant data into the corresponding table

/ At end of day, rdb should save, clear, and send data to hdb
/ Something maybe have to cd to hdb so client save can run?
end:{[d]
  t:tables`.;
  t@:where `g=attr each t@\:`sym;
  .Q.hdpf[`$"::5012"; `:.; x; `sym];
  @[; `sym; `g#] each t; }

.ps.subu[`end; 5010; end];
