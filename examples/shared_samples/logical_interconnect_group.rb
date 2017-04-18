# (C) Copyright 2017 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '../_client' # Gives access to @client

# Example: Create/Update/Delete logical interconnects groups
# NOTE: This will create a few networks (ethernet & FC), as well as a LIG named 'ONEVIEW_SDK_TEST_LIG', then delete them all.
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::LogicalInterconnectGroup
# api_version = 300 & variant = C7000 to lig_class
# api_version = 300 & variant = Synergy to lig_class
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::LogicalInterconnectGroup
# api_version = 500 & variant = Synergy to OneviewSDK::API500::C7000::LogicalInterconnectGroup

# Resource Class used in this sample
lig_class = OneviewSDK.resource_named('LogicalInterconnectGroup', @client.api_version)

variant = OneviewSDK.const_get("API#{@client.api_version}").variant unless @client.api_version < 300

# Ethernet network class used in this sample
ethernet_class = OneviewSDK.resource_named('EthernetNetwork', @client.api_version)
# Ethernet network class used in this sample
fc_network_class = OneviewSDK.resource_named('FCNetwork', @client.api_version)
# LIG uplink set class used in this sample
lig_uplink_set_class = OneviewSDK.resource_named('LIGUplinkSet', @client.api_version)
# Scope class used in this sample
scope_class = OneviewSDK.resource_named('Scope', @client.api_version) unless @client.api_version.to_i <= 200

type = 'Logical Interconnect Group'

HP_VC_FF_24_MODEL = 'HP VC FlexFabric 10Gb/24-Port Module'.freeze
VIRTUAL_CONNECT_SE_40_SYNERGY = 'Virtual Connect SE 40Gb F8 Module for Synergy'.freeze

lig = lig_class.new(@client, name: 'ONEVIEW_SDK_TEST_LIG')

# Create an Ethernet Uplink Set
eth1_options = {
  vlanId:  801,
  purpose:  'General',
  name:  'ONEVIEW_SDK_TEST_ETH01',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri:  nil
}

eth2_options = {
  vlanId:  802,
  purpose:  'General',
  name:  'ONEVIEW_SDK_TEST_ETH02',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri:  nil
}

eth01 = ethernet_class.new(@client, eth1_options)
eth02 = ethernet_class.new(@client, eth2_options)
eth01.create!
eth02.create!

# Create an FC Uplink Set
fc1_options = {
  name: 'ONEVIEW_SDK_TEST_FC01',
  connectionTemplateUri: nil,
  autoLoginRedistribution: true,
  fabricType: 'FabricAttach'
}

fc01 = fc_network_class.new(@client, fc1_options)
fc01.create!

if variant == 'C7000' || @client.api_version == 200
  # Add the interconnects to the bays 1 and 2
  lig.add_interconnect(1, HP_VC_FF_24_MODEL)
  lig.add_interconnect(2, HP_VC_FF_24_MODEL)

  upset01_options = {
    name: 'ETH_UP_01',
    networkType: 'Ethernet',
    ethernetNetworkType: 'Tagged'
  }

  upset01 = lig_uplink_set_class.new(@client, upset01_options)
  upset01.add_network(eth01)
  upset01.add_network(eth02)

  upset01.add_uplink(1, 'X5')
  upset01.add_uplink(1, 'X6')
  upset01.add_uplink(2, 'X7')
  upset01.add_uplink(2, 'X8')

  lig.add_uplink_set(upset01)

  upset02_options = {
    name: 'FC_UP_01',
    networkType: 'FibreChannel'
  }

  upset02 = lig_uplink_set_class.new(@client, upset02_options)
  upset02.add_network(fc01)

  upset02.add_uplink(1, 'X1')
  upset02.add_uplink(1, 'X2')
  upset02.add_uplink(1, 'X3')

  lig.add_uplink_set(upset02)
end

if variant == 'Synergy'
  lig['redundancyType'] = 'Redundant'
  lig['interconnectBaySet'] = 3

  # Adds the following interconnects to the bays 3 and 6 with an Interconnect Type, respectively
  lig.add_interconnect(3, VIRTUAL_CONNECT_SE_40_SYNERGY)
  lig.add_interconnect(6, VIRTUAL_CONNECT_SE_40_SYNERGY)
end

# Create the fully configured LIG
puts "\nCreating a #{type} with name = #{lig[:name]}."
lig.create!
puts "\n#{type} #{lig[:name]} created!"

# List the LIGs
# Example: List all the logical interconnect groups
puts "\n#{type}s:"
lig_class.find_by(@client, {}).each do |r|
  puts "  #{r[:name]}"
end

puts 'Listing default settings'
puts lig_class.get_default_settings(@client)

puts 'Listing this LIG settings'
puts lig.get_settings

puts 'Updating the lig (Removing the uplink set)'
lig['uplinkSets'] = []
lig.update
puts "#{type} was updated successfully:"
puts lig.data

if variant == 'Synergy'
  puts "\nAdding an internal network with uri = #{eth01['uri']}"
  lig.add_internal_network(eth01)
  lig.update
  lig.retrieve!
  puts "\nAdded an internal network with uri = #{eth01['uri']} successfully."
  puts lig['internalNetworkUris']

  puts "\nRemoving an internal network with uri = #{eth01['uri']}"
  lig['internalNetworkUris'] = []
  lig.update
  puts "\Removed an internal network with uri = #{eth01['uri']} successfully."
  puts lig['internalNetworkUris']
end

# only for API300 and API500
if @client.api_version.to_i > 200
  scope_1 = scope_class.new(@client, name: 'Scope 1')
  scope_1.create!
  scope_2 = scope_class.new(@client, name: 'Scope 2')
  scope_2.create!

  puts "\nAdding scopes"
  lig.add_scope(scope_1)
  lig.refresh
  puts 'Scopes:', lig['scopeUris']

  puts "\nReplacing scopes"
  lig.replace_scopes(scope_2)
  lig.refresh
  puts 'Scopes:', lig['scopeUris']

  puts "\nRemoving scopes"
  lig.remove_scope(scope_1)
  lig.remove_scope(scope_2)
  lig.refresh
  puts 'Scopes:', lig['scopeUris']

  # Clear data
  scope_1.delete
  scope_2.delete
end

# Remove the logical interconnect group
puts "\nRemoving the #{type} with name = #{lig['name']}."
lig.delete
puts "\n#{type} with name = #{lig['name']} was removed successfully."

# Clean up after ourselves
eth01.delete
eth02.delete
fc01.delete
puts "\nCleanup complete!"
