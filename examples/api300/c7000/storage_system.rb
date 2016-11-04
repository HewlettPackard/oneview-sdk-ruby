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

require_relative '../../_client' # Gives access to @client

# Example: Create a storage system
# NOTE: This will create a storage system, then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid credentials for your environment:
#   @storage_system_ip
#   @storage_system_username
#   @storage_system_password

raise 'ERROR: Must set @storage_system_ip in _client.rb' unless @storage_system_ip
raise 'ERROR: Must set @storage_system_username in _client.rb' unless @storage_system_username
raise 'ERROR: Must set @storage_system_password in _client.rb' unless @storage_system_password

# Example: Create a storage system
options = {
  ip_hostname: @storage_system_ip,
  username: @storage_system_username,
  password: @storage_system_password
}

storage1 = OneviewSDK::API300::C7000::StorageSystem.new(@client)
storage1['credentials'] = options
storage1['managedDomain'] = 'TestDomain'
storage1.add
puts storage1['managedDomain']

OneviewSDK::API300::C7000::StorageSystem.find_by(@client, credentials: { ip_hostname: options[:ip_hostname] }).each do |storage|
  puts storage['name']
end

storage = OneviewSDK::API300::C7000::StorageSystem.new(@client, credentials: { ip_hostname: options[:ip_hostname] })
storage.retrieve!
storage.remove
