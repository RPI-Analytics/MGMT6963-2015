
[![Chef cookbook](https://img.shields.io/cookbook/v/ssh-auth.svg)](https://supermarket.chef.io/cookbooks/ssh-auth) [![Build Status](https://drone.io/bitbucket.org/ppasupula/chef-ssh-auth/status.png)](https://drone.io/bitbucket.org/ppasupula/chef-ssh-auth/latest) [![Hex.pm](http://img.shields.io/hexpm/l/plug.svg)]() 
# ssh-auth-cookbook

Configures ssh and provides some utils for auth keys

## Supported Platforms

RHEL, CentOs, Ubuntu and many other Linux flavours

## Attributes

| Key                          | Type   | Description                               | Default           |
|------------------------------|--------|-------------------------------------------|-------------------|
| [:ssh][:install_dir]         | String | Installation dir                          | "/etc/ssh"        |
| [:ssh][:authorized_keys_dir] | String | Authorize keys in relative to install_dir | "authorized_keys" |
| [:ssh][:user]                | String | User name                                 | "root"            |
| [:ssh][:group]               | String | User group                                | "root"            |

## Usage

### ssh-auth::default

Include `ssh-auth` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[ssh-auth::default]"
  ]
}
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Locations
- https://supermarket.chef.io/cookbooks/ssh-auth

## License and Authors

License:: Apache 2.0

Author:: pasupulaphani@gmail.com (http://phaninder.com)
