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

# NOTE: You'll need to add one StorageSystem before execute this sample
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#   @storage_system_ip

# All supported APIs for Storage Pool:
# - API200 for C7000 and Synergy
# - API300 for C7000 and Synergy
# - API500 for C7000 and Synergy

# Resources classes that you can use for StoragePool in this example:
# storage_pool_class = OneviewSDK::API200::StoragePool
# storage_pool_class = OneviewSDK::API300::C7000::StoragePool
# storage_pool_class = OneviewSDK::API300::Synergy::StoragePool
storage_pool_class = OneviewSDK.resource_named('StoragePool', @client.api_version)

# Resources classes that you can use for StorageSystem in this example:
# storage_system_class = OneviewSDK::API200::StorageSystem
# storage_system_class = OneviewSDK::API300::C7000::StorageSystem
# storage_system_class = OneviewSDK::API300::Synergy::StorageSystem
storage_system_class = OneviewSDK.resource_named('StorageSystem', @client.api_version)

type = 'storage pool'
options = {}

# Gather storage system information
storage_system = storage_system_class.new(@client, credentials: { ip_hostname: @storage_system_ip })
storage_system.retrieve! || raise("ERROR: Storage system at #{@storage_system_ip} not found!")
puts "Storage System uri = #{storage_system[:uri]}"
options[:storageSystemUri] = storage_system[:uri]
raise 'ERROR: No unmanaged pools available!' if storage_system[:unmanagedPools].empty?
pool = storage_system[:unmanagedPools].find { |storage_pool| storage_pool['domain'] == 'TestDomain' }
puts "Unmanaged pool name = #{pool['name']}"
options[:poolName] = pool['name']

if @client.api_version <= 300
  # Create storage pool
  item = storage_pool_class.new(@client, options)
  item.set_storage_system(storage_system)
  item.add
  puts "\nAdded #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"
end

# verifying if storage pool exists
item_2 = storage_pool_class.new(@client, name: options[:poolName], storageSystemUri: storage_system['uri'])
result_exists = item_2.exists?
puts "\nVerifying if '#{item_2[:name]}' exists. Result: #{result_exists}"

# Retrieve created storage pool
item_2.retrieve!
puts "\nRetrieved #{type} by name: '#{item_2[:name]}'.\n  uri = '#{item_2[:uri]}'"

storage_pool_class = OneviewSDK.resource_named('StoragePool', @client.api_version)
puts "\nListing the storage pools:"
list = storage_pool_class.get_all(@client)
puts list.map { |item_4| item_4['name'] } unless list.empty?

puts "\nReachable storage pools:"
list = storage_pool_class.reachable(@client)
puts list.map { |item_4| item_4['name'] } unless list.empty?

puts "\nChanging the storage pool to managed"
item_4 = storage_pool_class.find_by(@client, isManaged: false).first
puts 'Before:'
puts item_4.data
item_4.manage(true)
item_4.refresh
puts 'After:'
puts item_4.data

puts "\nRefreshing the storage system"
puts "Last refresh time: #{item_4['lastRefreshTime']}"
item_4.request_refresh
item_4.refresh
puts "Last refresh time: #{item_4['lastRefreshTime']}"

if @client.api_version <= 300
  # Find recently created storage pool by name
  matches = storage_pool_class.find_by(@client, name: item[:name])
  item_3 = matches.first
  puts "\nFound #{type} by name: '#{item_3[:name]}'.\n  uri = '#{item_3[:uri]}'"
  item.remove
  puts "\nRemoved #{type} '#{item[:name]}' successfully.\n"
end
