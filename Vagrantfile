# -*- mode: ruby -*-
# vi: set ft=ruby :

# options are documented and commented below. For a complete reference,
# please see the online documentation at vagrantup.com.

# Every Vagrant development environment requires a box. You can search for
# boxes at https://vagrantcloud.com/search. Using Ubuntu 18.04
VM_BOX  =  "bento/ubuntu-18.04" 

Vagrant.configure(2) do |config|
  config.env.enable # enable the plugin
  config.vm.box = VM_BOX
  config.ssh.extra_args = ["-t", "cd /home/vagrant; bash --login"] #https://stackoverflow.com/questions/17864047/automatically-chdir-to-vagrant-directory-upon-vagrant-ssh
  config.vagrant.plugins = "vagrant-env"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096 
    vb.cpus = 4
  end
  config.vm.provision 'shell' do |s| 
     s.path = 'provisioner1.sh'
     s.env = { "SL_USERNAME"=>ENV['SL_USERNAME'], 
     "SL_API_KEY"=>ENV['SL_API_KEY'], 
     "ANSIBLE_INVENTORY_FILE"=>ENV['ANSIBLE_INVENTORY_FILE'], 
     "PRIVATEKEY"=>ENV['PRIVATEKEY'], 
     "PUBLICKEY"=>ENV['PUBLICKEY'], 
     "ANSIBLE_HOST_KEY_CHECKING"=>ENV['ANSIBLE_HOST_KEY_CHECKING'], 
     "PACKER_LOG"=>ENV['PACKER_LOG'], 
     "PACKER_LOG_PATH"=>ENV['PACKER_LOG_PATH'], 
     "OBJC_DISABLE_INITIALIZE_FORK_SAFETY"=>ENV['OBJC_DISABLE_INITIALIZE_FORK_SAFETY']}
  end

end