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

# Example: Create/Update/Delete ethernet networks
# NOTE: This will create an ethernet network named 'OneViewSDK Test Vlan', update it and then delete it.
#   It will create a bulk of ethernet networks and then delete them.
#
# Supported APIs:
# - API200 for C7000
# - API300 for C7000
# - API300 for Synergy
# - API500 for C7000
# - API500 for Synergy
# - API600 for C7000
# - API600 for Synergy

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::EthernetNetwork
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::EthernetNetwork
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::EthernetNetwork
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::EthernetNetwork
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::EthernetNetwork
# api_version = 600 & variant = C7000 to OneviewSDK::API600::C7000::EthernetNetwork
# api_version = 600 & variant = Synergy to OneviewSDK::API600::Synergy::EthernetNetwork

# Resource Class used in this sample
ethernet_class = OneviewSDK.resource_named('EthernetNetwork', @client.api_version)

# Scope class used in this sample
scope_class = OneviewSDK.resource_named('Scope', @client.api_version) unless @client.api_version.to_i <= 200

options = {
  vlanId:  '1001',
  purpose:  'General',
  name:  'OneViewSDK Test Vlan',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri: nil
}

# Creating a ethernet network
ethernet = ethernet_class.new(@client, options)
ethernet.create!
puts "\nCreated ethernet-network '#{ethernet[:name]}' sucessfully.\n  uri = '#{ethernet[:uri]}'"

# Find recently created network by name
matches = ethernet_class.find_by(@client, name: ethernet[:name])
ethernet2 = matches.first
puts "\nFound ethernet-network by name: '#{ethernet[:name]}'.\n  uri = '#{ethernet2[:uri]}'"

# Update purpose and smartLink settings from recently created network
attributes = {
  purpose: 'Management',
  smartLink: true
}
ethernet2.update(attributes)
puts "\nUpdated ethernet-network: '#{ethernet[:name]}'.\n  uri = '#{ethernet2[:uri]}'"
puts "with attributes: #{attributes}"

# Get associated profiles
puts "\nSuccessfully retrieved associated profiles: #{ethernet2.get_associated_profiles}"

# Get associated uplink groups
puts "\nSuccessfully retrieved associated uplink groups: #{ethernet2.get_associated_uplink_groups}"

# Retrieve recently created network
ethernet3 = ethernet_class.new(@client, name: ethernet[:name])
ethernet3.retrieve!
puts "\nRetrieved ethernet-network data by name: '#{ethernet[:name]}'.\n  uri = '#{ethernet3[:uri]}'"

# Example: List all ethernet networks with certain attributes
attributes = { purpose: 'Management' }
puts "\n\nEthernet networks with #{attributes}"
ethernet_class.find_by(@client, attributes).each do |network|
  puts "  #{network[:name]}"
end

# Bulk create ethernet networks
options = {
  vlanIdRange: '26-28',
  purpose: 'General',
  namePrefix: 'OneViewSDK_Bulk_Network',
  smartLink: false,
  privateNetwork: false,
  bandwidth: {
    maximumBandwidth: 10_000,
    typicalBandwidth: 2000
  }
}

list = ethernet_class.bulk_create(@client, options).each { |network| puts network['uri'] }

puts "\nBulk-created ethernet networks '#{options[:namePrefix]}_<x>' sucessfully."

list.sort_by! { |e| e['name'] }
list.each { |e| puts "  #{e['name']}" }

# only for API300 and API500, not supported for OneView 4.0 or greater
if @client.api_version.to_i > 200 && @client.api_version.to_i < 600
  scope_1 = scope_class.new(@client, name: 'Scope 1')
  scope_1.create!
  scope_2 = scope_class.new(@client, name: 'Scope 2')
  scope_2.create!

  puts "\nAdding scopes"
  ethernet.add_scope(scope_1)
  ethernet.refresh
  puts 'Scopes:', ethernet['scopeUris']

  puts "\nReplacing scopes"
  ethernet.replace_scopes(scope_2)
  ethernet.refresh
  puts 'Scopes:', ethernet['scopeUris']

  puts "\nRemoving scopes"
  ethernet.remove_scope(scope_1)
  ethernet.remove_scope(scope_2)
  ethernet.refresh
  puts 'Scopes:', ethernet['scopeUris']

  # Clear data
  scope_1.delete
  scope_2.delete
end

# Clean up
# Delete this network
ethernet2.delete
puts "\nSucessfully deleted ethernet-network '#{ethernet[:name]}'."

list.each(&:delete)
puts "\nDeleted all bulk-created ethernet networks sucessfully.\n"
