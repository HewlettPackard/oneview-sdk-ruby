require_relative '_client' # Gives access to @client

# Example: Create a server profile template
# NOTE: This will create a server profile named 'OneViewSDK Test ServerProfileTemplate', then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#   @server_hardware_type_uri
#   @enclosure_group_uri

fail 'Must set @server_hardware_type_uri in _client.rb' unless @server_hardware_type_uri
fail 'Must set @enclosure_group_uri in _client.rb' unless @enclosure_group_uri

type = 'server profile template'
options = {
  name:  'OneViewSDK Test ServerProfileTemplate',
  serverHardwareTypeUri: @server_hardware_type_uri,
  enclosureGroupUri: @enclosure_group_uri
}

item = OneviewSDK::ServerProfileTemplate.new(@client, options)
item.create
puts "\nCreated #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

# Find recently created item by name
matches = OneviewSDK::ServerProfileTemplate.find_by(@client, name: item[:name])
item2 = matches.first
fail "Failed to find #{type} by name: '#{item[:name]}'" unless matches.first
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item2[:uri]}'"

# Retrieve recently created item
item3 = OneviewSDK::ServerProfileTemplate.new(@client, name: item[:name])
item3.retrieve!
puts "\nRetrieved #{type} data by name: '#{item[:name]}'.\n  uri = '#{item3[:uri]}'"

# Delete this item
item3.delete
puts "\nSucessfully deleted #{type} '#{item[:name]}'."


# Example: List all server profile templates with certain attributes
attributes = { affinity: 'Bay' }
puts "\n\n#{type.capitalize}s with #{attributes}"
OneviewSDK::ServerProfileTemplate.find_by(@client, attributes).each do |p|
  puts "  #{p[:name]}"
end
