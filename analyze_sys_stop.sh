#!/bin/bash

SAR_DIR=$1
DATA_DIR=$SAR_DIR/data

ps -ef |grep "sar -u 1" |grep -v "grep" |awk '{print $2}' |xargs -r kill -2
ps -ef |grep "sar -n DEV 1" |grep -v "grep" |awk '{print $2}' |xargs -r kill -2
ps -ef |grep "sar -r 1" |grep -v "grep" |awk '{print $2}' |xargs -r kill -2
ps -ef |grep "sar -b 1" |grep -v "grep" |awk '{print $2}' |xargs -r kill -2
ps -ef |grep "get_gpu.sh" |grep -v "grep" |awk '{print $2}' |xargs -r kill -9

# cat net.log | grep enp10s0f0 |grep -v Average |awk '{print $3,$4,$5,$6}'

# DATA=`cat net.log | grep enp10s0f0 |grep -v Average |awk '{print $3,$4,$5,$6}'`
# NET=`cat net.log | grep enp10s0f0 |grep -v Average |awk '{print $6}' |awk '{{printf"%s,",$0}}'`

#net info
NET_rxpck=`cat $DATA_DIR/net.log | grep enp10s0f0 |grep -v Average |awk '{print $4}' |awk '{{printf"%s,",$0}}'`
NET_txpck=`cat $DATA_DIR/net.log | grep enp10s0f0 |grep -v Average |awk '{print $5}' |awk '{{printf"%s,",$0}}'`
NET_rxkB=`cat $DATA_DIR/net.log | grep enp10s0f0 |grep -v Average |awk '{print $6}' |awk '{{printf"%s,",$0}}'`
NET_txkB=`cat $DATA_DIR/net.log | grep enp10s0f0 |grep -v Average |awk '{print $7}' |awk '{{printf"%s,",$0}}'`
NET_rxcmp=`cat $DATA_DIR/net.log | grep enp10s0f0 |grep -v Average |awk '{print $8}' |awk '{{printf"%s,",$0}}'`
NET_txcmp=`cat $DATA_DIR/net.log | grep enp10s0f0 |grep -v Average |awk '{print $9}' |awk '{{printf"%s,",$0}}'`

#CPU info
CPU_user=`cat $DATA_DIR/cpu.log |grep -v Average |awk 'NR>3{print $4}' |awk '{{printf"%s,",$0}}'`
CPU_nice=`cat $DATA_DIR/cpu.log |grep -v Average |awk 'NR>3{print $5}' |awk '{{printf"%s,",$0}}'`
CPU_system=`cat $DATA_DIR/cpu.log |grep -v Average |awk 'NR>3{print $6}' |awk '{{printf"%s,",$0}}'`
CPU_iowait=`cat $DATA_DIR/cpu.log |grep -v Average |awk 'NR>3{print $7}' |awk '{{printf"%s,",$0}}'`
CPU_steal=`cat $DATA_DIR/cpu.log |grep -v Average |awk 'NR>3{print $8}' |awk '{{printf"%s,",$0}}'`
CPU_idle=`cat $DATA_DIR/cpu.log |grep -v Average |awk 'NR>3{print $9}' |awk '{{printf"%s,",$0}}'`

#MEM info
MEM_kbmemfree=`cat $DATA_DIR/mem.log |grep -v Average |awk 'NR>3{print $3}' |awk '{{printf"%s,",$0}}'`
MEM_kbmemused=`cat $DATA_DIR/mem.log |grep -v Average |awk 'NR>3{print $4}' |awk '{{printf"%s,",$0}}'`
MEM_memused=`cat $DATA_DIR/mem.log |grep -v Average |awk 'NR>3{print $5}' |awk '{{printf"%s,",$0}}'`

#IO info
IO_tps=`cat $DATA_DIR/io.log |grep -v Average |awk 'NR>3{print $3}' |awk '{{printf"%s,",$0}}'`
IO_rtps=`cat $DATA_DIR/io.log |grep -v Average |awk 'NR>3{print $4}' |awk '{{printf"%s,",$0}}'`
IO_wtps=`cat $DATA_DIR/io.log |grep -v Average |awk 'NR>3{print $5}' |awk '{{printf"%s,",$0}}'`

#GPU info
GPU_use=`cat $DATA_DIR/gpu.log |awk '{split($0,a,"%");printf (a[1]+a[2]+a[3]+a[4]+a[5]+a[6]+a[7]+a[8])/8","}'`

DATA="{
    \"net\" : {
        \"rxpck_s\" : \"$NET_rxpck\",
        \"txpck_s\" : \"$NET_txpck\",
        \"rxkB_s\" : \"$NET_rxkB\",
        \"txkB_s\" : \"$NET_txkB\",
        \"rxcmp_s\" : \"$NET_rxcmp\",
        \"txcmp_s\" : \"$NET_txcmp\"
    },
    \"cpu\" : {
        \"user\" : \"$CPU_user\",
        \"nice\" : \"$CPU_nice\",
        \"system\" : \"$CPU_system\",
        \"iowait\" : \"$CPU_iowait\",
        \"steal\" : \"$CPU_steal\",
        \"idle\" : \"$CPU_idle\"
    },
    \"mem\" : {
        \"kbmemfree\" : \"$MEM_kbmemfree\",
        \"kbmemused\" : \"$MEM_kbmemused\",
        \"memused\" : \"$MEM_memused\"
    },
    \"io\" : {
        \"tps\" : \"$IO_tps\",
        \"rtps\" : \"$IO_rtps\",
        \"wtps\" : \"$IO_wtps\"
    },
    \"gpu\" : {
        \"use\" : \"$GPU_use\"
    }
}"
length=${#DATA}
echo -en "HTTP/1.1 200 OK\r\n"
echo -en "Content-Type: text/plain\r\n" 
echo -en "Connection: close\r\n" 
echo -en "Content-Length: ${length}\r\n" 
echo -en "\r\n" 
echo -en "$DATA"
echo -en "\r\n" 
sleep 1
exit 0
