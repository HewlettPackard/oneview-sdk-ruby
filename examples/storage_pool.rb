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
puts "Unmanaged pool name = #{storage_system[:unmanagedPools].first['name']}"
options[:poolName] = storage_system[:unmanagedPools].first['name']

# Create storage pool
item = OneviewSDK::StoragePool.new(@client, options)
item.set_storage_system(storage_system)
item.create
puts "\nCreated #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

# Retrieve created storage pool
item_2 = OneviewSDK::StoragePool.new(@client, name: options[:poolName])
item_2.retrieve!
puts "\nRetrieved #{type} by name: '#{item_2[:name]}'.\n  uri = '#{item_2[:uri]}'"

# Find recently created storage pool by name
matches = OneviewSDK::StoragePool.find_by(@client, name: item[:name])
item_3 = matches.first
puts "\nFound #{type} by name: '#{item_3[:name]}'.\n  uri = '#{item_3[:uri]}'"

item.delete
puts "\nDeleted #{type} '#{item[:name]}' successfully.\n"
