/ https://code.kx.com/q/wp/trend-indicators/

\l bitcoinKraken

/ SMA
sma:select date, sma2:mavg[2; close], sma5:mavg[5; close] from bitcoinKraken;

/ MACD, EMA
sp:{[days] 2%1+days}    / EMA smoothing parameter using smoothing factor of 2

macd:select date, fast:ema[sp[12]; close], slow:ema[sp[26]; close] from bitcoinKraken;
update macd:fast-slow from `macd;
update signal:ema[sp[9]; macd] from `macd;

d:1 _ exec date from macd;
s:1 _ signum exec signal-macd from macd;
buy:d where first[s] <': s;
sell:d where first[s] >': s;
