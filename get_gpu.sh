#!/bin/sh

script_abs=$(readlink -f "$0")
SAR_DIR=$(dirname $script_abs)
DATA_DIR=$SAR_DIR/data

touch $DATA_DIR/gpu.log

while :
do
  nvidia-smi |awk '{print $13}' | awk '{{printf"%s",$0}}' |awk '{print}' >> $DATA_DIR/gpu.log
  sleep 0.1
done