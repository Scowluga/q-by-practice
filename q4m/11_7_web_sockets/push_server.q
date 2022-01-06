\p 4242                                     / open port

answer:42;                                  / the answer to life

.z.wo:{                                     / override websocket open handler
  `requestor set x;                         / store `requestor callback handle
  system "t 1000";}                         / set/start timer interval to 1000ms (1s)

.z.ts:{                                     / timer
  neg[requestor] -8!answer;                 / send async message to requestor
  answer+:1;}                               / increment answer

.z.ws:{}                                    / needed to prevent WS exception
