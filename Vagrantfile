# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "hashicorp/precise32"
  config.vm.network "forwarded_port", guest: 8000, host: 8000
  config.vm.provision :shell, path: "bootstrap.sh"
end
