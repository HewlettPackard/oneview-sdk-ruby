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

# Example: Create a network set
# NOTE: This will create a network set named 'NetworkSet_1', then delete it.

# Retrieve ethernet networks available in HPE OneView
ethernet_networks = OneviewSDK::API300::Thunderbird::EthernetNetwork.find_by(@client, {})

# Network set creation
network_set = OneviewSDK::API300::Thunderbird::NetworkSet.new(@client)
network_set['name'] = 'NetworkSet_1'

# Adding until three ethernet networks to the network set
ethernet_networks.each_with_index { |ethernet, index| network_set.add_ethernet_network(ethernet) if index < 4 }

# Set first ethernet network as native network for network set
network_set.set_native_network(ethernet_networks.first) unless ethernet_networks.empty?

# Network set creation
network_set.create!
puts "\nThe network set with name='#{network_set['name']}' and uri='#{network_set['uri']}' was created!\n"
puts "- nativeNetworkUri='#{network_set['nativeNetworkUri']}'"
network_set['networkUris'].each { |network| puts "- networkUri='#{network}'" }

# Deletes network set
network_set.delete
puts "\nThe network set with name='#{network_set['name']}' and uri='#{network_set['uri']}' was deleted!\n"
