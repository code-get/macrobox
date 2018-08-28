#!/bin/bash

function installPython() {
    pyver=$1

    yum install -y gcc gcc-c++ make 
    yum install -y zlib-devel openssl-devel libffi-devel
    yum install -y sqlite-devel
    yum install -y python2 python2-devel
    yum install -y wget 

    pythondir="Python-$pyver"

    if [ ! -d "/usr/src/$pythondir" ]; then
        $olddir = `pwd`
        cd /usr/src
        wget "https://www.python.org/ftp/python/3.7.0/$pythondir.tgz"
        tar -zxf "$pythondir.tgz"
        cd "$pythondir"
        ./configure
        make altinstall
        cd "$olddir"
    fi

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
}

function installVIM() {
   yum install -y vim 
   echo 'set number' > "$HOME/.vimrc"
   echo 'syntax on' >> "$HOME/.vimrc"
}

function installGit() {
   gitver=$1
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

function allowPasswordAuth() {
   # Configure Vagrant Security
   sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
   systemctl restart sshd
}

yum update -y

allowPasswordAuth
installVIM
installPython "3.7.0"
installGit "2.16.2"
