# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '../../_client' # Gives access to @client

# Example: Create an Logical Switch Group
options = {
  name:  'OneViewSDK Test Logical Switch Group',
  category:  'logical-switch-groups',
  state:  'Active',
  type:  'logical-switch-groupV300'
}

# Creating a LSG
item = OneviewSDK::API300::C7000::LogicalSwitchGroup.new(@client, options)

# Set the group parameters
item.set_grouping_parameters(2, 'Cisco Nexus 50xx')

# Effectively create the LSG
item.create!
puts "\nCreated logical-switch-group '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

sleep(10)

# Retrieves a logical-switch-group'
item2 = OneviewSDK::API300::C7000::LogicalSwitchGroup.new(@client, name: 'OneViewSDK Test Logical Switch Group')
puts "\nRetrieving a logical-switch-group with name: '#{item[:name]}'."
item2.retrieve!
puts "\nRetrieved a logical-switch-group with name: '#{item[:name]}'.\n  uri = '#{item[:uri]}'"

# Updating the LSG
item2.set_grouping_parameters(1, 'Cisco Nexus 50xx')
item2.update(name: 'OneViewSDK Test Logical Switch Group Updated')
puts "\nUpdate logical-switch-group '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

sleep(10)

# Clean up
item2.delete
puts "\nRemoving the logical-switch-group."
