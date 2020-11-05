#/bin/bash
function system(){    #编写关于查看系统信息的函数
echo "#########################系统信息#########################"
OS_TYPE=`uname`  #定义变量OS_TYPE,存的信息是系统类型,``反引号代表的是执行uname命令的结果而不是字符串
#OS_VER=`cat /proc/version | awk '{print $9 , $10 ,$11}'`
OS_VER=`cat /etc/redhat-release`
OS_KER=`uname -a|awk '{print $3}'`  #awk '{print $3}代表过滤第三行的信息
OS_TIME=`date +%F_%T`
# awk -F, '{print $1}'代表以逗号切分的,第一行信息
OS_RUN_TIME=`uptime |awk '{print $3}'|awk -F, '{print $1}'`
OS_LAST_REBOOT_TIME=`who -b|awk '{print $2,$3}'`
OS_HOSTNAME=`hostname`

echo "    系统类型：$OS_TYPE"
echo "    系统版本：$OS_VER"
echo "    系统内核：$OS_KER"
echo "    当前时间：$OS_TIME"
echo "    运行时间：$OS_RUN_TIME"
echo "最后重启时间：$OS_LAST_REBOOT_TIME"
echo "    本机名称：$OS_HOSTNAME"
}
function network(){   #定义显示网络信息的函数

echo "#########################网络信息#########################"
#定义变量INTERNET存ifconfig命令包涵flags的行,并以:分隔的第一行内容,此内容是一列
INTERNET=(`ifconfig|grep "flags"|awk -F: '{print $1}'`)
#注意echo ${INTERNET[2]} ---代表显示过滤处理一列的第3个数的具体数据
#echo ${#INTERNET[*]} ---代表第显示过滤处理一列的中总共的行数是多少,*代表所有的
for((i=0;i<`echo ${#INTERNET[*]}`;i++))
do
#定义变量OS_IP存ifconfig命令中包涵${INTERNET[$i]}关键词的head -2前两行中的包含inet行的信息,并提取其中的第二个关键数
  OS_IP=`ifconfig ${INTERNET[$i]}|head -2|grep "inet "|awk  '{print $2}'`
#${INTERNET[$i]}关键词对应的ip地址OS_IP
  echo "          ${INTERNET[$i]}:$OS_IP"
done
curl -I http://www.baidu.com &>/dev/null
#如果curl -I http://www.baidu.com &>/dev/null能访问成功$?的值是0,不然则是其他的随机数字
if [ $? -eq 0 ]
then echo "    访问外网：成功"
else echo "    访问外网：失败"
fi
}

 

function hardware(){  #定义显示硬件信息的函数

echo "#########################硬件信息#########################"
#过滤出CPU的数量,以数据的大小排序,只显示唯一数字,并统计大概有多少行
CPUID=`grep "physical id" /proc/cpuinfo |sort|uniq|wc -l`
CPUCORES=`grep "cores" /proc/cpuinfo|sort|uniq|awk -F: '{print $2}'`
CPUMODE=`grep "model name" /proc/cpuinfo|sort|uniq|awk -F: '{print $2}'`

echo "     CPU数量: $CPUID"
echo "     CPU核心:$CPUCORES"
echo "     CPU型号:$CPUMODE"

MEMTOTAL=`free -h|grep Mem|awk '{print $2}'`
MEMFREE=`free -h|grep Mem|awk '{print $7}'`

echo "  内存总容量: ${MEMTOTAL}"
echo "剩余内存容量: ${MEMFREE}"

disksize=0
swapsize=`free |grep Swap|awk {'print $2'}`
#除去df -T命令的第一行并过滤掉包换tmpfs|sr0的行,所剩下的行打印出它的以空格分隔的第三行数据
#partitionsize=(`df -T|sed 1d|egrep -v "tmpfs|sr0"|awk {'print $3'}`)
partitionsize=(`df -T|sed 1d|egrep -v "tmpfs|sr0|aufs"|awk {'print $3'}`)
#将每块磁盘的大小相加
for ((i=0;i<`echo ${#partitionsize[*]}`;i++))
do
disksize=`expr $disksize + ${partitionsize[$i]}`
done
((disktotal=($disksize+$swapsize)/1024/1024))

echo "  磁盘总容量: ${disktotal}GB"

 

diskfree=0
swapfree=`free |grep Swap|awk '{print $4}'`
partitionfree=(`df -T|sed 1d|egrep -v "tmpfs|sr0|aufs"|awk '{print $5}'`)
#将可用的磁盘容量相加
for ((i=0;i<`echo ${#partitionfree[*]}`;i++))
do
diskfree=`expr $diskfree + ${partitionfree[$i]}`
done

((freetotal=($diskfree+$swapfree)/1024/1024))

echo "剩余磁盘容量：${freetotal}GB"
}


function secure(){
echo "#########################安全信息#########################"

countuser=(`last|grep "still logged in"|awk '{print $1}'|sort|uniq`)
for ((i=0;i<`echo ${#countuser[*]}`;i++))
do echo "当前登录用户：${countuser[$i]}"
done

md5sum -c --quiet /opt/passwd.db &>/dev/null
if [ $? -eq 0 ]
then echo "    用户异常：否"
else echo "    用户异常：是"
fi
}

function chksys(){
system
network
hardware
secure
}


chksys
