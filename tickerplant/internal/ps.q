/ Adds simplified pub/sub functionality using the .ps context
/ Client functions are located directly under .ps
/ Internal functions are located under .ps.i

.z.ps:{                               / async handler
  if[-11h<>type first x; :];          / only allow remote procedure calls
  .[value first x; 1 _ x; ::]; }      / trap evaluation

.z.pg:{`unsupported}                  / sync handler - no sync communication is allowed

/ Publishing ===========================================================================================================
/ Processes can publish data to "topics" represented by unique symbols

.ps.i.w:(`symbol$())!()               / topic symbol -> list of subscriber handlers

.ps.i.del:{[t]                        / delete subscription
  .ps.i.w[t]:.ps.i.w[t] except .z.w; }

.z.pc:{[h]                            / connection close handler
  .ps.i.w:except[;h] each .ps.i.w; }  / remove all active subscriptions

.ps.pub:{[t; d]                       / publish data to topic; data is applied, so must be enlisted
  {[h; t; d]                          / send async message to each subscriber
    neg[h](`.ps.i.push; t; d);}[; t; d] each .ps.i.w[t]; }

.ps.i.add:{[t]                        / subscribe caller to topic
  .ps.i.w[t],:.z.w;                   / add to list of subscribers
  @[value; `.ps.postadd; ()][t]; }    / evaluate .ps.postadd if it exists

/ Subscribing ==========================================================================================================

.ps.i.rec:(`symbol$())!()             / subscription receiver functions (can only subscribe once to each topic)
.ps.h:(`symbol$())!`int$()            / topic -> open handle

.ps.i.push:{[t; d]                    / push data to subscriber
  .ps.i.rec[t][d]; }

.ps.unsub:{[t]                        / unsubscribe from single topic
  neg[.ps.h[t]](`.ps.i.del; t); 
  .ps.h _:t;
  .ps.i.rec _:t; }

.ps.i.sub:{[t; p; rec]                / subscribe to a single topic with a receiver function and operator
  h:hopen `$"::",string p;            / connect to publisher
  .ps.i.rec[t]:rec;                   / store receiver function
  .ps.h[t]:h;                         / store open handle for subsequent calls
  neg[h](`.ps.i.add; t); }            / add self as subscriber

.ps.sub:{[t; p; f]                    / default sub uses apply .           
  .ps.i.sub[t; p; .[f;]]; }

.ps.subu:{[t; p; f]                   / subu is for unary receiver functions, and uses apply at @
  .ps.i.sub[t; p; @[f;]]; }

/ The .ps context aims to support more complex pub/sub patterns
/ One such is a zipping of topics
/ When 2 or more topics are zipped, data sent is buffered until each topic has at least one record
/ One record per topic is then applied at once in FIFO order to the receiver function

.ps.i.bf:enlist[::]                               / .ps.i.bf contains buffers for zipped topics (:: for generality)

.ps.zip:{[ts; ps; rec]                            / zips topics to be applied together to rec
  if[count[ts]<>count[ps]; `length];              / ts (topic symbols) and ps (topic ports) must have equal size
  if[count[ts]<2; `length];

  zid:count .ps.bufs;                             / zid is a uid per zip, used in .ps.bufs as an index
  .ps.i.bf,:enlist ts!#[(count ts; 1); ::];       / the buffer itself is one FIFO list (with ::) per zipped topic

  zrec:{[t; d; zid; rec]                          / zipped topics share receiving functionality
    .ps.i.bf[zid; t],:enlist d;                   / add incoming data to the FIFO topic list
    if[all 1<count each .ps.i.bf[zid];            / if all topics have at least 1 real data field
      rec . value .ps.i.bf[zid;; 1];              / apply zipped inputs to receiver function
      .ps.i.bf[zid]:_[; 1] each .ps.i.bf[zid];];  / delete zipped inputs
    }[;; zid; rec];

  zsub:{[t; p; zrec]                              / subscribe each topic individually
    .ps.subu[t; p; zrec[t;]];}[;;zrec];
  ts zsub' ps; }

/ TODO: consider feature to pass parameters when subscribing to a topic
/   this was used to specify a subset of symbols in the original example