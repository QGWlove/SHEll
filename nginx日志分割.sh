#!/bin/bash
date=`date +%Y-%m-%d`
log=/usr/local/nginx/logs
mv $log/access.log  $log/access-$date.log
mv $log/error.log  $log/error-$date.log
kill USR1 $(cat $log/nginx.pid)
