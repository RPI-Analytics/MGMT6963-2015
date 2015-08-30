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

# Starts the given Monit service.
actions :start

# Stops the given Monit service.
actions :stop

# Restarts the given Monit service.
actions :restart

# Does not do anything.
actions :nothing

default_action :nothing

# If this is specified and the service is not registered with Monit, it will be started as a
# regular service using the standard "service" resource.
attribute :fallback_to_regular_service, kind_of: [TrueClass, FalseClass], default: false

# A host:port combination of another service. If this is specified, we wait for this the given host
# to start listening on the given TCP port before attempting to start or restart the service. This
# could be used for handling dependencies on remote services.
attribute :wait_for_host_port, String
