#!/bin/bash
# run rdb demo

P=~/q/q-by-practice/tickerplant/run1.sh

for f in ticker rdb hlcv last tq show vwap feed
do $P $f; done
