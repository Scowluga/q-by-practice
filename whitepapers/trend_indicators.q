/ https://code.kx.com/q/wp/trend-indicators/
/ We can obtain symbol data directly from exchanges then feed them into a tickerplant
/ The data-processing system can then output processed data
/ For which we now consider specifically the BTC_USD symbol on the KRAKEN exchange
\l bitcoinKraken

/ MACD, EMA
sp:{[days] 2%1+days}              / EMA smoothing parameter using smoothing factor of 2

macd_tb:select date, fast:ema[sp[12]; close], slow:ema[sp[26]; close] from bitcoinKraken;
update macd:fast-slow from `macd_tb;
update signal:ema[sp[9]; macd] from `macd_tb;

d:1 _ exec date from macd_tb;
s:1 _ signum exec signal-macd from macd_tb;
buy:d where first[s] <': s;       / use crossover to determine buy/sell signals
sell:d where first[s] >': s;

/ RSI, SMA
sma:select date, sma2:mavg[2; close], sma5:mavg[5; close] from bitcoinKraken;

rsi_tb:1 _ select date, delta:deltas close from bitcoinKraken;
update gain:mavg[14; delta|0], loss:neg mavg[14; delta&0] from `rsi_tb;
update rsi:100-100%1+gain%loss from `rsi_tb;

overbought:exec date from 14 _ rsi_tb where rsi>70;
oversold:exec date from 14 _ rsi_tb where rsi<30;

/ MFI
mfi_tb:1 _ select date, flow:vol*(deltas[high]+deltas[low]+deltas[close])%3 from bitcoinKraken;
update ratio:mavg[14; flow|0]%neg[mavg[14; flow&0]] from `mfi_tb;
update mfi:100-100%1+ratio from `mfi_tb;

vwob:exec date from 14 _ mfi_tb where mfi>80; / volume-weighted overbought
vwos:exec date from 14 _ mfi_tb where mfi<20; / volume-weighted oversold
