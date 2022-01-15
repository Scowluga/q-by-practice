/ Manages IPC
/ By default any process is completely unreachable for IPC
/ Processes can "expose" certain functions to be reachable via remote procedure call

.ipc.i.es:`symbol$()                      / exposed functions

.ipc.expose:{[fs]                         / expose a list of functions
  .ipc.i.es,:fs; }

.z.ps:{                                   / async handler
  if[-11h<>type first x; 'unsup];         / only allow remote procedure calls
  if[not first[x] in .ipc.i.es; 'unsup];  / function must be exposed
  .[value first x; 1 _ x; ::]; }          / trap evaluation

.z.pg:{'unsup}                            / sync handler - no sync communication is allowed
