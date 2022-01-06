\p 5042                       / open port

.z.ws:{                       / override web socket message handler
  0N!-9!x; neg[.z.w] -8!42 }  / show to console; return 42 as the answer to life (async response)
