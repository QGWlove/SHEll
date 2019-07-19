#!/bin/bash
### 一键部署nosql服务，并且开始和初始化　查端口 
rpm -q expect

if [ $? == 0 ];then
  echo "已安装"
else
  yum -y install expect
fi

for i in {51..58}
do
scp /root/redis-4.0.8.tar.gz  root@192.168.4.$i:/root
ssh 192.168.4.$i "yum -y install gcc"
ssh 192.168.4.$i "tar -xf redis-4.0.8.tar.gz -C /root"
ssh 192.168.4.$i "cd /root/redis-4.0.8"
ssh 192.168.4.$i " cd redis-4.0.8; make  "
ssh 192.168.4.$i "cd redis-4.0.8; make install"

expect <<EOF
spawn    ssh 192.168.4.$i
expect  "#" {send "cd /root/redis-4.0.8/\r"}
expect  "8]#" {send "./utils/install_server.sh\r"} 
expect  "Please select the redis port for this instance: " {send "\r"}
expect  "Please select the redis config file name " {send "\r"}
expect  "Please select the redis log file name " {send "\r"}
expect  "Please select the data directory for this instance " {send "\r"}
expect  "Please select the redis executable path " {send "\r"}
expect  "Is this ok? Then press ENTER to go on or Ctrl-C to abort." {send "\r"}
expect  "#" {send "ss -nutpl | grep :6379 \r"}
expect  "#" {send "exit\r" }
expect  "#" {send "exit\r"}
EOF
done
