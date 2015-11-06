require_relative '_client' # Gives access to @client

# Example: Create a storage system
options = {
  ip_hostname: '172.18.11.11', # TODO: Replace
  username: 'dcs', # TODO: Replace
  password: 'dcs' # TODO: Replace
}

storage1 = OneviewSDK::StorageSystem.new(@client)
storage1['credentials'] = options
storage1['managedDomain'] = 'TestDomain'
storage1.create
puts storage1['managedDomain']

OneviewSDK::StorageSystem.find_by(@client, credentials: { ip_hostname: options[:ip_hostname] }).each do |storage|
  puts storage['name']
end

storage = OneviewSDK::StorageSystem.new(@client, credentials: { ip_hostname: options[:ip_hostname] })
storage.retrieve!
storage.delete
