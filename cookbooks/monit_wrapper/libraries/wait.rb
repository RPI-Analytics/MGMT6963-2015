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

class Chef
  module MonitWrapper
    # Tools for waiting for events to happen.
    module Wait
      # Wait for the given host to start listening on the given TCP port.
      # @param host_port [String] a `<host>:<port>` string.
      def wait_for_host_port(host_port)
        return if host_port.nil?

        unless host_port =~ /^[^:]+:\d+$/
          raise "Expected a host:port pair instead of '#{host_port}'"
        end
        host, port = host_port.split(':')
        port = port.to_i
        require 'waitutil'
        Chef::Log.info("Waiting for host/port #{host_port}")
        WaitUtil.wait_for_service(host_port, host, port)
      end
    end
  end
end
