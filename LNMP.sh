#!/bin/bash
conf=/usr/local/nginx/conf/nginx.conf
yum -y install gcc pcre-devel openssl-devel
tar -xf lnmp_soft.tar.gz
cd lnmp_soft
tar -xf nginx-1.12.2.tar.gz
cd nginx-1.12.2
./configure
make
make install
yum -y install mariadb mariadb-server mariadb-devel
yum -y install php php-fpm php-mysql

sed -i '65,71s/#//' $conf
sed -i '/SCRIPT_FILENAME/d' $conf
sed -i '/fastcgi_params/s/fastcgi_params/fastcgi.conf/' $conf

/usr/local/nginx/sbin/nginx
ln -s /usr/local/nginx/sbin/nginx   /usr/sbin/
systemctl start mariadb
systemctl enable mariadb
systemctl start php-fpm
systemctl enable php-fpm
