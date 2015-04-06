# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  
  config.ssh.forward_agent = true

  config.vm.define "local", primary: true do |local|
  
    local.vm.box = "hashicorp/precise32"

    local.vm.network "forwarded_port", guest: 8000, host: 8000
    local.vm.network :private_network, ip: "192.168.63.30"

    local.vm.hostname = "comics.org"

    # local.vm.provision :shell, path: "bootstrap.sh"

    local.vm.provision "puppet" do |puppet|
      puppet.module_path = "puppet/modules"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file = "default.pp"
      # puppet.hiera_config_path = "./puppet/hiera.yaml"
      # puppet.working_directory = "/vagrant"
      # puppet.options = "--hiera_config=puppet/hiera.yaml --verbose --debug"
      puppet.options = "--verbose --debug"
    end

    # Configure Virtualbox settings
    local.vm.provider :virtualbox do |vm|
        #vm.gui = true
        vm.customize ["modifyvm", :id, "--cpus",   1]
        vm.customize ["modifyvm", :id, "--memory", 1024]
    end 
  end
end