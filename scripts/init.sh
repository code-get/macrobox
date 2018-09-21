#!/bin/bash

function installVIM() {
   yum install -y vim 
   echo 'set number' > '/home/vagrant/.vimrc'
   echo 'syntax on' >> '/home/vagrant/.vimrc'
}

function installGit() {
   gitver=$1

   yum install -y wget
   yum install -y gcc autoconf libcurl-devel expat-devel
   yum install -y gettext-devel openssl-devel perl-devel 
   yum install -y zlib-devel xmlto util-linux docbook-utils
   yum install -y asciidoc cpan perl-App-cpanminus

   cpanm Test::Simple
   cpanm Fatal
   cpanm XML::SAX

   olddir=`pwd`
   mkdir -p /usr/local/downloads
   cd /usr/local/downloads
   wget "https://www.kernel.org/pub/software/scm/git/git-$gitver.tar.gz"
   tar -zxf "git-$gitver.tar.gz"
   cd "git-$gitver"
   make configure
   ./configure --prefix=/usr
   make all doc
   make install install-doc install-html
}

function installNGINX() {
	yum install -y wget

	sh -c 'echo -e "[nginx]\nname=nginix repo\nbaseurl=http://nginx.org/packages/rhel/7/x86_64/\ngpgcheck=1\nenabled=1" > /etc/yum.repos.d/nginx.repo'


	wget https://nginx.org/keys/nginx_signing.key
	rpm --import nginx_signing.key

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
	chown -R root:root $webroot
	chmod -R 755 $webroot

	indexfile="index.html"
	echo "Creating HTML index $indexfile"
	echo "<!DOCTYPE html><head><title>$hostname - sample</title></head><body><h1>Welcome to $hostname</h1></    body><html>" > "$webroot/$indexfile"
	chcon -R -h system_u:object_r:httpd_sys_content_t:s0 $webroot

	nginxconf=/etc/nginx/nginx.conf
	nginxconfsettings="http {\n    server {\n        server_name $hostname;\n        root $webroot/;\n        location /{\n            #\n        }\n    }\n"
	sed -i -e "s@http {@$nginxconfsettings@g" $nginxconf

	echo "Reloading Nginx"
	nginx -s reload
	chkconfig nginx on
	systemctl restart nginx
}

function allowPasswordAuth() {
   # Configure Vagrant Security
   sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
   systemctl start sshd
}

allowPasswordAuth
installNGINX
configNGINX 'macrobox' '/etc/hosts'
installVIM
