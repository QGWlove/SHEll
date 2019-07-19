#!/bin/bash
le循环编写猜数脚本,猜对为止,并统计猜的次数
x=$[RANDOM%101]
c=0
while :
do
    read -p "请输入一个数字(0-100)" n
    let c++
    if [ $n -eq $x ];then
        echo "猜对了,猜了$c次"
        exit
    elif [ $n -gt $x ];then
        echo "猜大了"
    else
        echo "猜小了"
    fi
done
