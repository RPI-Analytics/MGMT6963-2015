class Chef
  # :nodoc:
  module NotifyingAction
    # Based on http://realityforge.org/code/2012/07/17/lwrp-notify-on-changed-resources.html
    # Marks the enclosing resource as updated if any of the sub-resources, or any of the
    # selected subset of resources if allow_updates_from is set, are updated.
    # @param options [Hash] a hash with the following allowed keys:
    # * `:verbose` - turn on verbose logging
    # * `:allow_updates_from` - specifies a resource, such as `template[/etc/hosts]`, notifications
    #   from which need to be propagated to subscribes of the resource provider calling this
    #   function. This resource must be defined in the supplied block. Notifications from all other
    #   resources are ignored. If no matching resource is found in the block, an exception is
    #   raised, because it is most likely a bug.
    #   You can also specify multiple resources as the value for `:allow_updates_from`. All of them
    #   must exist in the block (or an exception is raised). Notifications to any of those resources
    #   will trigger a notification from the resource calling this function.
    def notifying_action_wrapper(options = {}, &block)
      options = options.clone  # don't modify the original hash

      is_verbose = options.delete(:verbose) || false
      allow_updates_from = options.delete(:allow_updates_from)

      raise "Unrecognized options: #{options}" unless options.empty?

      # Setup a sub-run-context.
      sub_run_context = @run_context.dup
      sub_run_context.resource_collection = Chef::ResourceCollection.new

      # Declare sub-resources within the sub-run-context. Since they are declared here, they
      # do not pollute the parent run-context.
      begin
        original_run_context, @run_context =
            @run_context, sub_run_context
        instance_eval(&block)
      ensure
        @run_context = original_run_context
      end

      # Converge the sub-run-context inside the provider action. Make sure to mark the resource
      # as updated-by-last-action if any sub-run-context resources were updated (any actual
      # actions taken against the system) during the sub-run-context convergence.
      begin
        Chef::Runner.new(sub_run_context).converge
      ensure
        all_subresources = sub_run_context.resource_collection
        subresources = all_subresources

        unless allow_updates_from.nil?
          allow_updates_from_arr =
            allow_updates_from.is_a?(String) ? [allow_updates_from] : allow_updates_from.to_a
          raise 'An empty list specified for :allow_updates_from' if allow_updates_from_arr.empty?

          subresources = []
          allow_updates_from_arr.each do |resource_search_str|
            begin
              subresources_part = all_subresources.find(resource_search_str)
            rescue Chef::Exceptions::ResourceNotFound
              subresources_part = []
            end
            subresources_part = [subresources_part] unless subresources_part.is_a?(Array)
            subresources_part = subresources_part.delete_if(&:nil?)
            if subresources_part.empty?
              raise "Could not find any sub-resources matching #{resource_search_str} " +
                    'to check for updates'
            end
            subresources += subresources_part
          end
        end

        updated_subresources = subresources.select(&:updated?)
        if updated_subresources.empty?
          if is_verbose
            Chef::Log.info("Not updating #{new_resource} because no relevant sub-resources " +
                           "were updated: #{subresources.map { |r| r.to_s }.join(', ')}")
          end
        else
          if is_verbose
            Chef::Log.info("Updating #{new_resource} because the following sub-resources " +
                           "were updated: #{updated_subresources.map { |r| r.to_s }.join(', ')}")
          end
          new_resource.updated_by_last_action(true)
        end
      end
    end
  end
end

Chef::Provider.send(:include, Chef::NotifyingAction)
