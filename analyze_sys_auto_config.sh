#!/bin/sh

#sar dir
PWD=`pwd`
SAR_DIR=$PWD/sar
mkdir $SAR_DIR
mkdir $SAR_DIR/data

#xinetd配置
sudo yum install -y xinetd
#安装sysstat
sudo yum install -y sysstat

#配置相应的xinetd服务
cd /etc/xinetd.d/
sudo wget https://raw.githubusercontent.com/BobWr/analyze_sys/master/analyze_sys_start
sudo wget https://raw.githubusercontent.com/BobWr/analyze_sys/master/analyze_sys_stop

sudo sed -i "s?bjk?$SAR_DIR?g" analyze_sys_start
sudo sed -i "s?bjk?$SAR_DIR?g" analyze_sys_stop

#配置services，注释并添加 $serviceName    $port/tcp
if [ -f /etc/services.bak.bjk ]
then
  sudo rm -f /etc/services
  sudo cp /etc/services.bak.bjk /etc/services
else
  sudo cp /etc/services /etc/services.bak.bjk
fi

sudo sed -i 's?distinct        9999/tcp                # distinct?analyze_sys_start        9999/tcp?g'   /etc/services
sudo sed -i 's?distinct        9999/udp                # distinct?#distinct        9999/udp                # distinct?g'   /etc/services
sudo sed -i 's?distinct32      9998/tcp                # Distinct32?analyze_sys_stop        9998/tcp?g'   /etc/services
sudo sed -i 's?distinct32      9998/udp                # Distinct32?#distinct32      9998/udp                # Distinct32?g'   /etc/services
#重启xinetd服务
sudo systemctl stop xinetd.service
sudo systemctl start xinetd.service

#下载脚本
cd $SAR_DIR
wget https://raw.githubusercontent.com/BobWr/analyze_sys/master/analyze_sys_start.sh
wget https://raw.githubusercontent.com/BobWr/analyze_sys/master/analyze_sys_stop.sh
wget https://raw.githubusercontent.com/BobWr/analyze_sys/master/get_gpu.sh

chmod +x analyze_sys_start.sh analyze_sys_stop.sh get_gpu.sh
