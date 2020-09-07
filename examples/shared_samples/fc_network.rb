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
# - 200, 300, 500, 600, 800, 1000, 1200, 1600, 1800, 2000
#
# Supported Variants
# C7000 and Synergy for all api versions


# Resource Class used in this sample
fc_network_class = OneviewSDK.resource_named('FCNetwork', @client.api_version)

# Scope class used in this sample
scope_class = OneviewSDK.resource_named('Scope', @client.api_version) unless @client.api_version.to_i <= 200

options = {
  name: 'OneViewSDK Test FC Network',
  connectionTemplateUri: nil,
  autoLoginRedistribution: true,
  fabricType: 'FabricAttach',
  initialScopeUris: [] # Add scope uris if required
}

fc = fc_network_class.new(@client, options)
fc.create!
puts "\nCreated fc-network '#{fc[:name]}' successfully.\n  uri = '#{fc[:uri]}'"

# Create 2 more FC networks
options['name'] = 'FC Network 2'
fc4 = fc_network_class.new(@client, options)
fc4.create!
puts "\nCreated fc-network '#{fc4[:name]}' successfully.\n  uri = '#{fc4[:uri]}'"

options['name'] = 'FC Network 3'
fc5 = fc_network_class.new(@client, options)
fc5.create!
puts "\nCreated fc-network '#{fc5[:name]}' successfully.\n  uri = '#{fc5[:uri]}'"

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
puts "\nSuccessfully deleted fc-network '#{fc3[:name]}'."

# Bulk-delete FC network
delete_networks = [fc4[:uri], fc5[:uri]]
bulk_options = { 'networkUris' => delete_networks }
fc_network_class.bulk_delete(@client, bulk_options)
puts "\nBulk deleted the fc networks successfully."
