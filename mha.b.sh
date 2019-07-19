#!/bin/bash
c=$( awk -F. '{print $4}' /root/zhip.txt )


a=$(sed -n '22p' /root/bf$c.sql  | awk -F\' '{print $2}')
b=$(sed -n '22p' /root/bf$c.sql  | awk -F= '{print $3}')

mysql -uroot -p123123 -e "change master to master_host='192.168.4.$c',master_user='repluser',master_password='123123',master_log_file='$a',master_log_pos=$b "
