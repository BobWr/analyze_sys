#!/bin/sh

SAR_DIR=`pwd`
DATA_DIR=$SAR_DIR/data

touch $DATA_DIR/gpu.log

while :
do
  nvidia-smi |awk '{print $13}' | awk '{{printf"%s",$0}}' |awk '{print}' >> $DATA_DIR/gpu.log
  sleep 1
done
