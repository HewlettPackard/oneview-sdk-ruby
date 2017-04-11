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

# NOTE: It is needed have a Switch created previously.
#
# Supported APIs:
# - API200 for C7000
# - API300 for C7000
# - API300 for Synergy
# - API500 for C7000
# - API500 for Synergy

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::Switch
# api_version = 300 & variant = C7000 to switch_class
# api_version = 300 & variant = Synergy to switch_class
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::Switch
# api_version = 500 & variant = Synergy to OneviewSDK::API500::C7000::Switch

# Resource Class used in this sample
switch_class = OneviewSDK.resource_named('Switch', @client.api_version)

# Retrieves all switch types from the Appliance
switch_class.get_types(@client).each do |type|
  puts "Switch Type: #{type['name']}\nURI: #{type['uri']}\n\n"
end

# Retrieves switch type by name
item = switch_class.get_type(@client, 'Cisco Nexus 50xx')
puts "Switch Type by name: #{item['name']}\nURI: #{item['uri']}\n\n"

# Retrieves switch type by name
item = switch_class.get_type(@client, 'Cisco Nexus 50xx')
puts "Switch Type by name: #{item['name']}\nURI: #{item['uri']}\n\n"

variant = OneviewSDK.const_get("API#{@client.api_version}").variant unless @client.api_version < 300

if @client.api_version >= 300 && variant == 'C7000'
  # Listing all switches
  itens = switch_class.get_all(@client)
  puts "\nListing all switches"
  itens.each do |sw|
    puts sw['name']
  end

  item = itens.first

  # Getting the statistics for switch
  puts "\nGetting the statistics for switch"
  stats = item.statistics('')
  puts "\nStatistics for switch with name: #{item}"
  puts stats

  scope_class = OneviewSDK.resource_named('Scope', @client.api_version)

  # Create Scopes
  scope_1 = scope_class.new(@client, name: 'Scope 1')
  scope_1.create
  scope_2 = scope_class.new(@client, name: 'Scope 2')
  scope_2.create

  puts "\nAdding scopes"
  item.add_scope(scope_1)
  item.retrieve!
  puts 'Scopes:', item['scopeUris']

  puts "\nReplacing scopes"
  item.replace_scopes(scope_2)
  item.retrieve!
  puts 'Scopes:', item['scopeUris']

  puts "\nRemoving scopes"
  item.remove_scope(scope_1)
  item.remove_scope(scope_2)
  item.retrieve!
  puts 'Scopes:', item['scopeUris']

  # Delete scopes
  scope_1.delete
  scope_2.delete
end
