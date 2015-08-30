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

# Notifies subscribing resources if the given Monit service is not running.
action :run do
  if monit_service_running?(new_resource.name, verbose: true)
    Chef::Log.info("Service #{new_resource.name} is running, not sending notification")
  else
    Chef::Log.info("Service #{new_resource.name} is not running, sending notification")
    new_resource.updated_by_last_action(true)
  end
end
