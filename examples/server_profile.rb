require_relative '_client' # Gives access to @client

# Example: Create a server profile
# NOTE: This will create a server profile named 'OneViewSDK Test ServerProfile', then delete it.
# NOTE: You'll need to replace the URIs in the options below with valid URIs for your environment.
options = {
  name:  'OneViewSDK Test ServerProfile',
  serverHardwareTypeUri: '/rest/server-hardware-types/11111111-1111-1111-1111-111111111111', # TODO: Replace
  enclosureGroupUri: '/rest/enclosure-groups/11111111-1111-1111-1111-111111111111' # TODO: Replace
}

profile = OneviewSDK::ServerProfile.new(@client, options)
profile.create
puts "\nCreated server profile '#{profile[:name]}' sucessfully.\n  uri = '#{profile[:uri]}'"

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
