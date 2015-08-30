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

class Chef
  module MonitWrapper
    # Tools to detect service status from Monit's `summary` command output. Methods in this module
    # are automatically available in resources and providers.
    module Status

      include Chef::Mixin::ShellOut

      # Parses the output of the `monit summary` command.
      #
      # @return [Hash] a mapping from service names to their statuses.
      #   Example return value:
      #   `{ 'sshd' => 'Running', 'my-service' => 'Not monitored' }`.
      def get_monit_summary
        monit_executable = node['monit']['executable']
        unless File.exists?(monit_executable)
          Chef::Log.warn("Monit is not installed at #{monit_executable} -- " \
                         "assuming no Monit-controlled processes are running")
          return {}
        end
        p = shell_out("#{node['monit']['executable']} summary")
        unless p.exitstatus == 0
          Chef::Log.fatal("Command '#{p.command}' failed with exit status #{p.exitstatus}\n" +
                          "stdout:\n#{p.stdout}\nstderr:\n#{p.stderr}")
          raise
        end

        parse_monit_summary(p.stdout)
      end

      # Determines whether the given process is registered with Monit. This is done by looking at
      # whether the given service name appears in the output of `monit summary`.
      # @param service_name [String] service name
      # @return `true` if the given service is registered with Monit.
      def monit_service_registered?(service_name)
        get_monit_summary.include?(service_name)
      end

      # Wait until the service status is considered "stable".
      # @return the new status of the given service
      # @see #monit_status_stable?
      def get_stable_monit_service_status(service_name)
        start_time = Time.now
        timeout_sec = 120
        logged_message = false
        status = get_monit_summary[service_name]
        until monit_status_stable?(status)
          if Time.now - start_time >= timeout_sec
            raise "Timed out waiting to get the status of #{service_name} " +
                  "(currently #{status.inspect})"
          end
          unless logged_message
            Chef::Log.info('Waiting for Monit to initialize the status of service ' +
                           "#{service_name} for up to #{timeout_sec} seconds")
            logged_message = true
          end
          sleep(1)
          status = get_monit_summary[service_name]
        end
        status
      end

      # Detects if the given service is running.
      # @param service_name [String] service name
      # @param options [Hash] a hash with the the optional key `:verbose`.
      #    When `:verbose` is set to `true`, additional logging is enabed.
      # @return `true` if the given service is running.
      def monit_service_running?(service_name, options = {})
        is_verbose = options.delete(:verbose)
        raise "Unrecognized options: #{options}" unless options.empty?
        service_status = get_stable_monit_service_status(service_name)
        is_running = service_status =~ /^Running\b/
        if is_verbose
          Chef::Log.info(
            "Monit service #{service_name} is #{is_running ? 'running' : 'not running'} " +
            "(status: #{service_status.inspect})"
          )
        end
        is_running
      end

      # @param service_name [String] service name
      # @return `true` if the given service is registered with Monit and is running.
      def monit_service_exists_and_running?(service_name)
        monit_service_registered?(service_name) && monit_service_running?(service_name)
      end

      protected

      # Determines if the given Monit service status is considered "stable", i.e. not likely to
      # change without external influence. Currently this means it is not "Initializing",
      # "... pending", or "Does not exist", but this definition may change in the future.
      # @return [Boolean] `true` if the given service status is considered "stable".
      def monit_status_stable?(status)
        !status.nil? &&
          status !~ / pending$/ &&
          ![
            'Does not exist',
            'Initializing',
            'PPID changed'
          ].include?(status)
      end

      # Parses the output of the `monit summary` command and returns it in the form of a hash
      # mapping service name to its status.
      def parse_monit_summary(monit_summary_stdout)
        process_name_to_status = {}
        monit_summary_stdout.split("\n").each do |line|
          # The process status can include letters, spaces, and dashes.
          if line =~ /^Process\s+'(\S+)'\s+([A-Za-z -]+)$/
            process_name_to_status[$1] = $2.strip
          end
        end
        Chef::Log.debug(
          "Raw 'monit summary' stdout:\n" \
          "#{monit_summary_stdout.split("\n").map {|line| "    #{line}" }.join("\n")}\n" \
          "Parsed 'monit summary' output:\n" +
          process_name_to_status.to_s)
        process_name_to_status
      end
    end
  end
end

Chef::Resource.send(:include, Chef::MonitWrapper::Status)
Chef::Provider.send(:include, Chef::MonitWrapper::Status)
