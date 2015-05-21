# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  
  config.ssh.forward_agent = true

  vagrant_path = "/vagrant"
  tools_path   = "#{vagrant_path}/tools"
  puppet_path  = "#{vagrant_path}/puppet"
  scripts_path = "#{tools_path}/scripts"
  modules_path = "#{puppet_path}/modules"

  config.vm.box = "hashicorp/precise32"

  # Use the latest puppet version
  config.vm.provision :shell, :inline => "#{scripts_path}/init-os.sh"

  config.vm.define "local", primary: true do |local|

    local.vm.hostname = "gcd-django-box"

    local.vm.network "forwarded_port", guest: 8000, host: 8000
    local.vm.network :private_network, ip: "192.168.63.30"

    # Provisioning the local env    
    local.vm.provision :shell, :inline => "#{scripts_path}/apply.sh"

    # Settings of the vm with Virtualbox as provider
    local.vm.provider :virtualbox do |vm|
        vm.customize ["modifyvm", :id, "--cpus",   2]
        vm.customize ["modifyvm", :id, "--memory", 2048]
    end 

    # Settings of the vm with VMWare Fusion as provider
    local.vm.provider :vmware do |vm|
        vm.customize ["modifyvm", :id, "--cpus",   2]
        vm.customize ["modifyvm", :id, "--memory", 2048]
    end 

    # Settings of the vm with Parallels Desktop as provider
    local.vm.provider "parallels" do |vm|
      vm.memory = 2048
      vm.cpus = 2
    end
  end
end