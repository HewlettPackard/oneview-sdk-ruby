# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '_client'

# Example: Create a storage pool
# NOTE: This will create a storage pool, then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#   @storage_system_ip

fail 'ERROR: Must set @storage_system_ip in _client.rb' unless @storage_system_ip

type = 'storage pool'
options = {}

# Gather storage system information
storage_system = OneviewSDK::StorageSystem.new(@client, credentials: { ip_hostname: @storage_system_ip })
storage_system.retrieve! || fail("ERROR: Storage system at #{@storage_system_ip} not found!")
puts "Storage System uri = #{storage_system[:uri]}"
options[:storageSystemUri] = storage_system[:uri]
fail 'ERROR: No unmanaged pools available!' unless storage_system[:unmanagedPools].size > 0
pool = storage_system[:unmanagedPools].find { |storage_pool| storage_pool['domain'] == 'TestDomain' }
puts "Unmanaged pool name = #{pool['name']}"
options[:poolName] = pool['name']

# Create storage pool
item = OneviewSDK::StoragePool.new(@client, options)
item.set_storage_system(storage_system)
item.add
puts "\nAdded #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

# Retrieve created storage pool
item_2 = OneviewSDK::StoragePool.new(@client, name: options[:poolName])
item_2.retrieve!
puts "\nRetrieved #{type} by name: '#{item_2[:name]}'.\n  uri = '#{item_2[:uri]}'"

# Find recently created storage pool by name
matches = OneviewSDK::StoragePool.find_by(@client, name: item[:name])
item_3 = matches.first
puts "\nFound #{type} by name: '#{item_3[:name]}'.\n  uri = '#{item_3[:uri]}'"

item.remove
puts "\nRemoved #{type} '#{item[:name]}' successfully.\n"
