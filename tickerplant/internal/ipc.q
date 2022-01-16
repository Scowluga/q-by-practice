/ Manages IPC
/ By default any process is completely unreachable for IPC
/ Processes can "expose" certain functions to be reachable via remote procedure call

.ipc.i.es:`symbol$()                        / exposed functions
.ipc.expose:{[x] .ipc.i.es,:x;}

.ipc.i.v:{[x]                               / validate an ipc request
  if[-11h<>type first x; 'unsup];           / only allow remote procedure calls
  if[not first[x] in .ipc.i.es; 'unsup]; }  / function must be exposed by server

.ipc.i.e:{[x]                               / trapped evaluation of ipc call
  .[value first x; 1 _ x; ::] }

.z.ps:{                                     / async handler
  .ipc.i.v[x]; .ipc.i.e[x]; }               / validate then evaluate

.z.pg:{'unsup}                              / sync handler - no sync communication is allowed
