/ ----- Table Setup -----
mktrades:{[tickers; sz]                               / tickers: list of ticker symbols, sz: size/number of trades
  dt:2015.01.01+sz?31;                                / date (in January 2015)
  tm:sz?24:00:00.000;                                 / time
  sym:sz?tickers;                                     / ticker symbol
  qty:10*1+sz?1000;                                   / quantity of stock
  px:90.0+(sz?2001)%100;                              / price of stock
  t:([] dt; tm; sym; qty; px);                        / construct table
  t:`dt`tm xasc t;                                    / sort in ascending date and time
  t:update px:6*px from t where sym=`goog;            / scale stock prices by company
  t:update px:2*px from t where sym=`ibm;
  t }

trade:mktrades[`aapl`goog`ibm; 1000000]               / random trade data
(`:db/trade/) set .Q.en[`:db; trade]                  / splay table to local db folder using .Q.en for sym enum

/ ----- Server -----
\l db                                                 / load db into `trade` variable
\p 5042                                               / open port

extract:{[cs; dtrng]                                  / query to retrieve trade data for columns within date range
  ?[trade; enlist (within; `dt; dtrng); 0b; cs!cs] }  / functional form query

.z.pg:{                                               / override sync handler to only accept safe remote calls
  $[-11h=type first x;                                / -11h corresponds to remote function calls (-10h is direct eval)
    .[value first x; 1_x; ::];                        / protected evaluation (trap); `::` forwards exception
    `unsupported] }

/ ----- Client -----
h:hopen `::5042                                       / connect to server at localhost (default) port 5042
h (`extract; `dt`tm`sym`qty`px; 2015.01.01 2015.01.02)
