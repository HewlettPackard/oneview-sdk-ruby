require_relative '_client' # Gives access to @client

# Example: Create an ethernet network
# NOTE: This will create an ethernet network named 'OneViewSDK Test Vlan', then delete it.
options = {
}

ethernet = OneviewSDK::StorageSystem.new(@client, options)
ethernet.create
puts "\nCreated ethernet-network '#{ethernet.name}' sucessfully.\n  uri = '#{ethernet.uri}'"

# Find recently created network by name
matches = OneviewSDK::StorageSystem.find_by(@client, name: ethernet.name)
ethernet2 = matches.first
puts "\nFound ethernet-network by name: '#{ethernet.name}'.\n  uri = '#{ethernet2.uri}'"

# Retrieve recently created network
ethernet3 = OneviewSDK::EthernetNetwork.new(@client, name: ethernet.name)
ethernet3.retrieve!
puts "\nRetrieved ethernet-network data by name: '#{ethernet.name}'.\n  uri = '#{ethernet3.uri}'"

# Delete this network
ethernet2.delete
puts "\nSucessfully deleted ethernet-network '#{ethernet.name}'."


# Example: List all ethernet networks with certain attributes
attributes = { purpose: 'General' }
puts "\n\nEthernet networks with #{attributes}"
OneviewSDK::EthernetNetwork.find_by(@client, attributes).each do |network|
  puts "  #{network.name}"
end
