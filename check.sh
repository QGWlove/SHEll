#!/bin/bash
#检测LVS的　　健康检测功能
VIP=192.168.4.15:80
RIP1=192.168.4.100
RIP2=192.168.4.200

while :
do 
   for i in $RIP1 $RIP2
   do
	curl -s http://$i &> /dev/null
if [ $? -eq 0 ];then
	ipvsadm -Ln | grep -q $i || ipvsadm -a -t $VIP -r $i
else 
 	ipvsadm -Ln | grep -q $i && ipvsadm -a -t $VIP -r $i
fi
   done
sleep 1
done
