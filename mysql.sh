#!/bin/bash
G=`lsblk | awk '/vda1/{print $4}'`
if [ "$G" == "20G" ];then
     echo "已扩磁盘"
else
  LANG=en growpart /dev/vda 1 &> /dev/null
  xfs_growfs /dev/vda1 &> /dev/null
  echo "扩盘成功"
fi

rpm -q expect  &> /dev/null
if [ $? == 0 ];then
    echo "已安装"
else
    yum -y install expect
fi

expect <<EOF
spawn  scp  root@192.168.4.254:/linux-soft/03/mysql/mysql-5.7.17.tar /opt/ 
expect "password"
send "qgw123..\r"
expect eof
EOF

c d/opt
tar -xf mysql-5.7.17.tar
echo "正在安装MySQL服务"
yum -y install mysql-community-* &> /dev/null

echo "成功安装mysql"
echo "开启MySQL服务中"
systemctl start mysqld
systemctl enable mysqld

echo "MySQL已开启并设置开机自启"

PASS=`grep   " temporary password" /var/log/mysqld.log | awk '{print $11}'`
echo "初始密码为 : $PASS"
