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

# All supported APIs for Storage Pool:
# - API200 for C7000 and Synergy (see /examples/shared_samples/storage_pool.rb)
# - API300 for C7000 and Synergy (see /examples/shared_samples/storage_pool.rb)
# - API500 for C7000 and Synergy

# Resources classes that you can use for StoragePool in this example:
# storage_pool_class = OneviewSDK::API500::C7000::StoragePool
# storage_pool_class = OneviewSDK::API500::Synergy::StoragePool
storage_pool_class = OneviewSDK.resource_named('StoragePool', @client.api_version)

puts "\nListing the storage pools:"
list = storage_pool_class.get_all(@client)
puts list.map { |item| item['name'] } unless list.empty?

puts "\nReachable storage pools:"
list = storage_pool_class.reachable(@client)
puts list.map { |item| item['name'] } unless list.empty?

puts "\nChanging the storage pool to managed"
item = storage_pool_class.find_by(@client, isManaged: false).first
puts 'Before:'
puts item.data
item.manage(true)
item.refresh
puts 'After:'
puts item.data

puts "\nRefreshing the storage system"
puts "Last refresh time: #{item['lastRefreshTime']}"
item.request_refresh
item.refresh
puts "Last refresh time: #{item['lastRefreshTime']}"
