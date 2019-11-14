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
#   @storage_virtual_ip
# NOTE: This sample is for API 600 only. To see sample for previous APIs, look at:
#   example volume.rb in the shared_examples folder for api300 and below.
#   example volume.rb in the api500 folder for api500.
#
# Resources that can be created according to parameters:
# api_version = 600 & variant = C7000 to OneviewSDK::API600::C7000::Volume
# api_version = 600 & variant = Synergy to OneviewSDK::API600::Synergy::Volume

# Resource Class used in this sample
volume_class = OneviewSDK.resource_named('Volume', @client.api_version)

# Extras Classes used in this sample
storage_system_class = OneviewSDK.resource_named('StorageSystem', @client.api_version)
storage_pool_class = OneviewSDK.resource_named('StoragePool', @client.api_version)
volume_template_class = OneviewSDK.resource_named('VolumeTemplate', @client.api_version)

# Network class for getting volumes by query parameter connections
# Use Fc networks, Fcoe networks based on your requirement.
ethernet_class = OneviewSDK.resource_named('EthernetNetwork', @client.api_version)

# Set Storage System
storage_system = storage_system_class.new(@client, hostname: @storage_system_ip)
storage_system.retrieve!

# Retrieve a Storage Pool
pools = storage_pool_class.find_by(@client, storageSystemUri: storage_system[:uri], isManaged: true)
raise 'ERROR: No storage pools found attached to the provided storage system' if pools.empty?
storage_pool = pools.first

puts "\nCreating a volume with a Storage Pool..."

options1 = {
  properties: {
    name: 'ONEVIEW_SDK_TEST_VOLUME_1',
    description: 'Volume store serv',
    size: 1024 * 1024 * 1024,
    provisioningType: 'Thin',
    isShareable: false
  }
}

item1 = volume_class.new(@client, options1)
item1.set_storage_pool(storage_pool)
item1.create
item1.retrieve!
puts "\nVolume created successfully! \nName: #{item1['name']} \nURI: #{item1['uri']}"

puts "\nCreating a volume with a volume template..."

options2 = {
  properties: {
    name: 'ONEVIEW_SDK_TEST_VOLUME_2',
    description: 'Volume store serv',
    size: 1024 * 1024 * 1024,
    provisioningType: 'Thin',
    isShareable: false
  }
}

volume_template = volume_template_class.find_by(@client, storagePoolUri: storage_pool['uri']).first
item2 = volume_class.new(@client, options2)
item2.set_storage_pool(storage_pool)
item2.set_storage_volume_template(volume_template)
item2.create
item2.retrieve!
puts "\nVolume created successfully! \nName: #{item2['name']} \nURI: #{item2['uri']}"

puts "\nCreating a volume with a snapshot pool specified..."

options3 = {
  properties: {
    name: 'ONEVIEW_SDK_TEST_VOLUME_3',
    description: 'Volume store serv',
    size: 1024 * 1024 * 1024,
    provisioningType: 'Thin',
    isShareable: false
  }
}

item3 = volume_class.new(@client, options3)
item3.set_storage_pool(storage_pool)
item3.set_snapshot_pool(storage_pool)
item3.set_storage_volume_template(volume_template)
item3.create
item3.retrieve!
puts "\nVolume created successfully! \nName: #{item3['name']} \nURI: #{item3['uri']}"

puts "\nCreating a snapshot..."
snapshot_name = 'ONEVIEW_SDK_TEST_VOLUME_3_SNAPSHOT'
item3.set_snapshot_pool(storage_pool)
item3.create_snapshot(snapshot_name)
puts "\nGetting the snapshot created by name"
snap = item3.get_snapshot(snapshot_name)
puts "\nSnapshot found: \n Name: #{snap['name']} \n URI: #{snap['uri']}"

puts "\nCreating a volume from a snapshot..."
properties = {
  'provisioningType' => 'Thin',
  'name' => 'ONEVIEW_SDK_TEST_VOLUME_4',
  'isShareable' => false
}

item4 = item3.create_from_snapshot(snapshot_name, properties, volume_template)
item4.retrieve!
puts "\nVolume created successfully! \nName: #{item4['name']} \nURI: #{item4['uri']}"

puts "\nRemoving a volume only from Oneview and maintaining  on the Storage System"
device_volume = item1['deviceVolumeName']
item1.delete(:oneview)
puts "\nVolume removed successfully!"

puts "\nAdding a unmanaged volume..."

options5 = {
  name: 'ONEVIEW_SDK_TEST_VOLUME_5',
  description: 'Volume added',
  deviceVolumeName: device_volume,
  isShareable: false,
  storageSystemUri: storage_system['uri']
}

item5 = volume_class.new(@client, options5)
item5.add
puts "\nVolume added successfully! \nName: #{item5['name']} \nURI: #{item5['uri']}"

puts "\nCreating a volume from Storage Virtual..."

options6 = {
  properties: {
    name: 'ONEVIEW_SDK_TEST_VOLUME_VIRTUAL_1',
    description: 'Volume store virtual',
    size: 1024 * 1024 * 1024,
    provisioningType: 'Thin',
    isShareable: false,
    dataProtectionLevel: 'NetworkRaid10Mirror2Way'
  }
}

storage_virtual = storage_system_class.find_by(@client, hostname: @store_virtual_ip).first
storage_virtual_pool = storage_pool_class.find_by(@client, storageSystemUri: storage_virtual['uri'], isManaged: true).first
vol_template_virtual = volume_template_class.find_by(@client, storagePoolUri: storage_virtual_pool['uri']).first

item6 = volume_class.new(@client, options6)
item6.set_storage_pool(storage_virtual_pool)
item6.set_storage_volume_template(vol_template_virtual)
item6.create
puts "\nVolume added successfully! \nName: #{item6['name']} \nURI: #{item6['uri']}"

puts "\nUpdating the volume name"
old_name = item2['name']
item2.update(name: "#{old_name}_Updated")
item2.retrieve!
puts "\nVolume updated successfully! New name: #{item2['name']}."

puts "\nRemoving a snapshot..."
item3.retrieve!
item3.delete_snapshot(snapshot_name)
puts "\nSnapshot removed successfully!"

puts "\nGetting the attachable volumes managed by the appliance"
attachables = volume_class.get_attachable_volumes(@client)
puts "\nAttachable volumes found: #{attachables}"

# Getting volumes by query parameter connections
networks = ethernet_class.find_by(@client, {})

puts "\n Getting the attachable volumes managed by the applicance by connections"
query = {
  connections: {
    networkUri: networks.first['uri']
  }
}
attachables_connections = volume_class.get_all_with_query(@client, query)
puts "\nAttachable volumes found: #{attachables_connections}"

puts "\nGetting the list of extra managed storage volume paths"
paths = volume_class.get_extra_managed_volume_paths(@client)
puts "\nExtra managed storage volume paths found: #{paths}"

puts "Remove extra presentations from the specified volume on the storage system: \nURI: #{paths['uri']}"
item2.repair
puts "\nExtra managed storage volume paths has been repaired"

puts "\nRemoving all volumes created in this sample..."
item2.delete
item3.delete
item4.delete
item5.delete
item6.delete
puts "\nVolumes removed successfully!"
