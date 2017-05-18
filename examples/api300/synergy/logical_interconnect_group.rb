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
  name: 'OneViewSDK LIG with 2 Frames',
  redundancyType: 'HighlyAvailable',
  interconnectBaySet: 3,
  enclosureIndexes: [1, 2],
  enclosureType: 'SY12000'
}

# Adds a new LIG with the options defined above
item = OneviewSDK::API300::Synergy::LogicalInterconnectGroup.new(@client, options)

# Adds the following interconnects to the bays 3 and 6 with an Interconnect Type, respectively
item.add_interconnect(3, 'Virtual Connect SE 40Gb F8 Module for Synergy', nil, 1)
item.add_interconnect(6, 'Synergy 20Gb Interconnect Link Module', nil, 1)
item.add_interconnect(3, 'Synergy 20Gb Interconnect Link Module', nil, 2)
item.add_interconnect(6, 'Virtual Connect SE 40Gb F8 Module for Synergy', nil, 2)

# Adds a new Ethernet / Tagged network
network01_options = {
  name: 'Management',
  vlanId:  1000,
  purpose: 'General',
  smartLink: false,
  privateNetwork: false
}
network01 = OneviewSDK::API300::EthernetNetwork.new(@client, network01_options)
network01.create!

# Adds Uplink Set
upset01_options = {
  name: 'UplinkSet1',
  networkType: 'Ethernet'
}
upset01 = OneviewSDK::API300::LIGUplinkSet.new(@client, upset01_options)

# Adds Uplink ports from Frame #1 ICM3, Frame #2 ICM6
upset01.add_uplink(3, 'Q1', 'Virtual Connect SE 40Gb F8 Module for Synergy', 1)
upset01.add_uplink(6, 'Q1', 'Virtual Connect SE 40Gb F8 Module for Synergy', 2)

# Adds network 'Management' to the Uplink Set
upset01.add_network(network01)

# Adds Uplink set to the LIG
item.add_uplink_set(upset01)

# Creates the LIG
item.create

# Lists all LIGs in the Appliance
OneviewSDK::API300::Synergy::LogicalInterconnectGroup.get_all(@client).each do |lig|
  puts "Name: #{lig['name']}\nURI: #{lig['uri']}"
end

# Deletes the LIG
item.delete
