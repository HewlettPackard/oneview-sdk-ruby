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
