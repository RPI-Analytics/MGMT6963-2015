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

require 'chef/mixin/shell_out'
require_relative 'status'

class Chef
  module MonitWrapper
    module StartStop
      include Chef::Mixin::ShellOut
      include Chef::MonitWrapper::Status

      DEFAULT_MONIT_SERVICE_HOST_PORT_TIMEOUT_SEC = 60

      # Starts the given Monit service. Waits for the service status to stabilize before and after
      # issuing the start command. If a host/port combination is specified, waits for the given host
      # to start listening on the given TCP port before returning.
      #
      # @param service_name [String] service name
      # @param options [Hash] a hash with optional arguments:
      #
      #   * `:host` - host to wait for
      #   * `:port` - TCP port number to wait for
      #   * `:timeout_sec` - the maximum number of seconds to wait for the given host/port
      #     combination to become available.
      def start_monit_service(service_name, options = {})
        options = options.clone
        host = options.delete(:host) || 'localhost',
        port = options.delete(:port)
        timeout_sec = options.delete(:timeout_sec) || DEFAULT_MONIT_SERVICE_HOST_PORT_TIMEOUT_SEC
        raise "Invalid options: #{options}" unless options.empty?

        # Wait for the service status to stabilize to avoid the
        # "Other action already in progress -- please try again later" error.

        get_stable_monit_service_status(service_name)

        shell_out!("monit start #{service_name}")

        # Wait for service status to stabilize once again.
        get_stable_monit_service_status(service_name)

        if host && port
          require 'waitutil'  # Only require this when necessary, so that the gem is installed.
          Chef::Log.info(
            "Waiting for service #{service_name} to become available on host #{host}, port #{port}")
          WaitUtil.wait_for_service(service_name, host, port, delay_sec: 1,
            timeout_sec: timeout_sec)
        end
      end

      # Stops the given Monit service. Waits for the service status to stabilize before and after
      # issuing the stop command.
      def stop_monit_service(service_name)
        get_stable_monit_service_status(service_name)
        shell_out!("monit stop #{service_name}")
        get_stable_monit_service_status(service_name)
      end

      # Restarts the given Monit service. Waits for the service status to stabilize before and after
      # issuing the restart command. If a host/port combination is specified, waits for the given
      # host to start listening on the given TCP port before returning.
      #
      # @param service_name [String] service name
      # @param options [Hash] a hash with optional arguments:
      #
      #   * `:host` - host to wait for
      #   * `:port` - TCP port number to wait for
      #   * `:timeout_sec` - the maximum number of seconds to wait for the given host/port
      #     combination to become available.
      def restart_monit_service(service_name, options = {})
        options = options.clone
        host = options.delete(:host) || 'localhost',
        port = options.delete(:port)
        timeout_sec = options.delete(:timeout_sec) || DEFAULT_MONIT_SERVICE_HOST_PORT_TIMEOUT_SEC
        raise "Invalid options: #{options}" unless options.empty?

        get_stable_monit_service_status(service_name)
        shell_out!("monit restart #{service_name}")

        # Wait for service status to stabilize once again.
        get_stable_monit_service_status(service_name)
        if host && port
          require 'waitutil'  # Only require this when necessary, so that the gem is installed.
          Chef::Log.info(
            "Waiting for service #{service_name} to become available on host #{host}, port #{port}")
          WaitUtil.wait_for_service(service_name, host, port, delay_sec: 1,
            timeout_sec: timeout_sec)
        end
      end

      # Ensure the Monit daemon is running.
      def ensure_monit_daemon_is_running
        Chef::Log.info('Ensuring the Monit service is running')
        result = shell_out('service monit start')
        if result.exitstatus != 0 && !result.stderr.include?('start: Job is already running: monit')
          fail "Failed to start Monit. stdout:\n#{result.stdout}\nstderr:\n#{result.stderr}"
        end
      end

      # Wait for the given service to be recognized as a Monit service. This is determined by
      # checking whether the output of the `monit status` command includes the given service name.
      # @param service_name [String] service name
      def wait_for_monit_service_to_exist(service_name)
        require 'waitutil'
        WaitUtil.wait_for_condition(
          "#{service_name} to show up in the output of 'monit status'",
          delay_sec: 1,
          timeout_sec: 120
        ) do
          p = shell_out("#{node['monit']['executable']} status")
          stdout_stderr_combined = "stdout:\n#{p.stdout}\nstderr:#{p.stderr}"
          if p.stderr.include?('Status not available -- the monit daemon is not running')
            # Monit might have crashed on the "monit reload" command. Restart it as a temporary
            # workaround.
            ensure_monit_daemon_is_running
            [false, stdout_stderr_combined]
          else
            if p.exitstatus != 0
              Chef::Log.fatal("Command '#{p.command}' failed\n" +
                              "stdout:\n#{p.stdout}\nstderr:\n#{p.stderr}")
              fail
            end
            [p.stdout.split("\n").include?("Process '#{service_name}'"),
             stdout_stderr_combined]
          end
        end
      end

    end
  end
end

Chef::Resource::RubyBlock.send(:include, Chef::MonitWrapper::StartStop)
Chef::Provider::RubyBlock.send(:include, Chef::MonitWrapper::StartStop)
