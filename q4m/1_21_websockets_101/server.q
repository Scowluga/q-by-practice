\p 5042

unixDate:{[dts] (prd 60 60 24)*dts-1970.01.01};

getHist:{[ticker; sdt; edt]
  tmpl:"https://query1.finance.yahoo.com/v7/finance/download/",
    "%tick?period1=%sdt&period2=%edt&interval=1d&events=history";
  args:enlist[ticker],string unixDate sdt,edt;
  url:ssr/[tmpl; ("%tick";"%sdt";"%edt"); args];
  raw:system "curl -s '",url,"'";                                   / make request to API using `curl`
  t:("DFFFFJF"; enlist ",") 0: raw;                                 / parse comma-separated records into q table
  `Date xasc `Date`Open`High`Low`Close`Volume`AdjClose xcol t }     / name columns and sort by date

getData:{[ticker; sdt]                                              / get all data for a ticker from a start date to now
  edt:.z.D;                                                         / .z.D gives current local date
  select Date,Close from getHist[ticker; "D"$sdt; edt] }            / select columns from symbol history

.z.ws:{                                                             / override websocket handler
  args:(-9!x) `payload;                                             / parse args
  res:.[getData; args; `err];                                       / protected eval to retrieve data
  neg[.z.w] -8!(enlist `hist)!enlist res }                          / async response to client
