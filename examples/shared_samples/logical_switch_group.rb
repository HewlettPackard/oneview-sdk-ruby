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

# Supported APIs:
# - API200 for C7000
# - API300 for C7000
# - API500 for C7000
# - API600 for C7000

# Resources that can be created according to parameters:
# api_version = 200 & variant = Any to OneviewSDK::LogicalSwitchGroup
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::LogicalSwitchGroup
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::LogicalSwitchGroup
# api_version = 600 & variant = C7000 to OneviewSDK::API600::C7000::LogicalSwitchGroup

# Resource Class used in this sample
logical_switch_group_class = OneviewSDK.resource_named('LogicalSwitchGroup', @client.api_version)

puts "\nPerforming example for #{logical_switch_group_class}"

# Example: Create an Logical Switch Group
options = {
  name:  'OneViewSDK Test Logical Switch Group',
  category:  'logical-switch-groups',
  state:  'Active'
}

# Creating a LSG
item = logical_switch_group_class.new(@client, options)

# Set the group parameters
item.set_grouping_parameters(2, 'Cisco Nexus 50xx')

# Effectively create the LSG
item.create!
puts "\nCreated logical-switch-group '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

sleep(10)

# Retrieves a logical-switch-group'
item2 = logical_switch_group_class.new(@client, name: 'OneViewSDK Test Logical Switch Group')
puts "\nRetrieving a logical-switch-group with name: '#{item[:name]}'."
item2.retrieve!
puts "\nRetrieved a logical-switch-group with name: '#{item[:name]}'.\n  uri = '#{item[:uri]}'"

# Updating the LSG
item2.set_grouping_parameters(1, 'Cisco Nexus 50xx')
item2.update(name: 'OneViewSDK Test Logical Switch Group Updated')
puts "\nUpdate logical-switch-group '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

sleep(10)

# NOTE: Scopes doesn't support versions smaller than 300.

if @client.api_version >= 300 && @client.api_version <= 500
  # Scopes
  scope_class = OneviewSDK.resource_named('Scope', @client.api_version)
  scope_1 = scope_class.new(@client, name: 'Scope 1')
  scope_1.create
  scope_2 = scope_class.new(@client, name: 'Scope 2')
  scope_2.create

  puts "\nAdding the '#{scope_1['name']}' with URI='#{scope_1['uri']}' in the logical switch group"
  item2.add_scope(scope_1)
  sleep(5)
  item2.retrieve!
  puts "Listing item2['scopeUris']:"
  puts item2['scopeUris'].to_s

  puts "\nReplacing scopes to '#{scope_1['name']}' with URI='#{scope_1['uri']}' and '#{scope_2['name']}' with URI='#{scope_2['uri']}'"
  item2.replace_scopes(scope_1, scope_2)
  sleep(5)
  item2.retrieve!
  puts "Listing item2['scopeUris']:"
  puts item2['scopeUris'].to_s

  puts "\nRemoving scope with URI='#{scope_1['uri']}' from the logical switch group"
  item2.remove_scope(scope_1)
  sleep(5)
  item2.retrieve!
  puts "Listing item2['scopeUris']:"
  puts item2['scopeUris'].to_s

  puts "\nRemoving scope with URI='#{scope_2['uri']}' from the logical switch group"
  item2.remove_scope(scope_2)
  sleep(5)
  item2.retrieve!
  puts "Listing item2['scopeUris']:"
  puts item2['scopeUris'].to_s

  # Delete the scopes
  scope_1.delete
  scope_2.delete
end

# Clean up
puts "\nRemoving the logical-switch-group."
item2.delete
puts "\nLogical-switch-group was removed successfully."
