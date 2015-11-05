require_relative '_client' # Gives access to @client

# Example: Create a server profile template
# NOTE: This will create a server profile named 'OneViewSDK Test ServerProfileTemplate', then delete it.
# NOTE: You'll need to replace the URIs in the options below with valid URIs for your environment.
type = 'server profile template'
options = {
  name:  'OneViewSDK Test ServerProfileTemplate',
  serverHardwareTypeUri: '/rest/server-hardware-types/11111111-1111-1111-1111-111111111111', # TODO: Replace
  enclosureGroupUri: '/rest/enclosure-groups/11111111-1111-1111-1111-111111111111' # TODO: Replace
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
