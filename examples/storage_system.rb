require_relative '_client' # Gives access to @client

# Example: Create a storage system
# NOTE: This will create a storage system, then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid credentials for your environment:
#   @storage_system_ip
#   @storage_system_username
#   @storage_system_password

fail 'ERROR: Must set @storage_system_ip in _client.rb' unless @storage_system_ip
fail 'ERROR: Must set @storage_system_username in _client.rb' unless @storage_system_username
fail 'ERROR: Must set @storage_system_password in _client.rb' unless @storage_system_password

# Example: Create a storage system
options = {
  ip_hostname: @storage_system_ip,
  username: @storage_system_username,
  password: @storage_system_password
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
