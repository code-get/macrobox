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

pythondir='Python-3.7.0'

if [ ! -d "/usr/src/$pythondir" ]; then
   $olddir = `pwd`
   cd /usr/src
   wget https://www.python.org/ftp/python/3.7.0/Python-3.7.0.tgz
   tar -zxf Python-3.7.0.tgz
   cd Python-3.7.0
   ./configure
   make altinstall
   cd "$olddir"
fi

sleep 3

if [ ! $PATH = '*/usr/local/bin*' ]; then
   PATH="$PATH:/usr/local/bin"
fi

if [ ! -f '/usr/local/bin/pip3' ]; then
   ln -s /usr/local/bin/pip3.7 /usr/local/bin/pip3
fi 

if [ ! -f '/usr/local/bin/python3' ]; then
   ln -s /usr/local/bin/python3.7 /usr/local/bin/python3
fi

pip3 install --upgrade pip
pip3 install django

# Configure Vagrant Security
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

systemctl restart sshd