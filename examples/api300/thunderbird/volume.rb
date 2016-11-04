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

require_relative '../../_client'


# Example: Create Volumes from the creation mehtods
# NOTE: This will use a few volume systems and create 6 volumes, one for each creation type
# NOTE: You'll need to add the following instance variable to the _client.rb file with valid values for your environment:
#   @storage_system_ip
#   @unmanaged_volume_wwn (optional)

raise 'Must set @storage_system_ip in _client.rb' unless @storage_system_ip

# 1) Common = Storage System + Storage Pool
puts '1) Common = Storage System + Storage Pool'

binding.pry

# Set Storage System
storage_system = OneviewSDK::API300::Thunderbird::StorageSystem.new(@client, credentials: { ip_hostname: @storage_system_ip })
storage_system.retrieve!

# Retrieve a Storage Pool
pools = OneviewSDK::API300::Thunderbird::StoragePool.find_by(@client, storageSystemUri: storage_system[:uri])
raise 'ERROR: No storage pools found attached to the provided storage system' if pools.empty?
storage_pool = pools.first

options1 = {
  name: 'ONEVIEW_SDK_TEST_VOLUME_1',
  description: 'Test volume with common creation: Storage System + Storage Pool',
  provisioningParameters: {
    provisionType: 'Full',
    shareable: true,
    requestedCapacity: 1024 * 1024 * 1024,
    storagePoolUri: storage_pool['uri']
  }
}

volume1 = OneviewSDK::API300::Thunderbird::Volume.new(@client, options1)
volume1.set_storage_system(storage_system)

volume1.create!
puts "  Created #{volume1['name']}"

# 3) Common with snapshots = Storage System + Storage Pool + Snapshot Pool
puts '3) Common with snapshots = Storage System + Storage Pool + Snapshot Pool'

options3 = {
  name: 'ONEVIEW_SDK_TEST_VOLUME_3',
  description: 'Test volume - common creation with snapshot pool: Storage System + Storage Pool + Snapshot Pool',
  provisioningParameters: {
    storagePoolUri: storage_pool['uri'],
    provisionType: 'Full',
    shareable: true,
    requestedCapacity: 1024 * 1024 * 1024 # 1GB
  }
}

volume3 = OneviewSDK::API300::Thunderbird::Volume.new(@client, options3)

volume3.set_storage_system(storage_system)
volume3.set_snapshot_pool(storage_pool) # The same snapshot pool of the storage pool

volume3.create!
puts "  Created #{volume3['name']}"

# Create volume snapshot:
volume3.create_snapshot(type: 'Snapshot', name: '{volumeName}_{timestamp}', description: 'New snapshot')
puts "  Created snapshot on #{volume3['name']}"

if @unmanaged_volume_wwn
  # 4) Management = Storage System + wwn
  puts '4) Management = Storage System + wwn'

  options4 = {
    name: 'ONEVIEW_SDK_TEST_VOLUME_4',
    description: 'Test volume - management creation: Storage System + wwn',
    wwn: @unmanaged_volume_wwn, # Need unmanaged volume
    shareable: false
  }

  volume4 = OneviewSDK::API300::Thunderbird::Volume.new(@client, options4)
  volume4.set_storage_system(storage_system)

  volume4.create!
  puts "Created #{volume4['name']}"
end

puts 'Cleaning up...'
volume1.delete
volume3.delete_snapshot(volume3.get_snapshots.first['name'])
volume3.delete
volume4.delete if @unmanaged_volume_wwn
puts 'Clean up complete!'
