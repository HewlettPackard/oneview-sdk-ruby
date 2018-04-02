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
# - 200, 300, 500, 600

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::Switch
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::Switch
# api_version = 300 & variant = Synergy to OneviewSDK::API300::C7000::Switch
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::Switch
# api_version = 500 & variant = Synergy to OneviewSDK::API500::C7000::Switch
# api_version = 600 & variant = C7000 to OneviewSDK::API600::C7000::Switch
# api_version = 600 & variant = Synergy to OneviewSDK::API600::C7000::Switch

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

# The statistics and environmental_configuration methods are only available to C7000 appliances..
if variant != 'Synergy'
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
  puts "\nStatistics for switch with name: #{item['name']}"
  puts stats

  # Getting the environmental configuration for switch
  puts "\nGetting the environmental configuration for switch"
  config = item.environmental_configuration
  puts "\nEnvironmental configuration for switch with name: #{item['name']}"
  puts config

  puts "\nUpdating the switch ports."
  begin
    # Getting a switch with unlinked ports
    item2 = switch_class.get_all(@client).find do |resource|
      !resource['ports'].select { |k| k['portStatus'] == 'Unlinked' }.empty?
    end
    port = item2['ports'].select { |k| k['portStatus'] == 'Unlinked' }.first
    old_enabled = port['enabled']
    enable_msg = port['enabled'] ? 'enabled' : 'disabled'
    puts "\nSwitch '#{item2['name']}' with port name '#{port['portName']}' is #{enable_msg}."
    item2.update_port(port['name'], enabled: !old_enabled)
    sleep(30)
    item2.retrieve!
    port_updated = item2['ports'].select { |k| k['portName'] == port['name'] }.first
    enable_msg = port_updated['enabled'] ? 'enabled' : 'disabled'
    puts "\nSwitch '#{item2['name']}' with port name '#{port['portName']}' is #{enable_msg}."
    puts "\nReturning to original state..."
    eth_options = {
      vlanId:  '1001',
      purpose:  'General',
      name:  'Ethernet Network for Switch',
      smartLink:  false,
      privateNetwork:  false,
      connectionTemplateUri: nil
    }
    eth = OneviewSDK.resource_named('EthernetNetwork', @client.api_version).new(@client, eth_options)
    eth.create
    eth.retrieve!
    item2.update_port(port['name'], enabled: old_enabled, associatedUplinkSetUri: eth['uri'])
    sleep(30)
    item2.retrieve!
    port_updated = item2['ports'].select { |k| k['portName'] == port['name'] }.first
    enable_msg = port_updated['enabled'] ? 'enabled' : 'disabled'
    puts "\nSwitch '#{item2['name']}' with port name '#{port['portName']}' is #{enable_msg}."
    # Delete the ethernet network created
    eth.delete
  rescue NoMethodError
    puts "\nUpdate ports operations is not supported in this version."
  end
end

# In these lines below is added, replaced and removed a scopeUri to the switch resource.
# A scope defines a collection of resources, which might be used for filtering or access control.
# When a scope uri is added to a switch resource, this resource is grouped into a resource(enclosure, server hardware, etc.) pool.
# Once grouped, with the scope it's possible to restrict an operation or action.
# For the switch resource, this feature is only available for C7000 and api version equal to 300.
if @client.api_version == 300 && variant == 'C7000'
  scope_class = OneviewSDK.resource_named('Scope', @client.api_version)

  item = switch_class.get_all(@client).first

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
