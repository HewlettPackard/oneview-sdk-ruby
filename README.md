# oneview-sdk for Ruby
[![Gem Version](https://badge.fury.io/rb/oneview-sdk.svg)](https://badge.fury.io/rb/oneview-sdk)


The OneView SDK provides a Ruby library to easily interact with HPE OneView API. The Ruby SDK enables developers to easily build integrations and scalable solutions with HPE OneView.

## Installation
- Require the gem in your Gemfile:

  ```ruby
  gem 'oneview-sdk'
  ```

  Then run `$ bundle install`
- Or run the command:

  ```bash
  $ gem install oneview-sdk
  ```


## Configuration
The client has a few configuration options, which you can pass in during creation:

```ruby
require 'oneview-sdk'
client = OneviewSDK::Client.new(
  url: 'https://oneview.example.com',
  user: 'Administrator',              # This is the default
  password: 'secret123',
  ssl_enabled: true,                  # This is the default and strongly encouraged
  logger: Logger.new(STDOUT),         # This is the default
  log_level: :info,                   # This is the default
  api_version: 200,                   # Defaults to minimum of (200 and appliance API version)
  token: 'xxxx...'                    # Set EITHER this or the user & password
)
```

:lock: Tip: Check the file permissions because the password is stored in clear-text.

##### Environment Variables

You can also set the url and credentials or an authentication token using environment variables. For bash:

```bash
export ONEVIEWSDK_URL='https://oneview.example.com'
export ONEVIEWSDK_SSL_ENABLED=false
# NOTE: Disabling SSL is strongly discouraged. Please see the CLI section for import instructions.

# Credentials
export ONEVIEWSDK_USER='Administrator'
export ONEVIEWSDK_PASSWORD='secret123'
# or auth token
export ONEVIEWSDK_TOKEN='xxxx...'
```

:lock: Tip: Be sure nobody has access to your environment variables, as the password or token is stored in clear-text.

Then you can leave out these options from your config, enabling you to just do:

```ruby
require 'oneview-sdk'
client = OneviewSDK::Client.new
```
NOTE: Run `$ oneview-sdk-ruby env` to see a list of available environment variables and their current values.

##### Configuration Files

Configuration files can also be used to define client configuration (json or yaml formats). Here's an example json file:

```json
{
  "url": "https://oneview.example.com",
  "user": "Administrator",
  "password": "secret123"
}
```

and load via:

```ruby
config = OneviewSDK::Config.load("full_file_path.json")
client = OneviewSDK::Client.new(config)
```

:lock: Tip: Check the file permissions because the password is stored in clear-text.

### Custom logging
The default logger is a standard logger to STDOUT, but if you want to specify your own, you can.  However, your logger must implement the following methods:

```ruby
debug(String)
info(String)
warn(String)
error(String)
level=(Symbol, etc.) # The parameter here will be the log_level attribute
```

:lock: Tip: When the log_level is set to debug, API request options will be logged (including auth tokens and passwords); be careful to protect secret information.

## Resources
Each OneView resource is exposed for usage with CRUD-like functionality.

For example, once you instantiate a resource object, you can call intuitive methods such as `resource.create`, `resource.udpate` and `resource.delete`. In addition, resources respond to helpful methods such as `.each`, `.eql?(other_resource)`, `.like(other_resource)`, `.retrieve!`, and many others.

Please see the [rubydoc.info](http://www.rubydoc.info/gems/oneview-sdk) documentation for complete usage details and the [examples](examples/) directory for more examples and test-scripts, but here are a few examples to get you started:

##### Create a resource

```ruby
ethernet = OneviewSDK::EthernetNetwork.new(
  client, { name: 'TestVlan', vlanId:  1001, purpose:  'General', smartLink: false, privateNetwork: false }
)
ethernet.create # Tells OneView to create this resource
```

##### Access resource attributes

```ruby
ethernet['name'] # Returns 'TestVlan'

ethernet.data # Returns hash of all data

ethernet.each do |key, value|
  puts "Attribute #{key} = #{value}"
end
```

The resource's data is stored in its @data attribute.  However, you can access the data directly using a hash-like syntax on the resource object (recommended). `resource['key']` functions a lot like `resource.data['key']`. The difference is that when using the data attribute, you must be cautious to use the correct key type (Hash vs Symbol).
The direct hash accessor on the resource converts all keys to strings, so `resource[:key]` and `resource['key']` access the same thing: `resource.data['key']`.

##### Update a resource

Notice that there are a few different ways to do things, so pick your poison!
```ruby
ethernet.set_all(name: 'newName', vlanId:  1002)
ethernet['purpose'] = 'General'
ethernet['ethernetNetworkType'] = 'Tagged'
ethernet.update # Saves current state to OneView

# Alternatively, you could do this in 1 step with:
ethernet.update(name: 'newName', vlanId:  1002, purpose: 'General', ethernetNetworkType: 'Tagged')
```

##### Check resource equality

You can use the `==`  or `.eql?` method to compare resource equality, or `.like` to compare just a subset of attributes.
```ruby
ethernet2 = OneviewSDK::EthernetNetwork.new(
  client, { name: 'OtherVlan', vlanId:  1000, purpose:  'General', smartLink: false, privateNetwork: false }
)
ethernet == ethernet2    # Returns false
ethernet.eql?(ethernet2) # Returns false


# To compare a subset of attributes:
ethernet3 = OneviewSDK::EthernetNetwork.new(client, { purpose:  'General' })
ethernet.like?(ethernet3)  # Returns true
ethernet.like?(name: TestVlan, purpose: 'General')  # Returns true
```


##### Find resources

```ruby
ethernet = OneviewSDK::EthernetNetwork.new(client, { name: 'OtherVlan' })
ethernet.retrieve! # Uses the name attribute to search for the resource on the server and update the data in this object.


# Each resource class also has a searching method (NOTE: class method, not instance method)
ethernet = OneviewSDK::EthernetNetwork.find_by(client, { name: 'OtherVlan' }).first

OneviewSDK::EthernetNetwork.find_by(client, { purpose: 'General' }).each do |network|
  puts "  #{network['name']}"
end

# Get all resources:
networks = client.get_all(:EthernetNetwork)
```

##### Delete a resource

```ruby
ethernet = OneviewSDK::EthernetNetwork.find_by(client, { name: 'OtherVlan' }).first
ethernet.delete # Tells OneView to delete this resource
```

### Save/Load resources with files
Resources can be saved to files and loaded again very easily using the built-in `.to_file` & `.from_file` methods.

 - To save a Resource to a file:

   ```ruby
   ethernet.to_file("full_file_path.json")
   ```
 - To load a resource from a file: (note the class method, not instance method)

   ```ruby
   ethernet4 = OneviewSDK::Resource.from_file(client, "full_file_path.json")
   ```


For more examples and test-scripts, see the [examples](examples/) directory and [rubydoc.info](http://www.rubydoc.info/gems/oneview-sdk) documentation.

## Custom requests
In most cases, interacting with Resource objects is enough, but sometimes you need to make your own custom requests to OneView.
This project makes it extremely easy to do with some built-in methods for the Client object. Here are some examples:

```ruby
# Get the appliance startup progress:
response = client.rest_api(:get, '/rest/appliance/progress')
# or even more simple:
response = client.rest_get('/rest/appliance/progress')

# Then we can validate the response and convert the response body into a hash...
data = client.response_handler(response)
```

This example is about as basic as it gets, but you can make any type of OneView request.
If a resource does not do what you need, this will allow you to do it.
Please refer to the documentation and [code](lib/oneview-sdk/rest.rb) for complete list of methods and information about how to use them.


## CLI
This gem also comes with a command-line interface to make interacting with OneView possible without the need to create a Ruby program or script.

Note: In order to use this, you will need to make sure your ruby `bin` directory is in your path.
Run `$ gem environment` to see where the executable paths are for your Ruby installation.

To get started, run `$ oneview-sdk-ruby --help`.

To communicate with an appliance, you will need to set up a few environment variables so it knows how to communicate. Run `$ oneview-sdk-ruby env` to see the available environment variables.

The CLI does not expose everything in the SDK, but it is great for doing simple tasks such as creating or deleting resources from files, listing resources, and searching. Here are a few examples:

##### List ServerProfiles:

```bash
$ oneview-sdk-ruby list ServerProfiles
# Or to show in yaml format (json is also supported):
$ oneview-sdk-ruby list ServerProfiles -f yaml
```

##### Show details for a specific resource:

```bash
$ oneview-sdk-ruby show ServerProfile profile-1
# Or to show specific attributes only:
$ oneview-sdk-ruby show ServerProfile profile-1 -a name,uri,enclosureBay
```

##### Search by an attribute:

```bash
$ oneview-sdk-ruby search ServerProfiles --filter state:Normal affinity:Bay
# By default, it will just show a list of names of matching resources,
#   but again, you can show only certain attributes by using the -a option
# You can also chain keys together to search in nested hashes:
$ oneview-sdk-ruby search ServerProfiles --filter state:Normal boot.manageBoot:true
```

##### Create or delete resource by file:

```bash
$ oneview-sdk-ruby create_from_file /my-server-profile.json
$ oneview-sdk-ruby delete_from_file /my-server-profile.json
```

##### Update resources by name:

```bash
$ oneview-sdk-ruby update FCNetwork FC1 -h linkStabilityTime:20  # Using hash format
$ oneview-sdk-ruby update Volume VOL_01 -j '{"shareable": true}' # Using json format
```

##### Make REST calls:

```bash
$ oneview-sdk-ruby rest get rest/fc-networks
$ oneview-sdk-ruby rest PUT rest/enclosures/<id>/configuration
```

##### Start an interactive console session with a OneView connection:

```bash
$ oneview-sdk-ruby console
Console Connected to https://oneview.example.com
HINT: The @client object is available to you
>
```

##### Import a self-signed SSL certificate from your OneView instance:

Although you can disable SSL validation altogether for the client, this is strongly discouraged.
Instead, please import the certificate using the built-in CLI cert command:
```bash
# Check the certificate first:
$ oneview-sdk-ruby cert check https://oneview.example.com
 Checking certificate for 'https://oneview.example.com' ...
 ERROR: Certificate Validation Failed!

# Import the certificate:
$ oneview-sdk-ruby cert import https://oneview.example.com
 Importing certificate for 'https://oneview.example.com' into '/home/users/user1/.oneview-sdk-ruby/trusted_certs.cer'...
 Cert added to '/home/users/user1/.oneview-sdk-ruby/trusted_certs.cer'
```

## License
This project is licensed under the Apache 2.0 license. Please see [LICENSE](LICENSE) for more info.

## Contributing and feature requests
**Contributing:** You know the drill. Fork it, branch it, change it, commit it, and pull-request it.
We are passionate about improving this project, and glad to accept help to make it better.

NOTE: We reserve the right to reject changes that we feel do not fit the scope of this project, so for feature additions, please open an issue to discuss your ideas before doing the work.

**Feature Requests:** If you have a need that is not met by the current implementation, please let us know (via a new issue).
This feedback is crucial for us to deliver a useful product. Do not assume we have already thought of everything, because we assure you that is not the case.

### Building the Gem
First run `$ bundle` (requires the bundler gem), then...
 - To build only, run `$ rake build`.
 - To build and install the gem, run `$ rake install`.

### Testing
 - RuboCop: `$ rake rubocop`
 - Unit: `$ rake spec`
 - Integration: See the [spec/integration](spec/integration/) README
 - All: Run `$ rake test:all` to run RuboCop, unit, & integration tests.
 - Examples: See the [examples](examples/) README

Note: run `$ rake -T` to get a list of all the available rake tasks.

## Authors
 - Jared Smartt - [@jsmartt](https://github.com/jsmartt)
 - Henrique Diomede - [@hdiomede](https://github.com/hdiomede)
 - Thiago Miotto - [@tmiotto](https://github.com/tmiotto)
 - Ricardo Piantola - [@piantola](https://github.com/piantola)
