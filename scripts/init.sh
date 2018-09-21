#!/bin/bash

function installVIM() {
   yum install -y vim 
   echo 'set number' > '/home/vagrant/.vimrc'
   echo 'syntax on' >> '/home/vagrant/.vimrc'
}

function installPerl() {
   yum install -y epel-release;
   yum install -y git;
   yum install -y wget
   yum install -y gcc autoconf libcurl-devel expat-devel
   yum install -y gettext-devel openssl-devel perl-devel 
   yum install -y zlib-devel xmlto util-linux docbook-utils
   yum install -y perl cpan perl-App-cpanminus
}

function installNGINX() {
	yum install -y wget
	useradd 'www-data'

	sh -c 'echo -e "[nginx]\nname=nginix repo\nbaseurl=http://nginx.org/packages/rhel/7/x86_64/\ngpgcheck=1\nenabled=1" > /etc/yum.repos.d/nginx.repo'

	wget https://nginx.org/keys/nginx_signing.key
	rpm --import nginx_signing.key

	yum clean all
	yum check-update -y
	yum install nginx -y
}
function configNGINX() {
	hostname=$1
	hostsfile=$2

	echo "Creating Host $hostname"
	hostsfile=/etc/hosts
	echo "127.0.0.1   $hostname" >> $hostsfile
	webroot=/vagrant/www
	echo "Creating Web Root $webroot"
	mkdir -p $webroot
	chown -R www-data:www-data $webroot
	chmod -R 755 $webroot
	chcon -R -h system_u:object_r:httpd_sys_content_t:s0 $webroot

	nginxconf=/etc/nginx/nginx.conf
	cat /vagrant/resources/nginx-perl.conf >$nginxconf

	#nginxsvc=/usr/lib/systemd/system/nginx.service
	#cat /vagrant/resources/nginx.service >$nginxsvc

	echo "Reloading Nginx"
	nginx -s reload
	chkconfig nginx on
	systemctl restart nginx
}
function installFastCGIWrap() {
    yum install -y epel-release
	yum install -y fcgi-devel spawn-fcgi
	yum install -y automake
	olddir=`pwd`
    mkdir -p /usr/local/downloads
    cd /usr/local/downloads
	git clone git://github.com/gnosek/fcgiwrap.git
	cd fcgiwrap
	autoreconf -i
	./configure
	make
	make install
	cd $olddir

	fcgiconf=/etc/sysconfig/spawn-fcgi
	cat /vagrant/resources/spawn-fcgi >$fcgiconf

	chkconfig --levels 235 spawn-fcgi on
	/etc/init.d/spawn-fcgi start
	
	cp /usr/local/downloads/fcgiwrap/systemd/fcgiwrap.socket /var/run/.
	chown www-data:www-data /var/run/fcgiwrap.socket
	chcon -h system_u:object_r:httpd_var_run_t:s0 /var/run/fcgiwrap.socket
	
	#fcgisvc=/usr/lib/systemd/system/fcgiwrap.service
	#cat /vagrant/resources/fcgiwrap.service >$fcgisvc

	#systemctl enable fcgiwrap
	#systemctl start fcgiwrap
}
function allowPasswordAuth() {
   # Configure Vagrant Security
   sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
   systemctl start sshd
}

#allowPasswordAuth
#installPerl
#installNGINX
installFastCGIWrap
configNGINX 'macrobox' '/etc/hosts'
#installVIM
