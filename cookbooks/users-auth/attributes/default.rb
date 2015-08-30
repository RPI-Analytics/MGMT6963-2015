#
# Cookbook Name:: users
# Attributes :: default
#
# Copyright 2013,  
#


# user specific properties

# default[:users][:add] = {
# 	"testuser" => {
# 		"password_hash" => "$1$Jox0H8kd$JTKPiEEKpBs3E9S0",
# 		"groups" => ["apache", "tomcat"],
# 		"ssh_keys" => ["ssh-rsa AAAAB3NzaC1yc2EAAAABIw"]
# 	}
# }

# Why uid ?
# ===> We set this userid only to make sure it will be able to access its home directory in shared servers

# How to get "password_hash"
# Get the hash manually if required through the command
# "openssl passwd -1 'theplaintextpassword' 
# (or) 
# use the utility "UsersHelper.get_passwd_hash('theplaintextpassword')""



# if user specific properties are not specified default ones are used

default[:users][:default][:uid] = 'default'
default[:users][:default][:password_hash] = UsersHelper.get_passwd_hash("blabla")
default[:users][:default][:groups] = []
default[:users][:default][:ssh_keys] = []