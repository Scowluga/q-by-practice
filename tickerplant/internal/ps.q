/ Adds simplified pub/sub functionality via q IPC

.z.ps:{                           / async handler
  if[-11h<>type first x; :];      / only allow remote procedure calls
  .[value first x; 1 _ x; ::];}   / trap evaluation

.z.pg:{`unsupported}              / sync handler - no sync communication is allowed

/ Publishing ===========================================================================================================

.ps.w:(`symbol$())!()             / topic symbol -> list of subscriber handlers

.ps.pub:{[topic; data]            / publish data to a topic
  {[h; t; d]                      / send async message
    neg[h](`.ps.push; t; d);}[; topic; data] each .ps.w[topic];}

.z.pc:{[h]                        / connection close handler
  .ps.w:except[;h] each .ps.w;}   / remove active subscriptions of closing handle

.ps.add:{[topic]                  / subscribe caller to topic
  .ps.w[topic],:.z.w;}

/ Subscribing ==========================================================================================================

.ps.rec:(`symbol$())!()           / subscription receiver functions; each will be 

.ps.push:{[topic; data]           / used by a publisher to push data
  .ps.rec[topic][data];}          / apply

.ps.sub:{[topic; port; rec]       / subscribe to a single topic with a receiver function
  h:hopen `$"::",string port;     / connect to publisher
  neg[h](`.ps.add; topic);        / add self as subscriber
  .ps.rec[topic]:rec;}            / store receiver function

.ps.bufs:enlist[::]                                / contains internal buffers for zipping published messages
/ ts is a size n>=2 list of topic symbols
/ ps is a size n list of ports (corresponding to the topics)
/ rec is a multivariate function that takes in one input from each topic
.ps.zip:{[ts; ps; rec]
  if[count[ts]<>count[ps]; `length];
  if[count[ts]<2; `length];
  / we use `zid` as the uid for the zipped topic. Physically it is the index of our data in .ps.bufs
  zid:count .ps.bufs;
  / we store a dictionary where keys are the topic symbols, values are a general list of data that has arrived per topic
  .ps.bufs,:enlist ts!count[ts]#(::);
  / when data comes in per topic...
  zrec:{[t; data; zid; rec]
    .ps.bufs[zid; t]:.ps.bufs[zid; t],enlist data; / add data to the dict - NOTE: we have to use this terrible syntax to maintain general list? why...
    if[all 1<count each .ps.bufs[zid];    / all topics have at least 1 real data field
      rec . value .ps.bufs[zid;; 1];                / apply zipped inputs to receiver
      .ps.bufs[zid]:_[; 1] each .ps.bufs[zid];];}[;; zid; rec];    / delete 
  zsub:{[t; p; zrec]
    .ps.sub[t; p; zrec[t;]];}[;;zrec];
  ts zsub' ps;}   / we subscribe with each topic individually; we consider zip as a layer on top of 
