name             'users-auth'
maintainer       'phaninder [phaninder.com]'
maintainer_email 'pasupulaphani.gmail.com'
license          'Apache 2.0'
description      'Create users and set ssh auth keys'
long_description 'Create users and set ssh auth keys'
version          '0.1.0'

unless defined?(Chef::Cookbook::Metadata)
	source_url       'https://bitbucket.org/ppasupula/chef-users-auth'
	issues_url       'https://bitbucket.org/ppasupula/chef-users-auth/issues'
end

supports 'ubuntu'
supports 'RHEL'
supports 'CentOs'

depends "ssh-auth"
