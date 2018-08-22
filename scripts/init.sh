#!/bin/bash

yum update -y

# Install vim
yum install -y vim 
echo 'set number' > "$HOME/.vimrc"
echo 'syntax on' >> "$HOME/.vimrc"

# Configure Development Directory
ln -s /vagrant "$HOME/dev" 2>/dev/null

# Configure Vagrant Security
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

systemctl restart sshd