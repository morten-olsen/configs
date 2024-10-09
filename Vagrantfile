# -*- mode: ruby -*-
# vi: set ft=ruby :

$script = <<-SCRIPT
pacman -Syu --noconfirm python
SCRIPT


Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.cpus = 2
    libvirt.memory = 2048
  end
  config.vm.box = "archlinux/archlinux"
  config.vm.synced_folder "./", "/vagrant", type: "rsync"
  config.vm.provision "shell", inline: $script
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbooks/desktop.yml"
  end
end
