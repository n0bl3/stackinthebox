# -*- mode: ruby -*-
# vi: set ft=ruby :
#
VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  # Ubuntu 12.04 with openstack-all-in-one installed via devstack
  # and sources exported through smb
  config.vm.define "openstack" do |openstack|
    openstack.vm.box = "openstack"
    openstack.vm.hostname = "openstack"
    openstack.vm.box_url = "http://files.vagrantup.com/precise64.box"
    openstack.vm.network :private_network, ip: "192.168.33.11"
    # openstack.vm.network "public_network", :bridge => 'eth1'
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

  # Gearbox dev center
  config.vm.define "gearbox" do |gearbox|
    gearbox.vm.box = "gearbox"
    gearbox.vm.hostname = "gearbox"
    gearbox.vm.box_url = "http://files.vagrantup.com/precise64.box"
    gearbox.vm.network "public_network", :bridge => 'eth1'
    gearbox.ssh.forward_agent = true
    gearbox.vm.synced_folder "/home/rverchikov/workspace", "/synced/workspace"
    gearbox.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
    gearbox.vm.provision :puppet do |puppet|
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "gearbox.pp"
    end
  end
  # centos
  config.vm.define "centos" do |centos|
    centos.vm.box = "centos"
    centos.vm.box_url = "http://rverchikov-pc/vagrant-boxes/centos.box"
    centos.vm.network :private_network, ip: "192.168.33.33"
    centos.ssh.forward_agent = true
    centos.vm.provider :virtualbox do |vb|
       vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end
end
