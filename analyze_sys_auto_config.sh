#!/bin/sh

#sar dir
script_abs=$(readlink -f "$0")
PWD=$(dirname $script_abs)
SAR_DIR=$PWD/sar

rm -r $SAR_DIR
sleep 1
mkdir $SAR_DIR
mkdir $SAR_DIR/data

#安装sysstat
sudo yum install -y sysstat

#下载脚本
cd $SAR_DIR
wget https://raw.githubusercontent.com/BobWr/analyze_sys/golang/analyze_sys_start.sh
wget https://raw.githubusercontent.com/BobWr/analyze_sys/golang/analyze_sys_stop.sh
wget https://raw.githubusercontent.com/BobWr/analyze_sys/golang/get_gpu.sh
wget https://raw.githubusercontent.com/BobWr/analyze_sys/golang/analyze_sys

chmod +x analyze_sys_start.sh analyze_sys_stop.sh get_gpu.sh analyze_sys

ps -ef |grep "analyze_sys" |grep -v "grep" |grep -v "analyze_sys_auto" |awk '{print $2}' |xargs -r sudo kill -9

sleep 1

nohup ./analyze_sys &