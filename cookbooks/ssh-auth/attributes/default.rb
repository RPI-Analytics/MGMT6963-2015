#
# Cookbook Name:: ssh
# Attribute:: default
#

default[:ssh][:install_dir] = "/etc/ssh"
default[:ssh][:authorized_keys_dir] = File.join(node[:ssh][:install_dir], "authorized_keys")

# Should create a new property file with attributes for this permissions stuff later
default[:ssh][:user]  = "root"
default[:ssh][:group] = "root"
