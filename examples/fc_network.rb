require_relative '_client' # Gives access to @client

# Example: Create an fc network
# NOTE: This will create an fc network named 'OneViewSDK Test FC Network', then delete it.
options = {
  name: 'OneViewSDK Test FC Network',
  connectionTemplateUri: nil,
  autoLoginRedistribution: true,
  fabricType: 'FabricAttach'
}

fc = OneviewSDK::FCNetwork.new(@client, options)
fc.create
puts "\nCreated fc-network '#{fc[:name]}' sucessfully.\n  uri = '#{fc[:uri]}'"

# Find recently created network by name
matches = OneviewSDK::FCNetwork.find_by(@client, name: fc[:name])
fc2 = matches.first
puts "\nFound ethernet-network by name: '#{fc2[:name]}'.\n  uri = '#{fc2[:uri]}'"

# Retrieve recently created network
fc3 = OneviewSDK::FCNetwork.new(@client, name: fc[:name])
fc3.retrieve!
puts "\nRetrieved ethernet-network data by name: '#{fc3[:name]}'.\n  uri = '#{fc3[:uri]}'"

# Delete this network
fc3.delete
puts "\nSucessfully deleted fc-network '#{fc3[:name]}'."


# Example: List all fc networks with certain attributes
attributes = { fabricType: 'FabricAttach' }
puts "\n\nFC networks with #{attributes}"
OneviewSDK::FCNetwork.find_by(@client, attributes).each do |network|
  puts "  #{network[:name]}"
end
