#!/bin/bash

ip=192.168.4.
read -p "管理服务器ip: " Manage
#ssh $Manage " masterha_check_status --conf=/etc/mha/app1.cnf " 
#A=$( ssh $Manage "echo $?")
#[ $A -ne 0   ] &&  echo "管理服务器状态异常" exit 1 

ssh $Manage ' masterha_check_repl --conf=/etc/mha/app1.cnf ' > /root/health.txt
B=$(grep -i health /root/health.txt | awk '{print $5}')
[ $B  != "ok."  ]  || echo "MHA出错" exit 1

#IpM=$(ssh $ip$Manage  "masterha_check_status --conf=/etc/mha/app1.cnf" | awk -F'.' '{print $4}')
IPa(){
for i in 51 52 53
do  
 ip1=$( ssh 192.168.4.$i "ifconfig eth0:1 " | awk  '  /(inet)/{print $2}') &> /dev/null
[ -z $ip1  ] && continue
[ $ip1 == 192.168.4.100  ]  && echo $i  
break 
done
}
ZHip=`IPa`
    #主服务器ip
#ssh $ip$Manage "masterha_stop --conf=/etc/mha/app1.cnf" &> /dev/null

ssh $ip$ZHip  "mysql -uroot -p123123 -e 'show master status;'"  > /root/LOL/ppp.txt

ai=/root/LOL/ppp.txt
Bi=$(sed -n '2p' $ai  | awk '{print $1}')
Ci=$(sed -n '2p' $ai  | awk '{print $2}')
##########################################################################################
read -p "请输入需要加入主从的ip " Rip
RIP=$( echo $Rip | awk -F\. '{print $4 }'  )
ssh $Rip " ss -tunpl |grep 3306  "
[  $? == 0  ] && ssh $Rip "ystemctl start mysqld"

ssh $ip$RIP "systemctl restart mysqld" 

ssh $ip$RIP "if [ $? != 0 ];then 
		echo '服务重启失败'
		fi"
ssh $ip$ZHip "mysqldump -uroot -p123123 --master-data -A > /root/bf$ZHip.sql" 
ssh $ip$ZHip "scp /root/bf$ZHip.sql root@$Rip:/root" &> /dev/null

ssh $Rip "mysql -uroot -p123123  < /root/bf$ZHip.sql"  && echo "数据同步一致"
ssh $Rip "mysql -uroot -p123123 -e 'stop slave;'" &>/dev/null

scp /root/LOL/d.sh root@$Rip:/root/
ssh $Rip "echo $ip$ZHip > /root/zhip.txt"
#a=$(sed -n '22p' bf51.sql  | awk -F\' '{print $2}')
#b=$(sed -n '22p' bf51.sql  | awk -F= '{print $3}')
scp /root/zhip.txt root@$Rip:/root/
#ssh $Rip "mysql -uroot -p123123 -e ' change master to master_host='192.168.4.$RIP',master_user='repluser',master_password='123123',master_log_file='$2',master_log_pos=$b'"
ssh $Rip "bash /root/d.sh"
#


ssh $Rip "mysql -uroot -p123123 -e 'start slave;'" &>/dev/null

ssh $Rip  "mysql -uroot -p123123 -e 'show slave status\G; '" > /root/LOL/ooo 
scp /root/LOL/ooo root@$Rip:/root
oo=/root/LOL/ooo

Di=`grep  Slave_IO_Running $oo | awk ' {print $2}'`
Ei=`grep  Slave_SQL_Running  $oo | awk '{print $2}' | sed -n '1p'`
[ $Di == Yes ] && echo "IO线程正确" || echo "IO线程出错" 
[ $Ei != "Yes" ] && echo "SQL线程出错"  
#echo "加入主从完成"
echo "$Di"
echo "$Ei"
ssh $Manage 'echo '[server$RIP] ' >> /etc/mha/app1.cnf' &> /dev/null
ssh $Manage 'echo  'candidate_master=1' >> /etc/mha/app1.cnf' &> /dev/null
ssh $Manage 'echo 'hostname=$ip$RIP' >> /etc/mha/app1.cnf' &> /dev/null
ssh $Manage ' masterha_check_repl --conf=/etc/mha/app1.cnf ' > /root/health.txt
echo "结果出来了"
grep -i health /root/health.txt
