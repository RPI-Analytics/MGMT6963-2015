#
# Cookbook Name:: ssh
# Recipe:: sshd
#

directory node[:ssh][:authorized_keys_dir] do
	owner node[:ssh][:user]
	group node[:ssh][:group]
	mode 0755
	action :create
end




template "#{node[:ssh][:install_dir]}/sshd_config" do
	source "sshd_config.erb"
	owner node[:ssh][:user]
	group node[:ssh][:group]
	mode 00600
	notifies :restart, 'service[sshd]'
end


service "sshd" do
  supports :restart => true, :reload => true
  action :enable
end
