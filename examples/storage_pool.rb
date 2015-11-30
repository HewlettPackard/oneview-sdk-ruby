require_relative '_client'

=begin
options = {
  poolName: 'FST_CPG1',
  storageSystemUri: '/rest/storage-systems/TXQ1000307'
}

storage_pool = OneviewSDK::StoragePool.new(@client, options)
storage_pool.create
puts "\nCreated storage-pool '#{storage_pool[:name]}' sucessfully.\n  uri = '#{storage_pool[:uri]}'"

# Find recently created storage pool by name
matches = OneviewSDK::StoragePool.find_by(@client, name: storage_pool[:name])
storage_pool_2 = matches.first
puts "\nFound ethernet-network by name: '#{storage_pool_2[:name]}'.\n  uri = '#{storage_pool_2[:uri]}'"

storage_pool.delete
puts "\nDeleted storage-pool '#{storage_pool[:name]}' successfully.\n"
=end

options = {
  poolName: 'FST_CPG1',
  storageSystemUri: '/rest/storage-systems/TXQ1000307'
}

storage_pool = OneviewSDK::StoragePool.new(@client, options)
storage_pool.storage_system('FST_CPG1')
