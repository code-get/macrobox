#!/bin/bash

setenforce 0

if [ -f '/etc/selinux/config' ]; then 
	sed -i -e 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
fi

yum update -y
yum groupinstall -y 'Development Tools'
yum install -y epel-release
yum install -y nginx
yum install -y fcgi-devel

# fcgiwrap
oldpwd=`pwd`
cd /usr/local/src
git clone git://github.com/gnosek/fcgiwrap.git
cd fcgiwrap
autoreconf -i
./configure
make
make install
cd $oldpwd

# spawn-fcgi
yum install -y spawn-fcgi
spawnfcgiconf=/etc/sysconfig/spawn-fcgi
cat /vagrant/resources/spawn-fcgi >$spawnfcgiconf
chkconfig --levels 235 spawn-fcgi on

# nginx config
nginxconf=/etc/nginx/nginx.conf
cat /vagrant/resources/nginx-perl.conf >$nginxconf

# www config
if ! [ -d '/var/www' ]; then
	mkdir /var/www
fi
cp /vagrant/www/index.pl /var/www/.
chmod -R 755 /var/www
chown -R nginx:nginx /var/www

if ! [ -d '/scripts' ]; then
	mkdir /scripts
fi
cp /vagrant/scripts/startup.sh /scripts/.
chmod 775 /scripts/startup.sh
echo "source /scripts/startup.sh" >~/.bashrc

