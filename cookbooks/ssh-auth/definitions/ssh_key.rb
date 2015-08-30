#
# Cookbook Name:: ssh
# Definition:: ssh_key
#

define :ssh_key, :action => "add", :ssh_keys => [] do

	keys_file = File.join(node[:ssh][:authorized_keys_dir], params[:name])

	if params[:action] == "add"
		params[:ssh_keys].each do |ssh_key|

			if File.exists?(keys_file)
				break if !File.open(keys_file).read().index(ssh_key).nil?
			end

			ruby_block "Adding #{ssh_key} to #{keys_file}" do
				block do
					open(keys_file, 'a') do |f| 
						f.puts ssh_key 
					end
				end
				action :run 
			end

			file keys_file do
				owner params[:name]
				group params[:name]
				mode 0600
			end
		end
	end
end
