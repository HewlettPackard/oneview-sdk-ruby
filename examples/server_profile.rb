require_relative '_client' # Gives access to @client

# Example: Create a server profile
# NOTE: This will create a server profile named 'OneViewSDK Test ServerProfile', then delete it.

profile = OneviewSDK::ServerProfile.new(@client, 'name' => 'OneViewSDK Test ServerProfile')

target = OneviewSDK::ServerProfile.get_available_targets(@client)['targets'].first

server_hardware = OneviewSDK::ServerHardware.new(@client, uri: target['serverHardwareUri'])
server_hardware_type = OneviewSDK::ServerHardwareType.new(@client, uri: target['serverHardwareTypeUri'])
enclosure_group = OneviewSDK::EnclosureGroup.new(@client, uri: target['enclosureGroupUri'])

profile.set_server_hardware(server_hardware)
profile.set_server_hardware_type(server_hardware_type)
profile.set_enclosure_group(enclosure_group)

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
