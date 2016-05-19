require_relative '_client' # Gives access to @client

# Example: Create an Logical Switch Group
options = {
  name:  'OneViewSDK Test Logical Switch Group',
  category:  'logical-switch-groups',
  state:  'Active',
  type:  'logical-switch-group'
}

# Creating a LSG
lsg = OneviewSDK::LogicalSwitchGroup.new(@client, options)

# Set the group parameters
lsg.set_grouping_parameters(2, 'Cisco Nexus 50xx')

# Effectively create the LSG
lsg.create!
puts "\nCreated logical-switch-group '#{lsg[:name]}' sucessfully.\n  uri = '#{lsg[:uri]}'"

sleep(10)

# Updating the LSG
lsg.set_grouping_parameters(1, 'Cisco Nexus 50xx')
lsg.update(name: 'OneViewSDK Test Logical Switch Group Updated')
puts "\nUpdate logical-switch-group '#{lsg[:name]}' sucessfully.\n  uri = '#{lsg[:uri]}'"

sleep(10)

# Clean up
lsg.delete
