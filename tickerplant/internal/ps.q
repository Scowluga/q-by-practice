/ Adds simplified pub/sub functionality using the .ps context

.z.ps:{                               / async handler
  if[-11h<>type first x; :];          / only allow remote procedure calls
  .[value first x; 1 _ x; ::]; }      / trap evaluation

.z.pg:{`unsupported}                  / sync handler - no sync communication is allowed

/ Publishing ===========================================================================================================

.ps.w:(`symbol$())!()                 / topic symbol -> list of subscriber handlers

.ps.pub:{[t; d]                       / publish data to topic
  {[h; t; d]                          / send async message to each subscriber
    neg[h](`.ps.push; t; d);}[; t; d] each .ps.w[t]; }

.z.pc:{[h]                            / connection close handler
  .ps.w:except[;h] each .ps.w; }      / remove active subscriptions

.ps.add:{[t]                          / subscribe caller to topic
  .ps.w[t],:.z.w; }

/ Subscribing ==========================================================================================================

.ps.rec:(`symbol$())!()               / subscription receiver functions (can only subscribe once to each topic)

.ps.push:{[t; d]                      / push data to subscriber
  .ps.rec[t][d]; }

.ps.sub:{[topic; port; rec]           / subscribe to a single topic with a receiver function
  h:hopen `$"::",string port;         / connect to publisher
  neg[h](`.ps.add; topic);            / add self as subscriber
  .ps.rec[topic]:rec; }               / store receiver function

/ The .ps context aims to support more complex pub/sub patterns
/ One such is a zipping of topics
/ When 2 or more topics are zipped, data sent is buffered until each topic has at least one record
/ One record per topic is then applied at once in FIFO order to the receiver function

.ps.bufs:enlist[::]                   / .ps.bufs contains buffers for zipped topics (:: for generality)

.ps.zip:{[ts; ps; rec]                            / zips topics to be applied together to rec
  if[count[ts]<>count[ps]; `length];              / ts (topic symbols) and ps (topic ports) must have equal size
  if[count[ts]<2; `length];

  zid:count .ps.bufs;                             / zid is a uid per zip, used in .ps.bufs as an index
  .ps.bufs,:enlist ts!#[(count ts; 1); ::];       / the buffer itself is one FIFO list (with ::) per zipped topic

  zrec:{[t; d; zid; rec]                          / zipped topics share receiving functionality
    .ps.bufs[zid; t],:enlist d;                   / add incoming data to the FIFO topic list
    if[all 1<count each .ps.bufs[zid];            / if all topics have at least 1 real data field
      rec . value .ps.bufs[zid;; 1];              / apply zipped inputs to receiver function
      .ps.bufs[zid]:_[; 1] each .ps.bufs[zid];];  / delete zipped inputs
    }[;; zid; rec];

  zsub:{[t; p; zrec]                              / subscribe each topic individually
    .ps.sub[t; p; zrec[t;]];}[;;zrec];
  ts zsub' ps; }
