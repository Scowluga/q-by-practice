/ Adds a simplified callback system
/ To ensure a server's callback is valid, we generate and pass a token with every callback

\l internal/ipc.q
.ipc.expose `.cb.i.serve`.cb.i.res;

.cb.i.ts:(`long$())!()                      / token -> valid callback
.cb.i.gent:{`long$.z.P}                     / a trivial unique token generator

.cb.i.serve:{[tk; x]                        / serve a callback (must be explicitly exposed by server)
  .ipc.i.v[x];                              / validate call
  res:.ipc.i.e[x];                          / evaluate call
  neg[.z.w](`.cb.i.res; tk; res); }         / callback

.cb.i.res:{[tk; res]                        / receive a callback
  if[null cb:.cb.i.ts[tk]; 'invalid];       / validate token
  .cb.i.ts _:tk;                            / invalidate token
  cb[res]; }                                / evaluate callback

.cb.send:{[h; f; args; cb]                  / utility to send a callback
  tk:.cb.i.gent[];                          / associate callback with unique token for authorization
  .cb.i.ts[tk]:cb;
  neg[h](`.cb.i.serve; tk; (f; args)); }
