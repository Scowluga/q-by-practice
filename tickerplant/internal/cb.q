/ Adds a simplified callback system
/ To ensure a server's callback is valid, we generate and pass a token with every callback

\l internal/ipc.q
.ipc.expose `.cb.i.serve`.cb.i.res;

.cb.i.ts:(`long$())!()                      / token -> callback
.cb.i.gent:{`long$.z.P}                     / a trivial unique token generator

.cb.i.serve:{[tk; x]                        / serve a callback
  .ipc.i.v[x];                              / validate
  res:.ipc.i.e[x];                          / evaluate
  neg[.z.w](`.cb.i.res; tk; res); }         / callback

.cb.i.res:{[tk; res]                        / receive a callback
  if[null cb:.cb.i.ts[tk]; 'invalid];       / validate token
  .cb.i.ts _:tk;                            / invalidate token
  cb[res]; }                                / evaluate callback

.cb.send:{[h; f; args; cb]                  / send a callback
  tk:.cb.i.gent[];                          / associate callback with unique token for authorization
  .cb.i.ts[tk]:cb;
  neg[h](`.cb.i.serve; tk; (f; args)); }
