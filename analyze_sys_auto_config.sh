#!/bin/sh

#sar dir
PWD=`pwd`
SAR_DIR=$PWD/sar
mkdir $SAR_DIR
mkdir $SAR_DIR/data

#xinetd配置
sudo yum install -y xinetd
#配置相应的xinetd服务
sudo echo \
"service analyze_sys_start
{
    disable = no
    port  = 9999
    socket_type   = stream
    protocol    = tcp
    wait      = no
    user      = root
    server     = $SAR_DIR/analyze_sys_start.sh $SAR_DIR
    server_args   = test
}" > /etc/xinetd.d/analyze_sys_start
sudo echo \
"service analyze_sys_stop
{
    disable = no
    port  = 9998
    socket_type   = stream
    protocol    = tcp
    wait      = no
    user      = root
    server     = $SAR_DIR/analyze_sys_stop.sh $SAR_DIR
    server_args   = test
}" > /etc/xinetd.d/analyze_sys_stop
#配置services，注释并添加 $serviceName    $port/tcp
sudo vi /etc/services
sed -i 's?distinct        9999/tcp                # distinct?analyze_sys_start        9999/tcp?g'   /etc/services
sed -i 's?distinct        9999/udp                # distinct?#distinct        9999/udp                # distinct?g'   /etc/services
sed -i 's?distinct        9998/tcp                # distinct?analyze_sys_stop        9998/tcp?g'   /etc/services
sed -i 's?distinct        9998/udp                # distinct?#distinct        9998/udp                # distinct?g'   /etc/services
#重启xinetd服务
sudo systemctl restart xinetd.service

#安装sysstat
sudo yum install -y sysstat

#下载脚本
cd $SAR_DIR
wget https://github.com/BobWr/analyze_sys/blob/master/analyze_sys_start.sh
wget https://github.com/BobWr/analyze_sys/blob/master/analyze_sys_stop.sh
wget https://github.com/BobWr/analyze_sys/blob/master/get_gpu.sh

chmod +x analyze_sys_start.sh analyze_sys_stop.sh get_gpu.sh
