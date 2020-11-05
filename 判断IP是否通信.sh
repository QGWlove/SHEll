#!/bin/bash
for i in {1..254}
do 
   ping -c 4 -i 0.2 -W 1 192.168.16.$i   &> /dev/null 
  [ $? -eq 0  ] && echo "192.168.16.$i 可以拼通" || echo "192.168.16.$i 不通"
done





#!/bin/bash
myping(){
	ping-c1-W1 $1  &> /dev/null
	if [ $? == 0 ];then
	  echo "$1 is up "
	else
	  echo "$1 is down"
	fi
}
for i in {1..254}
do 
   myping 192.168.4.$i   &
done
wait
