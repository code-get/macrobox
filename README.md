# MACROBox Development Environment
Copyright 2018 (c) MACROmantic
Written by: christopher landry <macromantic (at) outlook.com>
Version: 0.0.1
Date: 22-august-2018
License: GPLv3

This is the official Development workstation based on CentOS provided by a Vagrant box.

* See: [Chromium OS Developer Guide](https://chromium.googlesource.com/chromiumos/docs/+/master/developer_guide.md)

### Requirements
Vagrant 2.1.2
Fabric 1.14.0
VirtualBox 5.2.10

## Instructions

### Startup

```
$ vagrant up
```

### Connect to workstation

```
$ vagrant ssh
```

### Send Commands over Fabric

```
$ fab cmd:"cat /etc/redhat-release"
```

### Configure Macroweb Development Project

```
vagrant@macroweb:~$ git config --global user.name "c.landry"
vagrant@macroweb:~$ git config --global user.email "macromantic@outlook.com"
vagrant@macroweb:~$ git clone https://github.com/macromantic/macroweb.git
```

### Shutdown

```
$ vagrant halt
```

### To modify 
You can reprovision if you want to modify the configuration with
```
$ vagrant provision
```

### Version 0.0.1
- Initial check-in
- Build with centos/7 Vagrant box on virtualbox

