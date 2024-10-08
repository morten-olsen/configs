# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox"
  config.vm.box = "generic/fedora39"
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbooks/setup.yml"
  end
end
