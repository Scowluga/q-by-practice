/ A simple real-time database
/ - writes to hdb at end of day
/ - exposes funcitonal form queries via callbacks

\l schema.q
\l internal/ps.q
\l internal/qy.q

.ps.sub[`trade`quote; 5010; insert];              / insert tickerplant data into the corresponding table

.ipc.expose `trade`quote;

/ End of day ===========================================================================================================
/ At end of day, the rdb should save the day's data to the hdb, which is partitioned by date

store:{[t; d]
  pp:`$":hdb/",string[d],"/",string[t],"/";       / partition path
  pp set .Q.en[`:hdb;] value t; }

.ps.subu[`end; 5010; {[d]
  show "end of day";
  store[;d] each tables`.; }];
