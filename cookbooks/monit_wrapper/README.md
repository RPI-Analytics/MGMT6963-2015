# monit_wrapper

[![Build Status](https://travis-ci.org/clearstorydata-cookbooks/monit_wrapper.svg?branch=master)](https://travis-ci.org/clearstorydata-cookbooks/monit_wrapper)

This cookbook simplifies setting up services using Monit.

* GitHub: https://github.com/clearstorydata-cookbooks/monit_wrapper
* Chef Supermarket: https://supermarket.chef.io/cookbooks/monit_wrapper
* Travis CI: https://travis-ci.org/clearstorydata-cookbooks/monit_wrapper
* Documentation: http://clearstorydata-cookbooks.github.io/monit_wrapper/chef/monit_wrapper.html

## Examples

### Custom Monit configuration template

Create a configuration template in your cookbook `my_cookbook/templates/default/monit/my_service.conf.erb`:

```ruby
check process <%= @service_name %>
  matching '<%= @cmd_line_pattern %>'
  every 1 cycles
  start program "/bin/bash -c 'exec <%= @cmd_line %>'"
    as uid <%= @user %> as gid <%= @user %>
  stop program "/usr/bin/pkill -u <%= @user %> -f '<%= @cmd_line_pattern %>'"
    as uid <%= @user %> as gid <%= @user %>
```

In `my_cookbook/recipes/default.rb`:

```ruby

my_service_name = '...'
command_line = '/usr/local/bin/my_service_executable --port 3456'

monit_wrapper_monitor my_service_name do
  template_cookbook 'my_cookbook'
  template_source 'monit/my_service.conf.erb'
  variables cmd_line: command_line,
            cmd_line_pattern: command_line,
            user: user
end

monit_wrapper_notify_if_not_running monit_service_name

monit_wrapper_service my_service_name do
  subscribes :restart, "monit_wrapper_monitor[#{my_service_name}]", :delayed
  subscribes :restart, "monit_wrapper_notify_if_not_running[#{my_service_name}]", :delayed
  subscribes :restart, "package[#{my_service_name}]", :delayed
end
```

### Launching and monitoring a process with an existing init

If you have a service with an existing `/etc/init.d` script, you can use this cookbook to create
a Monit configuration file to monitor that service. This makes use of the [default Monit
configuration template] (https://github.com/clearstorydata-cookbooks/monit_wrapper/blob/master/templates/default/service_wrapper.monitrc.erb)
this cookbook provides.

```ruby
my_sevice_name = 'my-service'

monit_wrapper_monitor my_service_name do
  action :create
  pattern '...'
end

monit_wrapper_notify_if_not_running my_service_name do

monit_wrapper_service service_name do
  subscribes :restart, "package[#{service_name}]", :delayed
  subscribes :restart, "monit_wrapper_monitor[#{service_name}]", :delayed
  subscribes :restart, "monit_wrapper_notify_if_not_running[#{service_name}]",
             :delayed
end
```

## License

Apache License 2.0

https://www.apache.org/licenses/LICENSE-2.0
