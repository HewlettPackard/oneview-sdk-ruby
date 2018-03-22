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

require_relative '../_client'

# NOTE: You'll need to add the following instance variable to the _client.rb file with valid values for your environment:
#   @storage_system_ip

# All supported APIs for Volume Template:
# - 200, 300, 500

raise 'Must set @storage_system_ip in _client.rb' unless @storage_system_ip

# Resources classes that you can use for Volume Template in this example:
# volume_template_class = OneviewSDK::API200::VolumeTemplate
# volume_template_class = OneviewSDK::API300::C7000::VolumeTemplate
# volume_template_class = OneviewSDK::API300::Synergy::VolumeTemplate
# volume_template_class = OneviewSDK::API500::C7000::VolumeTemplate
# volume_template_class = OneviewSDK::API500::Synergy::VolumeTemplate
# volume_template_class = OneviewSDK::API600::C7000::VolumeTemplate
# volume_template_class = OneviewSDK::API600::Synergy::VolumeTemplate

# Resources classes that you can use for Storage System in this example:
# storage_system_class = OneviewSDK::API200::StorageSystem
# storage_system_class = OneviewSDK::API300::C7000::StorageSystem
# storage_system_class = OneviewSDK::API300::Synergy::StorageSystem
# storage_system_class = OneviewSDK::API500::C7000::StorageSystem
# storage_system_class = OneviewSDK::API500::Synergy::StorageSystem
# storage_system_class = OneviewSDK::API600::C7000::StorageSystem
# storage_system_class = OneviewSDK::API600::Synergy::StorageSystem

# Resources classes that you can use for Storage Pool in this example:
# storage_pool_class = OneviewSDK::API200::StoragePool
# storage_pool_class = OneviewSDK::API300::C7000::StoragePool
# storage_pool_class = OneviewSDK::API300::Synergy::StoragePool
# storage_pool_class = OneviewSDK::API500::C7000::StoragePool
# storage_pool_class = OneviewSDK::API500::Synergy::StoragePool
# storage_pool_class = OneviewSDK::API600::C7000::StoragePool
# storage_pool_class = OneviewSDK::API600::Synergy::StoragePool

# Resource classses used in this sample
volume_template_class = OneviewSDK.resource_named('VolumeTemplate', @client.api_version)
storage_system_class = OneviewSDK.resource_named('StorageSystem', @client.api_version)
storage_pool_class = OneviewSDK.resource_named('StoragePool', @client.api_version)

options = {
  name: 'ONEVIEW_SDK_TEST VT1',
  description: 'Volume Template'
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

  puts "\nChanging the 'isShareable' property value"
  puts 'Before:'
  puts volume_template['properties']['isShareable']

  new_value = !volume_template.get_default_value('isShareable')
  volume_template.set_default_value('isShareable', new_value)
  volume_template.update
  volume_template.refresh
  puts 'After:'
  puts volume_template['properties']['isShareable']

  puts "\nChanging the locked property of 'isShareable'"
  puts 'Before:'
  puts volume_template['properties']['isShareable']['meta']

  volume_template.lock('isShareable')
  volume_template.update
  volume_template.refresh
  puts 'After:'
  puts volume_template['properties']['isShareable']['meta']
end

# Retrieve created volume template
volume_template_2 = volume_template_class.new(@client, name: options[:name])
volume_template_2.retrieve!
puts "\nRetrieved Volume Template by name: '#{volume_template_2[:name]}'.\n  uri = '#{volume_template_2[:uri]}'"

# Find recently created volume template by name
matches = volume_template_class.find_by(@client, name: options[:name])
volume_template_3 = matches.first
puts "\nFound Volume Template by name: '#{volume_template_3[:name]}'.\n  uri = '#{volume_template_3[:uri]}'"

# Delete Volume Template
volume_template.delete
puts "\nDeleted Volume Template '#{volume_template[:name]}' successfully.\n"
