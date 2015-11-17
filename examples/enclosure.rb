require_relative '_client' # Gives access to @client

# Example: Add an enclosure
# NOTE: This will add an enclosure named 'OneViewSDK-Test-Enclosure', then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#   @enclosure_hostname (hostname or IP address)
#   @enclosure_username
#   @enclosure_password
#   @enclosure_group_uri

type = 'enclosure'
options = {
  name: 'OneViewSDK-Test-Enclosure',
  hostname: @enclosure_hostname,
  username: @enclosure_username,
  password: @enclosure_password,
  enclosureGroupUri: @enclosure_group_uri,
  licensingIntent: 'OneView'
}

item = OneviewSDK::Enclosure.new(@client, options)
item.create
puts "\nCreated #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

item2 = OneviewSDK::Enclosure.new(@client, name: options[:name])
item2.retrieve!
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item2[:uri]}'"

item.refresh
item.update(name: 'OneViewSDK_Test_Enclosure')
puts "\nUpdated #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

item.delete
puts "\nSucessfully deleted #{type} '#{item[:name]}'."
