#
# Cookbook Name:: users
# Libraries :: users_helper
#
# Copyright 2013,  
#


module UsersHelper

	def self.get_passwd_hash( plain_text_password )
		pass_hash =	`openssl passwd -1 #{plain_text_password}`
	end

end