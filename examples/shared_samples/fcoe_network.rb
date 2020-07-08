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

# Example: Create/Update/Delete ethernet networks
# NOTE: This will create an ethernet network named 'OneViewSDK Test FCoE Network', update it and then delete it.
#
# Supported APIs:
# - 200, 300, 500, 600, 800, 1000, 1200, 1600, 1800
#
# Supported Variants
# C7000 and Synergy for all api versions


# Resource Class used in this sample
fcoe_network_class = OneviewSDK.resource_named('FCoENetwork', @client.api_version)

# Scope class used in this sample
scope_class = OneviewSDK.resource_named('Scope', @client.api_version) unless @client.api_version.to_i <= 200

# Example: Create an fcoe network
# NOTE: This will create an fcoe network named 'OneViewSDK Test FCoE Network', then delete it.
options = {
  name: 'OneViewSDK Test FCoE Network',
  connectionTemplateUri: nil,
  vlanId: 300
}

# Sucess case - 1
fcoe = fcoe_network_class.new(@client, options)
fcoe.create!
puts "\nCreated fcoe-network '#{fcoe[:name]}' sucessfully.\n  uri = '#{fcoe[:uri]}'"

# Create 2 more fcoe networks
options['name'] = 'FCoE network2'
fcoe4 = fcoe_network_class.new(@client, options)
fcoe4.create!
puts "\nCreated fcoe-network '#{fcoe4[:name]}' sucessfully.\n  uri = '#{fcoe4[:uri]}'"

options['name'] = 'FCoE network3'
fcoe5 = fcoe_network_class.new(@client, options)
fcoe5.create!
puts "\nCreated fcoe-network '#{fcoe5[:name]}' sucessfully.\n  uri = '#{fcoe5[:uri]}'"

# Find recently created network by name
matches = fcoe_network_class.find_by(@client, name: fcoe[:name])
fcoe2 = matches.first
puts "\nFound fcoe-network by name: '#{fcoe2[:name]}'.\n  uri = '#{fcoe2[:uri]}'"

# Retrieve recently created network
fcoe3 = fcoe_network_class.new(@client, name: fcoe[:name])
fcoe3.retrieve!
puts "\nRetrieved fcoe-network data by name: '#{fcoe3[:name]}'.\n  uri = '#{fcoe3[:uri]}'"

# Example: List all fcoe networks with certain attributes
attributes = { status: 'OK' }
puts "\n\nFCoE networks with #{attributes}"
fcoe_network_class.find_by(@client, attributes).each do |network|
  puts "  #{network[:name]}"
end

# only for API300 and API500, not supported for OneView 4.0 or greater
if @client.api_version.to_i > 200 && @client.api_version.to_i < 600
  scope_1 = scope_class.new(@client, name: 'Scope 1')
  scope_1.create!
  scope_2 = scope_class.new(@client, name: 'Scope 2')
  scope_2.create!

  puts "\nAdding scopes"
  fcoe.add_scope(scope_1)
  fcoe.refresh
  puts 'Scopes:', fcoe['scopeUris']

  puts "\nReplacing scopes"
  fcoe.replace_scopes(scope_2)
  fcoe.refresh
  puts 'Scopes:', fcoe['scopeUris']

  puts "\nRemoving scopes"
  fcoe.remove_scope(scope_1)
  fcoe.remove_scope(scope_2)
  fcoe.refresh
  puts 'Scopes:', fcoe['scopeUris']

  # Clear data
  scope_1.delete
  scope_2.delete
end

# Delete this network
fcoe3.delete
puts "\nSucessfully deleted fc-network '#{fcoe3[:name]}'."

# Bulk-delete FC network
delete_networks = [fcoe4[:uri], fcoe5[:uri]]
bulk_options = { 'networkUris' => delete_networks }
fcoe_network_class.bulk_delete(@client, bulk_options)
puts "\nBulk deleted the fcoe networks sucessfully."
