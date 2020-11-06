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

require_relative '../_client'

# NOTE: You'll need to add the following instance variable to the _client.rb file with valid values for your environment:
#   @storage_system_ip

raise 'Must set @storage_system_ip in _client.rb' unless @storage_system_ip

# Supported Variants for Storage System, Storage Pool and Volume Attachment
# - C7000 and Synergy for all API versions

# Resource classses used in this sample
volume_template_class = OneviewSDK.resource_named('VolumeTemplate', @client.api_version)
storage_system_class = OneviewSDK.resource_named('StorageSystem', @client.api_version)
storage_pool_class = OneviewSDK.resource_named('StoragePool', @client.api_version)
scope_class = OneviewSDK.resource_named('Scope', @client.api_version)
fc_network_class = OneviewSDK.resource_named('FCNetwork', @client.api_version)

scope = scope_class.get_all(@client).first
fc_network = fc_network_class.get_all(@client).first

options = {
  name: 'ONEVIEW_SDK_TEST VT1',
  description: 'Volume Template',
  initialScopeUris: [scope['uri']]
}

puts "\nCreating a Storage Volume Template"

if @client.api_version < 500
  # Retrieve storage pool and storage system
  storage_pool = storage_pool_class.find_by(@client, {}).first
  raise 'ERROR: No storage pools found!' unless storage_pool
  storage_system = storage_system_class.find_by(@client, credentials: { ip_hostname: @storage_system_ip }).first
  raise "ERROR: Storage System #{@storage_system_ip} not found!" unless storage_system

  # Create Volume Template
  volume_template = volume_template_class.new(@client, options)
  volume_template.set_provisioning(true, 'Thin', '10737418240', storage_pool)
  volume_template.set_snapshot_pool(storage_pool)
  volume_template.set_storage_system(storage_system)
  volume_template.create
  puts "\nCreated Volume Template '#{volume_template[:name]}' sucessfully.\n  uri = '#{volume_template[:uri]}'"

  # Get connectable volume templates
  puts "\nSuccessfully retrieved connectable volume templates: #{volume_template.get_connectable_volume_templates}"
else
  storage_pool = storage_pool_class.get_all(@client).find { |i| i['isManaged'] }
  root_template = volume_template_class.get_all(@client).first

  # Create Volume Template
  volume_template = volume_template_class.new(@client, options)
  volume_template.set_root_template(root_template)
  volume_template.set_default_value('storagePool', storage_pool)
  volume_template.create
  puts "\nSuccessfully created"

  puts "\nListing compatible storage systems:"
  volume_template.get_compatible_systems.each { |item| puts item['name'] }

  puts "\nListing reachable volume templates:"
  volume_template_class.get_reachable_volume_templates(@client).each { |item| puts item['name'] }

  query_networks = {
    networks: fc_network['uri']
  }
  puts "\nListing reachable volume templates with networks '#{query_networks[:networks]}'"
  volume_template_class.get_reachable_volume_templates(@client, {}, query_networks).each { |item| puts item['name'] }

  if @client.api_version >= 600
    query_scopes = {
      scopeUris: scope['uri']
    }
    puts "\nListing reachable volume templates with scope '#{query_scopes[:scopeUris]}'"
    volume_template_class.get_reachable_volume_templates(@client, {}, query_scopes).each { |item| puts item['name'] }

    query_private_volumes = {
      privateAllowedOnly: true
    }
    puts "\nListing reachable volume templates with only private volumes '#{query_private_volumes[:privateAllowedOnly]}'"
    volume_template_class.get_reachable_volume_templates(@client, {}, query_private_volumes).each { |item| puts item['name'] }
  end
  volume_template_2 = volume_template_class.new(@client, name: options[:name])
  volume_template_2.retrieve!
  puts "\nChanging the 'isShareaitem2ble' property value"
  puts 'Before:'
  puts volume_template_2['properties']['isShareable']

  new_value = !volume_template_2.get_default_value('isShareable')
  volume_template_2.set_default_value('isShareable', new_value)
  volume_template_2.update
  volume_template_2.retrieve!
  puts 'After:'
  puts volume_template_2['properties']['isShareable']

  puts "\nChanging the locked property of 'isShareable'"
  puts 'Before:'
  puts volume_template_2['properties']['isShareable']['meta']

  volume_template_2.lock('isShareable')
  volume_template_2.update
  volume_template_2.retrieve!
  puts 'After:'
  puts volume_template_2['properties']['isShareable']['meta']
end

# Retrieve created volume template
volume_template_3 = volume_template_class.new(@client, name: options[:name])
volume_template_3.retrieve!
puts "\nRetrieved Volume Template by name: '#{volume_template_3[:name]}'.\n  uri = '#{volume_template_3[:uri]}'"

# Find recently created volume template by name
matches = volume_template_class.find_by(@client, name: options[:name])
volume_template_4 = matches.first
puts "\nFound Volume Template by name: '#{volume_template_4[:name]}'.\n  uri = '#{volume_template_4[:uri]}'"

# Delete Volume Template
# volume_template.retrieve!
# volume_template.delete
# puts "\nDeleted Volume Template '#{volume_template[:name]}' successfully.\n"
