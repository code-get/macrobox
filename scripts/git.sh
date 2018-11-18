#!/bin/bash

function installGit() {
   gitver=$1

   yum install -y gcc autoconf libcurl-devel expat-devel
   yum install -y gettext-devel openssl-devel perl-devel 
   yum install -y zlib-devel xmlto util-linux docbook-utils
   yum install -y asciidoc cpan perl-App-cpanminus

   cpanm Test::Simple
   cpanm Fatal
   cpanm XML::SAX

   #if [ ! -f '/usr/bin/git' ]; then
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
   #fi
}

installGit "2.18.0"
