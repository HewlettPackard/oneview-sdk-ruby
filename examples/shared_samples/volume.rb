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

# NOTE: You'll need to add the following instance variable to the _client.rb file with valid values for your environment:
#   @storage_system_ip
#   @unmanaged_volume_wwn (optional)
# NOTE: This sample is for APIs 200 and 300 only. To see sample for API 500, look at the example volume.rb in the examples/api500 folder.
#
# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::Volume
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::Volume
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::Volume

# Resource Class used in this sample
volume_class = OneviewSDK.resource_named('Volume', @client.api_version)

# Extras Classes used in this sample
storage_system_class = OneviewSDK.resource_named('StorageSystem', @client.api_version)
storage_pool_class = OneviewSDK.resource_named('StoragePool', @client.api_version)
volume_template_class = OneviewSDK.resource_named('VolumeTemplate', @client.api_version)

puts '1) Common = Storage System + Storage Pool'

# Set Storage System
storage_system = storage_system_class.new(@client, credentials: { ip_hostname: @storage_system_ip })
storage_system.retrieve!

# Retrieve a Storage Pool
pools = storage_pool_class.find_by(@client, storageSystemUri: storage_system[:uri])
raise 'ERROR: No storage pools found attached to the provided storage system' if pools.empty?
storage_pool = pools.first

puts "\nCreating a volume with Storage System + Storage Pool..."

options1 = {
  name: 'ONEVIEW_SDK_TEST_VOLUME_1',
  description: 'Volume example',
  provisioningParameters: {
    provisionType: 'Thin',
    requestedCapacity: 1024 * 1024 * 1024
  }
}

item1 = volume_class.new(@client, options1)
item1.set_storage_system(storage_system)
item1.set_storage_pool(storage_pool)
item1.create
item1.retrieve!
puts "\nVolume created successfully! \nName: #{item1['name']} \nURI: #{item1['uri']}"

puts "\nCreating a volume with a volume template..."

options2 = {
  name: 'ONEVIEW_SDK_TEST_VOLUME_2',
  description: 'Volume example',
  provisioningParameters: {
    requestedCapacity: 1024 * 1024 * 1024
  }
}

volume_template = volume_template_class.get_all(@client).first
item2 = volume_class.new(@client, options2)
item2.set_storage_volume_template(volume_template)
item2.create
item2.retrieve!
puts "\nVolume created successfully! \nName: #{item2['name']} \nURI: #{item2['uri']}"

puts "\nCreating a volume with a snapshot pool specified..."

options3 = {
  name: 'ONEVIEW_SDK_TEST_VOLUME_3',
  description: 'Volume example',
  provisioningParameters: {
    provisionType: 'Thin',
    requestedCapacity: 1024 * 1024 * 1024
  }
}

item3 = volume_class.new(@client, options3)
item3.set_storage_system(storage_system)
item3.set_storage_pool(storage_pool)
item3.set_snapshot_pool(storage_pool)
item3.create
item3.retrieve!
puts "\nVolume created successfully! \nName: #{item3['name']} \nURI: #{item3['uri']}"

puts "\nCreating a snapshot..."
snapshot_name = 'ONEVIEW_SDK_TEST_VOLUME_3_SNAPSHOT'
item3.set_snapshot_pool(storage_pool)
item3.create_snapshot(snapshot_name)
puts "\nGetting the snapshot created by name"
snap = item3.get_snapshot(snapshot_name)
puts "\nSnaphot found: \n Name: #{snap['name']} \n URI: #{snap['uri']}"

puts "\nCreating a volume from a snapshot..."
options4 = {
  name: 'ONEVIEW_SDK_TEST_VOLUME_4',
  description: 'Volume example',
  snapshotUri: "#{item3[:uri]}/snapshots/#{snap['uri']}",
  provisioningParameters: {
    provisionType: 'Thin',
    requestedCapacity: 1024 * 1024 * 1024
  }
}

item4 = volume_class.new(@client, options4)
item4.set_storage_system(storage_system)
item4.set_storage_pool(storage_pool)
item4.create
item4.retrieve!
puts "\nVolume created successfully! \nName: #{item4['name']} \nURI: #{item4['uri']}"

if @unmanaged_volume_wwn
  puts "\nAdding a unmanaged volume wwn..."

  options5 = {
    name: 'ONEVIEW_SDK_TEST_VOLUME_5',
    description: 'Test volume - management creation: Storage System + wwn',
    wwn: @unmanaged_volume_wwn, # Need unmanaged volume
    provisioningParameters: {
      shareable: false
    }
  }

  item5 = volume_class.new(@client, options5)
  item5.set_storage_system(storage_system)
  item5.create
  item4.retrieve!
  puts "\nVolume added successfully! \nName: #{item5['name']} \nURI: #{item5['uri']}"
end

puts "\nUpdating the volume name"
old_name = item1['name']
item1.update(name: "#{old_name}_Updated")
item1.retrieve!
puts "\nVolume updated successfully! New name: #{item1['name']}."

puts "\nRemoving a snapshot..."
item3.delete_snapshot(snapshot_name)
puts "\nSnapshot removed successfully!"

puts "\nGetting the attachable volumes managed by the appliance"
query = {
  connections: '<Your parameters here>'
}
attachables = volume_class.get_attachable_volumes(@client, query)
puts "\nAttachable volumes found: #{attachables}"

puts "\nGetting the list of extra managed storage volume paths"
paths = volume_class.get_extra_managed_volume_paths(@client)
puts "\nExtra managed storage volume paths found: #{paths}"

puts "\nRemoving all volumes created in this sample..."
item1.delete
item2.delete
item3.delete
item4.delete
item5.delete(:oneview) if @unmanaged_volume_wwn # Removes only of the Oneview and keep on' the Storage System
puts "\nVolumes removed successfully!"
