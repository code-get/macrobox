# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.hostname = "macrobox"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  config.vm.provision "shell", path: "scripts/init.sh"
end
