# MACROBox Development Environment
Copyright 2018 (c) MACROmantic
Written by: christopher landry <macromantic (at) outlook.com>
Version: 1.0.0
Date: 22-august-2018
License: GPLv3

This is the official Macromantic Development workstation based on CentOS provided by a Vagrant box.

### Requirements (Host)
Vagrant 2.1.2
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
