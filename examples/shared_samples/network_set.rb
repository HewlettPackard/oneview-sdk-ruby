# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

# Example: Create/Update/Delete networks set
# NOTE: This will create a network set named 'NetworkSet_1', update it and then delete it.
# PRE-REQUISITE:Tagged ethernet networks should be created.
#
# Supported APIs:
# - 200, 300, 500, 600, 800, 1000, 1200, 1600, 1800

# Supported variants:
# - C7000 and Synergy for all api versions


# Resource Class used in this sample
network_set_class = OneviewSDK.resource_named('NetworkSet', @client.api_version)

# EthernetNetwork class used in this sample
ethernet_class = OneviewSDK.resource_named('EthernetNetwork', @client.api_version)

# Retrieve ethernet networks available in HPE OneView
ethernet_networks = ethernet_class.find_by(@client, {})
network_set_name = 'NetworkSet_1'

puts "\nCreating a network set with name = #{network_set_name}"
# Network set creation
network_set = network_set_class.new(@client, name: network_set_name)

# Adding until three ethernet networks to the network set
ethernet_networks.each_with_index { |ethernet, index| network_set.add_ethernet_network(ethernet) if index < 4 }

# Set first ethernet network as native network for network set
network_set.set_native_network(ethernet_networks.first) unless ethernet_networks.empty?

# Network set creation
network_set.create!
puts "\nThe network set with name='#{network_set['name']}' and uri='#{network_set['uri']}' was created!\n"
puts "- nativeNetworkUri='#{network_set['nativeNetworkUri']}'"
network_set['networkUris'].each { |network| puts "- networkUri='#{network}'" }

# Updating a network set
puts "\nUpdating the name of a network set with name = #{network_set['name']} and uri = #{network_set['uri']}"
network_set['name'] = "#{network_set_name}_Updated"
network_set.update
network_set.retrieve!
puts "\nNetwork set with uri = #{network_set['uri']} updated successfully and new name = #{network_set['name']}"

# Returning to original state
puts "\nReturning to original name"
network_set['name'] = network_set_name
network_set.update
network_set.retrieve!
puts "\nNetwork set with uri = #{network_set['uri']} and new name = #{network_set['name']} updated successfully."

# Adding an ethernet network
eth = ethernet_networks.last unless ethernet_networks.empty?
puts "\nAdding an ethernet network with uri = #{eth['uri']} for network_set"
network_set.add_ethernet_network(eth) unless ethernet_networks.empty?
puts "\nListing the ethernet networks:"
network_set['networkUris'].each { |network| puts "- networkUri='#{network}'" }

# Removing an ethernet network
puts "\nRemoving an ethernet network with uri = #{eth['uri']} for network_set"
network_set.remove_ethernet_network(eth) unless ethernet_networks.empty?
puts "\nListing the ethernet networks:"
network_set['networkUris'].each { |network| puts "- networkUri='#{network}'" }

# only for API300 and API500
if @client.api_version.to_i >= 300 && @client.api_version.to_i <= 500
  # Scope class used in this sample
  scope_class = OneviewSDK.resource_named('Scope', @client.api_version)

  scope_1 = scope_class.new(@client, name: 'Scope 1')
  scope_1.create!
  scope_2 = scope_class.new(@client, name: 'Scope 2')
  scope_2.create!

  puts "\nAdding scopes"
  network_set.add_scope(scope_1)
  network_set.refresh
  puts 'Scopes:', network_set['scopeUris']

  puts "\nReplacing scopes"
  network_set.replace_scopes(scope_2)
  network_set.refresh
  puts 'Scopes:', network_set['scopeUris']

  puts "\nRemoving scopes"
  network_set.remove_scope(scope_1)
  network_set.remove_scope(scope_2)
  network_set.refresh
  puts 'Scopes:', network_set['scopeUris']

  # Clear data
  scope_1.delete
  scope_2.delete
end

# Clean up
# Deletes network set
puts "\nDeletes network set with name='#{network_set['name']}' and uri='#{network_set['uri']}."
network_set.delete
puts "\nThe network set with name='#{network_set['name']}' and uri='#{network_set['uri']}' was deleted!\n"
