require_relative '_client'

# Example: Create Volumes from the creation mehtods
# NOTE: This will use a few volume systems and create 6 volumes, one for each creation type

# 1) Common = Storage System + Storage Pool
puts '1) Common = Storage System + Storage Pool'

options1 = {
  name: 'ONEVIEW_SDK_TEST_VOLUME_1',
  description: 'Test volume with common creation: Storage System + Storage Pool'
}

volume1 = OneviewSDK::Volume.new(@client, options1)

storage_system = OneviewSDK::StorageSystem.new(@client, credentials: { ip_hostname: '172.18.11.11' })
storage_system.retrieve!

volume1.add_storage_system(storage_system)

# Create storage pool
options_pool = {
  storageSystemUri: storage_system[:uri],
  name: 'FST_CPG1'
}

storage_pool = OneviewSDK::StoragePool.new(@client, options_pool)
storage_pool.set_storage_system(storage_system)
storage_pool.retrieve!

volume1.add_storage_pool(storage_pool)

volume1.set_provision_type # Full
volume1.set_shareable # shareable
volume1.set_requested_capacity(512 * 1024 * 1024) # 512MB

volume1.create!
puts "Created #{volume1['name']}"


# 2) Template = Storage Volume Template
# CANNOT IMPLEMENT: Missing Storage Volume Templates resource
puts '2) Template = Storage Volume Template'
puts 'Need Storage Volume Template'


# 3) Common with snapshots = Storage System + Storage Pool + Snapshot Pool
puts '3) Common with snapshots = Storage System + Storage Pool + Snapshot Pool'

options3 = {
  name: 'ONEVIEW_SDK_TEST_VOLUME_3',
  description: 'Test volume - common creation with snapshot pool: Storage System + Storage Pool + Snapshot Pool'
}

volume3 = OneviewSDK::Volume.new(@client, options3)

volume3.add_storage_system(storage_system)

# Provisioning Parameters
volume3.add_storage_pool(storage_pool)
volume3.set_provision_type('Thin')
volume3.set_shareable(false) # private
volume3.set_requested_capacity(1024 * 1024 * 1024) # 1GB

# The same snapshot pool of the storage pool
volume3.add_snapshot_pool(storage_pool)

volume3.create!
puts "Created #{volume3['name']}"


# 4) Management = Storage System + wwn
puts '4) Management = Storage System + wwn'

options4 = {
  name: 'ONEVIEW_SDK_TEST_VOLUME_4',
  description: 'Test volume - management creation: Storage System + wwn',
  wwn: 'DC:83:80:27:56:00:10:00:30:71:45:02:08:86:41:52' # Need unmanaged volume
}

volume4 = OneviewSDK::Volume.new(@client, options4)

volume4.add_storage_system(storage_system)

# Provisioning Parameters
volume4.set_shareable(false) # private

volume4.create!
puts "Created #{volume4['name']}"


puts 'Clean up...'
volume1.delete
# volume2.delete
volume3.delete
volume4.delete

puts 'Clean up complete!'
