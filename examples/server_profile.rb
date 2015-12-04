require_relative '_client' # Gives access to @client

# Example: Create a server profile
# NOTE: This will create a server profile named 'OneViewSDK Test ServerProfile', then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#   @server_hardware_type_uri
#   @enclosure_group_uri

fail 'Must set @server_hardware_type_uri in _client.rb' unless @server_hardware_type_uri
fail 'Must set @enclosure_group_uri in _client.rb' unless @enclosure_group_uri

options = {
  name:  'OneViewSDK Test ServerProfile',
  serverHardwareTypeUri: @server_hardware_type_uri,
  enclosureGroupUri: @enclosure_group_uri
}

profile = OneviewSDK::ServerProfile.new(@client, options)
profile.create
puts "\nCreated server profile '#{profile[:name]}' sucessfully.\n  uri = '#{profile[:uri]}'"

# Show available server hardware that matches this profile's requirements
puts "\nAvailable server hardware for profile '#{profile[:name]}':"
profile.available_hardware.each { |hw| puts "  - #{hw[:name]}" }

# Find recently created server profile by name
matches = OneviewSDK::ServerProfile.find_by(@client, name: profile[:name])
profile2 = matches.first
puts "\nFound server profile by name: '#{profile[:name]}'.\n  uri = '#{profile2[:uri]}'"

# Retrieve recently created server profile
profile3 = OneviewSDK::ServerProfile.new(@client, name: profile[:name])
profile3.retrieve!
puts "\nRetrieved server profile data by name: '#{profile[:name]}'.\n  uri = '#{profile3[:uri]}'"

# Delete this profile
profile.delete
puts "\nSucessfully deleted profile '#{profile[:name]}'."


# Example: List all server profiles with certain attributes
attributes = { affinity: 'Bay' }
puts "\n\nprofile profiles with #{attributes}"
OneviewSDK::ServerProfile.find_by(@client, attributes).each do |p|
  puts "  #{p[:name]}"
end
