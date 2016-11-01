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

require_relative '../../_client' # Gives access to @client,

# Example: Create a Logical Interconnect Group

options = {
  name: 'Sample LIG',
  redundancyType: 'Redundant',
  interconnectBaySet: 3
}

# Adds a new LIG with the options defined above
item = OneviewSDK::API300::Thunderbird::LogicalInterconnectGroup.new(@client, options)

# Adds the following interconnects to the bays 3 and 6 with an Interconnect Type, respectively
item.add_interconnect(3, 'Virtual Connect SE 40Gb F8 Module for Synergy')
item.add_interconnect(6, 'Virtual Connect SE 40Gb F8 Module for Synergy')

# Creates the LIG
item.create

# Lists all LIGs in the Appliance
OneviewSDK::API300::Thunderbird::LogicalInterconnectGroup.each do |lig|
  puts "Name: #{lig['name']}\nURI: #{lig['uri']}"
end

# Deletes the LIG
item.delete
