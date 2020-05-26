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

# Example: Create/Update/Delete fc network
# NOTE: This will create an fc network named 'OneViewSDK Test FC Network', update it and then delete it.
#   It will create a bulk of fc networks and then delete them.
#
# Supported APIs:
# - API200 for C7000
# - API300 for C7000
# - API300 for Synergy
# - API500 for C7000
# - API500 for Synergy
# - API600 for C7000
# - API600 for Synergy
# - API800 for C7000
# - API800 for Synergy
# - API1000 for C7000
# - API1000 for Synergy
# - API1200 for C7000
# - API1200 for Synergy
# - API1600 for C7000
# - API1600 for Synergy
#
# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::FCNetwork
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::FCNetwork
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::FCNetwork
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::FCNetwork
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::FCNetwork
# api_version = 600 & variant = C7000 to OneviewSDK::API600::C7000::FCNetwork
# api_version = 600 & variant = Synergy to OneviewSDK::API600::Synergy::FCNetwork
# api_version = 800 & variant = C7000 to OneviewSDK::API800::C7000::FCNetwork
# api_version = 800 & variant = Synergy to OneviewSDK::API800::Synergy::FCNetwork
# api_version = 1000 & variant = C7000 to OneviewSDK::API1000::C7000::FCNetwork
# api_version = 1000 & variant = Synergy to OneviewSDK::API1000::Synergy::FCNetwork
# api_version = 1200 & variant = C7000 to OneviewSDK::API1200::C7000::FCNetwork
# api_version = 1200 & variant = Synergy to OneviewSDK::API1200::Synergy::FCNetwork
# api_version = 1600 & variant = C7000 to OneviewSDK::API1600::C7000::FCNetwork
# api_version = 1600 & variant = Synergy to OneviewSDK::API1600::Synergy::FCNetwork


# Resource Class used in this sample
fc_network_class = OneviewSDK.resource_named('FCNetwork', @client.api_version)

# Scope class used in this sample
scope_class = OneviewSDK.resource_named('Scope', @client.api_version) unless @client.api_version.to_i <= 200

options = {
  name: 'OneViewSDK Test FC Network',
  connectionTemplateUri: nil,
  autoLoginRedistribution: true,
  fabricType: 'FabricAttach',
  initialScopeUris: ['/rest/scopes/e025d93b-b08a-42cb-af56-b67a750c65b7', '/rest/scopes/92517890-87e4-47b5-9b33-ba78bd878293']
}

fc = fc_network_class.new(@client, options)
fc.create!
puts "\nCreated fc-network '#{fc[:name]}' sucessfully.\n  uri = '#{fc[:uri]}'"

# Find recently created network by name
matches = fc_network_class.find_by(@client, name: fc[:name])
fc2 = matches.first
puts "\nFound fc-network by name: '#{fc2[:name]}'.\n  uri = '#{fc2[:uri]}'"

# Retrieve recently created network
fc3 = fc_network_class.new(@client, name: fc[:name])
fc3.retrieve!
puts "\nRetrieved fc-network data by name: '#{fc3[:name]}'.\n  uri = '#{fc3[:uri]}'"

# Update autoLoginRedistribution from recently created network
attribute = { autoLoginRedistribution: false }
fc2.update(attribute)
puts "\nUpdated fc-network: '#{fc[:name]}'.\n  uri = '#{fc2[:uri]}'"
puts "with attribute: #{attribute}"

# Example: List all fc networks with certain attributes
attributes = { fabricType: 'FabricAttach' }
puts "\nFC networks with #{attributes}"
fc_network_class.find_by(@client, attributes).each do |network|
  puts "  #{network[:name]}"
end

# only for API300 and API500, not supported for OneView 4.0 or greater
if @client.api_version.to_i > 200 && @client.api_version.to_i < 600
  scope_1 = scope_class.new(@client, name: 'Scope 1')
  scope_1.create!
  scope_2 = scope_class.new(@client, name: 'Scope 2')
  scope_2.create!

  puts "\nAdding scopes"
  fc.add_scope(scope_1)
  fc.refresh
  puts 'Scopes:', fc['scopeUris']

  puts "\nReplacing scopes"
  fc.replace_scopes(scope_2)
  fc.refresh
  puts 'Scopes:', fc['scopeUris']

  puts "\nRemoving scopes"
  fc.remove_scope(scope_1)
  fc.remove_scope(scope_2)
  fc.refresh
  puts 'Scopes:', fc['scopeUris']

  # Clear data
  scope_1.delete
  scope_2.delete
end

# Delete this network
fc3.delete
puts "\nSucessfully deleted fc-network '#{fc3[:name]}'."
