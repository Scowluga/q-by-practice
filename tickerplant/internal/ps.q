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

.ps.c:(`symbol$())!()             / connector information; currently just topic -> receiver function

.ps.push:{[topic; data]           / used by a publisher to push data; currently just forwards to the receiver function
  .ps.c[topic][data];}

.ps.sub:{[topic; port; rec]       / subscribe to a single topic with a receiver function
  h:hopen `$"::",string port;     / connect to publisher
  neg[h](`.ps.add; topic);        / add self as subscriber
  .ps.c[topic]:rec;}              / store receiver function



/
TODO: add zip functionality & more connectors
.ps.zip{}
Probably make .ps.c a table or something

In .ps.push make it so the behaviour depends on the topic subscription type
  sub - push immediately
  zip - wait until all values are in then go
  ...
\
