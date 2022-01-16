/ A simple historical database
/ - partitioned by date
/ - written to at end of day by rdb
/ - exposes functional form queries via callbacks

\l schema.q
\l internal/qy.q
\l hdb

.ipc.expose `trade`quote;
