# -*- mode: ruby -*-
# vi: set ft=ruby :

ipythonPort = 8001         # Ipython port to forward (also set in IPython notebook config)

Vagrant.configure(2) do |config|
  config.ssh.insert_key = true
  config.omnibus.chef_version = :latest
  config.vm.define "sparkvm" do |master|
    master.vm.box = "sparkmooc/base"
    master.vm.box_download_insecure = true
    master.omnibus.chef_version = :latest
    master.vm.boot_timeout = 900
    master.vm.hostname = "sparkvm"

# RStudio Server
    master.vm.network :forwarded_port, guest: 8787, host: 8787
    master.vm.network "forwarded_port", host: ipythonPort, guest: ipythonPort, auto_correct: true   # IPython port (set in notebook config)
    master.vm.network "forwarded_port", host: 4040, guest: 4040, auto_correct: true                 

# Spark UI (Driver)    
    master.vm.network "forwarded_port", guest: 27017, host: 27017 
    master.vm.network "forwarded_port", guest: 27018, host: 27018 
    master.vm.network "forwarded_port", guest: 27019, host: 27019
    master.vm.network "forwarded_port", guest: 28018, host: 28017 
    master.vm.network "forwarded_port", guest: 3306, host: 3306
    master.vm.network "forwarded_port", guest: 80, host: 8111

    
    
    master.vm.provision "chef_solo" do |chef| 
   chef.log_level = :debug
    chef.cookbooks_path = "cookbooks"
        chef.add_recipe "yum"
        chef.add_recipe "apt"
        chef.add_recipe "build-essential"
        chef.add_recipe "runit"     
        chef.add_recipe "python"
        chef.add_recipe "mongodb-10gen"
        chef.add_recipe "java"
        chef.add_recipe "git"
        chef.add_recipe "vim"
        chef.add_recipe "gdebi"
        chef.add_recipe "analyticsdojo"
   end
  end
end
