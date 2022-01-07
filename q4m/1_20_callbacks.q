/ ----- Sever -----
\p 5042

work:{system"sleep 3"; x+y }              / fake work method

.z.ps:{                                   / override async handler
  if[-11h<>type first x; :];              / only allow remote function calls
  if[count[x]< 2; :];                     / async calls must have >=2 args
  f:value x[0];                           / arg 1: function to call
  cb:x[1];                                / arg 2: callback to pass the result to
  args:2_x;                               / remaining args are function parameters
  res:.[f; args; ::];                     / protected evaluation
  neg[.z.w] (cb; res); }                  / async callback

/ ----- Client -----
h:hopen `::5042

echo:{show x}

neg[h] (`work; `echo; 10; 27)
