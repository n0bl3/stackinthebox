# -*- mode: ruby -*-
# vi: set ft=ruby :
#
VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  # Ubuntu 12.04 with openstack-all-in-one installed via devstack
  # and sources exported through smb
  config.vm.define "openstack" do |openstack|
    openstack.vm.box = "openstack-all-in-one"
    openstack.vm.box_url = "http://files.vagrantup.com/precise64.box"
    openstack.vm.network :private_network, ip: "192.168.33.11"
    openstack.ssh.forward_agent = true
    openstack.vm.provider :virtualbox do |vb|
       vb.customize ["modifyvm", :id, "--memory", "4096"]
    end

    openstack.vm.provision :puppet do |puppet|
      puppet.module_path = "puppet/modules"
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "init.pp"
      puppet.options = "--verbose --debug"
    end
  end

  # Clean Ubuntu 12.04
  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "ubuntu-clean"
    ubuntu.vm.box_url = "http://files.vagrantup.com/precise64.box"
    ubuntu.vm.network :private_network, ip: "192.168.33.22"
    ubuntu.ssh.forward_agent = true
    #ubuntu.ssh.private_key_path = "C:/cygwin64/home/Roman/.ssh/id_rsa"
    #ubuntu.ssh.username = "Roman"
    #ubuntu.vm.synced_folder File.expand_path('~'), "/home/vagrant"
    ubuntu.vm.provider :virtualbox do |vb|
       vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    ubuntu.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "ubuntu_init.pp"
    end
  end
end
