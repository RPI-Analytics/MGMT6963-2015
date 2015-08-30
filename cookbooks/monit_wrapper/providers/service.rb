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

include Chef::MonitWrapper::Wait
include Chef::MonitWrapper::StartStop

# Start the given Monit service.
action :start do  # ~FC017
  # We disable FC017 because notifying_action_wrapper takes care of notifications.
  service_name = new_resource.name
  notifying_action_wrapper do
    if monit_service_running?(service_name)
      Chef::Log.info("Service #{service_name} is already running, skipping start action")
    elsif monit_service_registered?(service_name)
      wait_for_host_port(new_resource.wait_for_host_port)
      unless monit_service_running?(service_name, verbose: true)
        start_monit_service(service_name)
      end
    elsif new_resource.fallback_to_regular_service
      wait_for_host_port(new_resource.wait_for_host_port)
      Chef::Log.info(
        "No Monit service #{service_name} registered, failling back to starting a regular service")
      service service_name do
        action :start
      end
    else
      raise "Monit does not know about #{service_name} and fallback_to_regular_service is disabled"
    end
  end
end

# Stop the given Monit service.
action :stop do  # ~FC017
  # We disable FC017 because notifying_action_wrapper takes care of notifications.
  service_name = new_resource.name
  notifying_action_wrapper do
    if monit_service_registered?(service_name)
      stop_monit_service(service_name)
    elsif new_resource.fallback_to_regular_service
      Chef::Log.info(
        "No Monit service #{service_name} registered, failling back to stopping a regular service")
      service service_name do
        action :stop
      end
    else
      raise "Monit does not know about #{service_name} and fallback_to_regular_service is disabled"
    end
  end
end

# Restart the given Monit service.
action :restart do  # ~FC017
  # We disable FC017 because notifying_action_wrapper takes care of notifications.
  if monit_service_running?(new_resource.name, verbose: true)
    command = 'restart'
  else
    command = 'start'
  end
  wait_for_host_port(new_resource.wait_for_host_port)
  notifying_action_wrapper do
    bash "monit-#{command}-#{new_resource.name}" do
      user 'root'
      code "#{node['monit']['executable']} #{command} #{new_resource.name}"
      action :run
    end
  end
end
