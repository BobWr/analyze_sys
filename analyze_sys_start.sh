#!/bin/bash

SAR_DIR=$1
DATA_DIR=$SAR_DIR/data
rm -rf $DATA_DIR/*

sar -u 1 > $DATA_DIR/cpu.log &
sar -n DEV 1 > $DATA_DIR/net.log &
sar -r 1 > $DATA_DIR/mem.log &
sar -b 1 > $DATA_DIR/io.log &
.$SAR_DIR/get_gpu.sh $DATA_DIR &

DATA="Analyze start."
length=${#DATA}
echo -en "HTTP/1.1 200 OK\r\n"
echo -en "Content-Type: text/plain\r\n" 
echo -en "Connection: close\r\n" 
echo -en "Content-Length: ${length}\r\n" 
echo -en "\r\n" 
echo -en "$DATA"
echo -en "\r\n" 
sleep 0.1
exit 0