#!/bin/bash

yum update -y
yum install -y gcc gcc-c++ make 
yum install -y zlib-devel openssl-devel libffi-devel
yum install -y python2 python2-devel
yum install -y wget 

# Install vim
yum install -y vim 
echo 'set number' > "$HOME/.vimrc"
echo 'syntax on' >> "$HOME/.vimrc"

$olddir = `pwd`
cd /usr/src
wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
tar -zxf Python-3.7.0.tgz
cd Python-3.7.0
./configure
make altinstall
cd "$olddir"

# Configure Development Directory
ln -s /vagrant "$HOME/dev" 2>/dev/null

# Configure Vagrant Security
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

systemctl restart sshd