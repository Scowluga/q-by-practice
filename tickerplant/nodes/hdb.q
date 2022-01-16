/ A simple historical database
/ - partitioned by date
/ - written to at end of day by rdb
/ - exposes functional form queries via callbacks

\l schema.q
\l internal/cb.q
\l hdb

.ipc.expose `qget`qset;

qget:{[args]
  if[not count[args] within 3 6; 'invalid];
  .[?; args] }

qset:{[args]
  if[4<>count args; 'invalid];
  .[!; args] }
