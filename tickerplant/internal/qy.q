/ Support exposing internal tables for querying
/ Querying is accomplished via callbacks
/ Technically .qy.query is also reachable via direct async ipc call, but the result is then discarded

\l internal/cb.q
.ipc.expose `.qy.query;

.qy.query:{[args]
  if[not first[args] in .ipc.i.es; 'invalid];   / table must be exposed (we reuse .ipc.i.es to expose tables for query)
  if[not count[args] within 3 6; 'invalid];     / validate number of args
  .[?; args] }                                  / functional form select or exec query

/
e.x.
server:
  .ipc.expose `trade
client:
  .cb.send[h; `.qy.query; (`trade; (); 0b; ()); show]
