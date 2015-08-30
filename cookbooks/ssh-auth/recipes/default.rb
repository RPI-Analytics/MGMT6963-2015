#
# Cookbook Name:: ssh
# Recipe:: default
#

# Install ssh
# action : donothing ;By default ssh is installed 

include_recipe "ssh-auth::sshd"

