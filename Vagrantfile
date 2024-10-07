# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox"
  config.vm.box = "archlinux/archlinux"
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbooks/setup.yml"
  end
end
