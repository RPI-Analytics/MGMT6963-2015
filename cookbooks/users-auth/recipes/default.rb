#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2013,  
#
#

include_recipe "ssh-auth"

node[:users][:add].each do |username, props|

	user_uid = props[:uid].nil? ? node[:users][:default][:uid] : props[:uid]
	password_hash = props[:password_hash].nil? ? node[:users][:default][:password_hash] : props[:password_hash]

	user username do
		supports :manage_home => true
		comment  "Adding #{username} User"
		uid      user_uid if node[:users][:uid] != "default"
		home     "/home/#{username}"
		shell    "/bin/bash"
		password password_hash
	end

	groups = props[:groups].nil? ? node[:users][:default][:groups] : props[:groups]
	
	groups.each do |user_group|
		group user_group do
			# we are using :create instead of :modify as we are running this before installing, made sure that this doesn't cause any problems in doing so
			action :create
			members username
			append true
		end
	end

	ssh_keys = props[:ssh_keys].nil? ? node[:users][:default][:ssh_keys] : props[:ssh_keys]

	ssh_key username do
		action "add"
		ssh_keys ssh_keys
	end
end



