/ For any process using IPC

.z.ps:{                               / async handler
  if[-11h<>type first x; :];          / only allow remote procedure calls
  .[value first x; 1 _ x; ::]; }      / trap evaluation

.z.pg:{`unsupported}                  / sync handler - no sync communication is allowed
