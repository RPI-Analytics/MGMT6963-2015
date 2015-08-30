# notifying-action

[![Build Status](https://travis-ci.org/clearstorydata-cookbooks/notifying-action.svg?branch=master)](https://travis-ci.org/clearstorydata-cookbooks/notifying-action)

This Chef cookbook simplifies creating resource providers that enclose other resources and need to
notify their subscribers based on the notifications received from all or a subset of these
enclosed resources. This is based on the approach of wrapping all sub-resources used in a resource
in a sub-run-context and examining the results of running that sub-run-context. The implementation
is influenced by the following sources:

* http://realityforge.org/code/2012/07/17/lwrp-notify-on-changed-resources.html
* The "nested resources" slide of this presentation:
  http://www.slideshare.net/geekbri/lwrp-presentation/14

Opscode Community page: http://community.opscode.com/cookbooks/notifying-action.

## Example

Suppose you are implementing a resource that installs a service
and creates a configuration file for it. Then, you want to restart the service if either a new
version was installed, or the configuration file changed.

In your `providers/package_and_conf.rb` you would have:

```ruby
action :install do
  notifying_action_wrapper do
    package 'my_service' do
      action :install
    end

    template '/etc/my_service/config.yml'
      source 'config.yml.erb'
    end
  end
end
```

You will then be able to use this LWRP in recipes as follows:

```ruby
my_cookbook_package_and_conf 'my_service' do
  action :install
  notifies :restart, 'service[my_service]', :immediately
end

service 'my_service' do
  action :nothing
end
```

## Contributing

If you would like to contribute to this cookbook, please submit a pull request on GitHub.

## Links

* GitHub: https://github.com/clearstorydata-cookbooks/notifying-action
* Chef Supermarket: https://supermarket.chef.io/cookbooks/notifying-action
* Travis CI: https://travis-ci.org/clearstorydata-cookbooks/notifying-action

## License

Apache License 2.0
