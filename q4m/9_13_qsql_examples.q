/ ----- Setup -----
mktrades:{[tickers; sz]                             / tickers: list of ticker symbols, sz: size/number of trades
  dt:2015.01.01+sz?31;                              / date (in January 2015)
  tm:sz?24:00:00.000;                               / time
  sym:sz?tickers;                                   / ticker symbol
  qty:10*1+sz?1000;                                 / quantity of stock
  px:90.0+(sz?2001)%100;                            / price of stock
  t:([] dt; tm; sym; qty; px);                      / construct table
  t:`dt`tm xasc t;                                  / sort in ascending date and time
  t:update px:6*px from t where sym=`goog;          / scale stock prices by company
  t:update px:2*px from t where sym=`ibm;
  t }[`aapl`goog`ibm; 10000000]

mkinstr:{
  instr:([sym:`symbol$()] name:`symbol$(); industry:`symbol$());
  instr:instr upsert (`ibm; `$"International Business Machines"; `$"Computer Services");
  instr:instr upsert (`msft; `$"Microsoft"; `$"Software");
  instr:instr upsert (`goog; `$"Google"; `$"Search");
  instr:instr upsert (`aapl; `$"Apple"; `$"Electronics");
  instr }

trades:mktrades[];                                  / table of trades
instr:mkinstr[];                                    / table of company information
update `instr$sym from `trades;                     / set symbol foreign key as enumeration over `instr 

/ ----- Basic Queries -----
/ Count trades
count trades;
count select from trades;
exec count i from trades;                           / aggregation, exec
select count i from trades;                         / aggregation, select

/ Count trades for symbol
select count i from trades where sym=`ibm;          / aggregation, where phrase

/ Count trades by symbol
select count i by sym from trades;                  / aggregation, grouping
() xkey select count i by sym from trades;          / `xkey` to make output unkeyed table

/ Find trades for symbol, on one day
select from trades where dt=2015.01.15, sym=`aapl;  / where phrase, with dt filter first for performance

/ Find trades for symbol, during lunch
select from trades where sym=`goog, tm within 12:00:00 13:00:00;  / where phrase using `within`

/ Maximum daily price for symbol 
select maxpx:max px by dt from trades where sym=`aapl;            / aggregation (max), grouping (by dt), where sym

/ Min and max trade price for each symbol, displayed by company name
select hi:max px, lo:min px by sym.name from trades;              / aggregation, implicit left outer join grouping

/ Total and average trade volume by symbols
select total:sum qty, average:avg qty by sym from trades;         / aggregation (sum, avg), grouping (by sym)

/ High, low, open, close over one-minute intervals for symbol
/ Grouping by `tm.minute`, aggregation (max, min), and use of `first` and `last` (grouping and filtering is stable)
select hi:max px, lo:min px, open:first px, close:last px by dt, tm.minute from trades where sym=`goog;

/ Using custom aggregation function 
favg:{(sum x*1+til ctx)%ctx*ctx:count x}
select favgpx:favg px by sym from trades;

/ ----- Meaty Queries -----

