# AlertLogic

AlertLogic is very early on in development.  The code is not 100% tested and
many of the tests need to be refactorerd.  Some helper methods have not been
added but every allowable action the API supports will eventually find itself as
an instance method on each resource.  You should not consider this a stable API
until a more mature release with full feature coverage.

While the client passes the specs in Ruby 1.8.7, there's no guarantee that all
functions will work.  If possible use Ruby >= 1.9.3.

## Installation

Add this line to your application's Gemfile:

    gem 'alert_logic'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install alert_logic

## Usage

AlertLogic only requires the API secret key to authenticate with the API.

```ruby
require 'alert_logic'
AlertLogic.secret_key = "YOUR 50 HEX CHARACTER SECRET KEY"
```

From there you can make raw requests with the API Client:

```ruby
AlertLogic.api_client.get('policy', 'SOME_POLICY_ID')
```

If you'd rather avoid the the global client you can create an instance:

```ruby
@client = AlertLogic::Client.new("YOUR 50 HEX CHARACTER SECRET KEY")
@client.list('protectedhost')
```

Using the raw client is fine but the real utility comes from using the resource
classes:

```ruby
hosts = AlertLogic::ProtectedHost.find(:all)
appliance = AlertLogic::Appliance.find(:online, 'id' => 'SOME ID')
policy_ids = AlertLogic:::Policy.find(:appliance_assignment)
```

Yeah, that's right, you can use preset filters, custom filters, preset and
custom filters together or you can even define your own:

```ruby
my_filters = {
  :us_east_appliance => {'id' => 'ID OF THE APPLIANCE IN US EAST'}
  :us_west_appliance => {'id' => 'ID OF THE APPLIANCE IN US WEST'}
}
AlertLogic::Resource.filters.merge!(my_filters)
us_east_appliance = AlertLogic::Appliance.find(:us_east_appliance).first
```

That's nice, but the real magic comes when you use the classes together:

```ruby
linux_hosts = AlertLogic::ProtectedHost.find(:online, :linux)
us_east_appliance = AlertLogic::Appliance.find(:us_east_appliance).first
linux_hosts.each { |host| host.assign_appliance(us_east_appliance) }
```

Another cool thing is that all of the Resource attributes become instance
variables with their own corresponding accessors:

```ruby
host = AlertLogic::ProtectedHost.find_by_id('SOME HOST ID')
host.status #=> 'online'
host.appliance_assigned_to #=> 'XXXXXX-XXXX-XXXX-XXXX-XXXXXXXX'
host.appliance_connected_to #=> '10.10.1.1'
host.local_hostname #=> ip-10-154-155-257.ec2.internal
```

And common actions have corresponding API methods built on:

```ruby
host = AlertLogic::ProtectedHost.find_by_id('SOME HOST ID')
host.name #=> 'some_name'
host.name = "My New Name" #=> "My New Name"
host.name #=> 'My New Name'
host.tags #=> nil
host.tags = "my_tag some_other_tag" #=> "my_tag some_other_tag"
host.tags #=> [{"name"=>"my_tag"}, {"name"=>"some_other_tag"}]
host.config_policy_id #=> 'XXXXXX-XXXX-XXXX-XXXX-XXXXXXXX'
host.config_policy_id = 'AAAAA-AAAAA-AAAA-AAAAA-AAAAAAAA'
host.config_policy_id #=> 'AAAAA-AAAAA-AAAA-AAAAA-AAAAAAAA'
```

## Contributing

1. Fork it ( http://github.com/ryancragun/alert_logic/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
