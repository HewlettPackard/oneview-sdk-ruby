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

# Supported APIs:
# - API200 for any
# - API300 for C7000
# - API300 for Synergy
# - API500 for C7000 (see /examples/api500/storage_pool.rb)
# - API500 for Synergy (see /examples/api500/storage_pool.rb)

# Resources that can be created according to parameters for StoragePool:
# api_version = 200 & variant = any to OneviewSDK::API200::StoragePool
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::StoragePool
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::StoragePool

# Resources that can be created according to parameters for StorageSystem:
# api_version = 200 & variant = any to OneviewSDK::API200::StorageSystem
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::StorageSystem
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::StorageSystem

# Resource Class used in this sample
storage_pool_class = OneviewSDK.resource_named('StoragePool', @client.api_version)
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

# Create storage pool
item = storage_pool_class.new(@client, options)
item.set_storage_system(storage_system)
item.add
puts "\nAdded #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

# verifying if storage pool exists
item_2 = storage_pool_class.new(@client, name: options[:poolName], storageSystemUri: storage_system['uri'])
result_exists = item_2.exists?
puts "\nVerifying if '#{item_2[:name]}' exists. Result: #{result_exists}"

# Retrieve created storage pool
item_2.retrieve!
puts "\nRetrieved #{type} by name: '#{item_2[:name]}'.\n  uri = '#{item_2[:uri]}'"

# Find recently created storage pool by name
matches = storage_pool_class.find_by(@client, name: item[:name])
item_3 = matches.first
puts "\nFound #{type} by name: '#{item_3[:name]}'.\n  uri = '#{item_3[:uri]}'"

item.remove
puts "\nRemoved #{type} '#{item[:name]}' successfully.\n"
