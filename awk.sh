#!/bin/bash
while :
do
    uptime  | awk '{print "CPU平均负载: "$11,$12,$13}'
    ifconfig eth0 | awk -F[\(\)] '/TX p/{print "网卡发送的数据量: "$2}'
    ifconfig eth0 | awk -F[\(\)] '/RX p/{print "网卡接收的数据量: "$2}'
    free -m | awk '/Mem/{print "主机剩余内存: "$4 "M"}'
    df -h | awk '/\/$/{print "磁盘剩余内存: "$4}'
    u=`cat /etc/passwd  | wc -l `
    echo "计算机账户数量: $u"
    user=`who | wc -l `
    echo "计算机登录用户有: $user"
    p=`ps -aux | wc -l`
    echo "当前开启的进程数 : $p"
    rpm=`rpm -qa | wc -l `
    echo "当前已安装的软件包数量: $rpm"
    sleep 3
    clear
done 
