#!/bin/bash

terraver='0.11.8'
terraurl="https://releases.hashicorp.com/terraform/$terraver"
terrapkg="terraform_${terraver}_linux_amd64.zip"

if [ ! -d '/usr/local/downloads' ]; then
    mkdir -p /usr/local/downloads
fi

if [ ! -f '/usr/local/bin/terraform' ]; then
    olddir=`pwd`
    cd '/usr/local/downloads'
    curl -O "$terraurl/$terrapkg"
    unzip "./$terrapkg"
    mv terraform /usr/local/bin/.
    ln -s /usr/local/bin/terraform /usr/bin/terraform
    cd $olddir
fi

terraform --version
