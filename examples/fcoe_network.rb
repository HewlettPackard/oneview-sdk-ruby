require_relative '_client'

# Example: Create an fc network
# NOTE: This will create an fc network named 'OneViewSDK Test FC Network', then delete it.
options = {
  name: 'OneViewSDK Test FCoE Network',
  connectionTemplateUri: nil,
  type: 'fcoe-network',
  vlanId: 300
}

disabled_options = {
  name: 'OneViewSDK Disabled FCoE Network',
  connectionTemplateUri: nil,
  type: 'fcoe-network',
  vlanId: 301,
  status: 'Disabled'
}

# Sucess case - 1
fcoe = OneviewSDK::FCoENetwork.new(@client, options)
fcoe.create
puts "\nCreated fcoe-network '#{fcoe[:name]}' sucessfully.\n  uri = '#{fcoe[:uri]}'"

# Success case - 2
dis_fcoe = OneviewSDK::FCoENetwork.new(@client, disabled_options)
dis_fcoe.create
puts "\nCreated fcoe-network '#{dis_fcoe[:name]}' sucessfully.\n  uri = '#{dis_fcoe[:uri]}'"

# Find recently created network by name
matches = OneviewSDK::FCoENetwork.find_by(@client, name: fcoe[:name])
fcoe2 = matches.first
puts "\nFound fcoe-network by name: '#{fcoe2[:name]}'.\n  uri = '#{fcoe2[:uri]}'"

# Retrieve recently created network
fcoe3 = OneviewSDK::FCoENetwork.new(@client, name: fcoe[:name])
fcoe3.retrieve!
puts "\nRetrieved ethernet-network data by name: '#{fcoe3[:name]}'.\n  uri = '#{fcoe3[:uri]}'"

# Example: List all fcoe networks with certain attributes
attributes = { status: 'Disabled' }
puts "\n\nFCoE networks with #{attributes}"
OneviewSDK::FCoENetwork.find_by(@client, attributes).each do |network|
  puts "  #{network[:name]}"
end

# Delete this network
fcoe3.delete
puts "\nSucessfully deleted fc-network '#{fcoe3[:name]}'."
