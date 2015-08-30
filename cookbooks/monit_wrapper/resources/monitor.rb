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


# Creates a Monit service configuration file
actions :create

# Deletes a Monit service configuration file
actions :delete

default_action :create

# Specifies the pid_file parameter of our default Monit service configuration template.
attribute :pid_file, kind_of: String

# Specifies the pattern parameter (the command line regular expression) of our default Monit service
# configuration template.
attribute :pattern, kind_of: String

# If this is specified, the command line regular expression is constructed automatically that
# matches Java processes running the given class.
attribute :java_class, kind_of: String

# Additional variables to be used with the Monit service configuration template.
attribute :variables, kind_of: Hash

# The source file of the Monit configuration template. A default template is provided by this
# cookbook.
attribute :template_source, kind_of: String

# The cookbook to look for the Monit configuration template in.
attribute :template_cookbook, kind_of: String

# Wait for the given host:port combination to become available over TCP before proceeding with
# Monit service configuration file creation.
attribute :wait_for_host_port, String
