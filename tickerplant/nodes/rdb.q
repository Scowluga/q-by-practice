/ A simple real-time database

\l schema.q
\l internal/ps.q

.ps.sub[; 5010; insert] each `trade`quote;        / insert tickerplant data into the corresponding table

/ End of day ===========================================================================================================
/ At end of day, the rdb should save the day's data to the hdb, which is partitioned by date

store:{[t; d]
  pp:`$":hdb/",string[d],"/",string[t],"/";       / partition path
  pp set .Q.en[`:hdb;] value t; }

.ps.subu[`end; 5010; {[d]
  show "end of day";
  store[;d] each tables`.; }];
