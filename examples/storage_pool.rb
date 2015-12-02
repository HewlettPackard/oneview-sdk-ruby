require_relative '_client'

options = {
  poolName: 'FST_CPG1',
  storageSystemUri: '/rest/storage-systems/TXQ1000307'
}

storage_system = OneviewSDK::StorageSystem.new(@client, credentials: { ip_hostname: '172.18.11.11' })
storage_system.retrieve!
puts "Storage System uri=#{storage_system[:uri]}"

storage_pool = OneviewSDK::StoragePool.new(@client, options)
storage_pool.set_storage_system(storage_system)
storage_pool.create
puts "\nCreated storage-pool '#{storage_pool[:name]}' sucessfully.\n  uri = '#{storage_pool[:uri]}'"


# Retrieve created storage pool
storage_pool_2 = OneviewSDK::StoragePool.new(@client, name: 'FST_CPG1')
storage_pool_2.retrieve!
puts "\nRetrieved storage-pool by name: '#{storage_pool_2[:name]}'.\n  uri = '#{storage_pool_2[:uri]}'"


# Find recently created storage pool by name
matches = OneviewSDK::StoragePool.find_by(@client, name: storage_pool[:name])
storage_pool_3 = matches.first
puts "\nFound ethernet-network by name: '#{storage_pool_3[:name]}'.\n  uri = '#{storage_pool_3[:uri]}'"

storage_pool.delete
puts "\nDeleted storage-pool '#{storage_pool[:name]}' successfully.\n"
