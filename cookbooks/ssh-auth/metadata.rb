name             'ssh-auth'
maintainer       'phaninder [phaninder.com]'
maintainer_email 'pasupulaphani.gmail.com'
license          'Apache 2.0'
description      'Configures ssh'
long_description 'Configures ssh and provides some utils for auth keys'
version          '0.1.4'

unless defined?(Chef::Cookbook::Metadata)
	source_url       'https://bitbucket.org/ppasupula/chef-ssh-auth'
	issues_url       'https://bitbucket.org/ppasupula/chef-ssh-auth/issues'
end

supports 'ubuntu'
supports 'RHEL'
supports 'CentOs'

provides "ssh-auth::sshd"
provides "here(:ssh_key)"

recipe "ssh-auth::sshd", "Configures ssh server"
