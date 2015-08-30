# Copyright 2015 ClearStory Data, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


if platform_family?('rhel') && node['monit']['install_method'] != 'source'
  Chef::Log.warn(
    "Setting node['monit']['install_method'] to 'source' on a RedHat-based system because " \
    "the monit_wrapper cookbook requires a Monit version of 5.2 or later to utilize the " \
    "'matching' feature. Please note that this won't help if the monit-ng default recipe " \
    "is included in the run list before the monit_wrapper recipe."
  )
  node.override['monit']['install_method'] = 'source'
  node.default['monit']['executable'] = '/usr/local/bin/monit'
else
  node.default['monit']['executable'] = '/usr/bin/monit'
end

include_recipe 'monit-ng'

# Ensure monit daemon is running. This may not happen on its own on Docker. We are not using the
# "service" resource, because service[monit] is also defined in monit-ng, and we do not want to
# interfere with that resource's execution here.
ruby_block 'monit_wrapper_start_monit_service' do
  block { ensure_monit_daemon_is_running }
end

chef_gem 'waitutil'

template '/usr/local/bin/start_stop_service_from_monit.sh' do
  source 'start_stop_service_from_monit.sh.erb'
  owner 'root'
  group 'root'
  mode '0744'
  variables timeout_sec: node['monit_wrapper']['start_stop_timeout_sec']
end

template '/usr/local/bin/monit_service_ctl.sh' do
  source 'monit_service_ctl.sh.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables monit_executable: node['monit']['executable']
end

# We use this directory for lock files to ensure that no more than one process is trying to
# start/stop a particular service from start_stop_service_from_monit.sh at any given moment.
directory '/var/monit' do
  owner' root'
  group 'root'
  mode '0777'
end
