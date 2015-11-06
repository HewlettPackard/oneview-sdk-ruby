require_relative '_client' # Gives access to @client

# Example: Create a storage system
options = {
  ip_hostname: '172.18.11.11',
  username: 'dcs',
  password: 'dcs'
}

storage1 = OneviewSDK::StorageSystem.new(@client)
storage1['credentials'] = options
storage1['managedDomain'] = 'TestDomain'
storage1.create
puts storage1['managedDomain']

OneviewSDK::StorageSystem.find_by(@client, credentials: { ip_hostname: '172.18.11.11' }).each do |storage|
  puts storage['name']
end

storage = OneviewSDK::StorageSystem.new(@client, credentials: { ip_hostname: '172.18.11.11' })
storage.retrieve!
storage.delete
