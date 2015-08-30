[![Chef cookbook](https://img.shields.io/cookbook/v/users-auth.svg)](https://supermarket.chef.io/cookbooks/users-auth) [![Build Status](https://drone.io/bitbucket.org/ppasupula/chef-users-auth/status.png)](https://drone.io/bitbucket.org/ppasupula/chef-users-auth/latest) [![Hex.pm](http://img.shields.io/hexpm/l/plug.svg)]() 

# users-auth-cookbook

Create users and set ssh auth keys

## Supported Platforms

RHEL, CentOs, Ubuntu and many other Linux flavours

## Attributes

| Key                          | Type   | Description                               | Default           |
|------------------------------|--------|-------------------------------------------|-------------------|
| [:users][:default][:uid]         | String | Default UID                          | "default"        |
| [:users][:default][:password_hash] | String | Password hash | UsersHelper.get_passwd_hash("blabla") |
| [:users][:default][:groups]          | String | User groups                                 | []            |
| [:users][:default][:ssh_keys]          | String | User ssh keys                                | []            |

## Usage

### users-auth::default

```ruby
default[:users][:add] = {
    "testuser" => {
        "password_hash" => "$1$Jox0H8kd$JTKPiEEKpBs3E9S0",
        "groups" => ["apache", "tomcat"],
        "ssh_keys" => ["ssh-rsa AAAAB3NzaC1yc2EAAAABIw"]
    }
}
```

##### Why uid ?
> ===> We set this userid only to make sure it will be able to access its home directory in shared servers

###### How to get "password_hash"
**Get the hash manually if required through the command**
```
openssl passwd -1 'theplaintextpassword'
```
(or)

**use the utility**
```
UsersHelper.get_passwd_hash('theplaintextpassword')
```


**Include `users-auth` in your node's `run_list`:**

```json
{
  "run_list": [
    "recipe[users-auth::default]"
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
- https://supermarket.chef.io/cookbooks/users-auth

## License and Authors

License:: Apache 2.0

Author:: pasupulaphani@gmail.com (http://phaninder.com)
