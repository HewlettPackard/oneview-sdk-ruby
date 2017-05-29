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

# NOTE: You'll need to add the following instance variables to the _client.rb file with valid credentials for your environment:
#   @storage_system_ip
#   @storage_system_username
#   @storage_system_password

# Supported APIs:
# - API200 for C7000
# - API300 for C7000
# - API300 for Synergy
# - API500 for C7000 (see /examples/api500/storage_system.rb)
# - API500 for Synergy (see /examples/api500/storage_system.rb)

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::StorageSystem
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::StorageSystem
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::StorageSystem

raise 'ERROR: Must set @storage_system_ip in _client.rb' unless @storage_system_ip
raise 'ERROR: Must set @storage_system_username in _client.rb' unless @storage_system_username
raise 'ERROR: Must set @storage_system_password in _client.rb' unless @storage_system_password

if @client.api_version == 500
  raise "If you want execute sample for API #{@client.api_version}, you should execute the ruby file '/examples/api500/storage_system.rb'"
end

# Resource Class used in this sample
storage_system_class = OneviewSDK.resource_named('StorageSystem', @client.api_version)

options = {
  ip_hostname: @storage_system_ip,
  username: @storage_system_username,
  password: @storage_system_password
}

storage1 = storage_system_class.new(@client)
storage1['credentials'] = options
storage1['managedDomain'] = 'TestDomain'
puts "\nAdding a storage system with Managed Domain: #{storage1['managedDomain']}"
puts "and hostname: #{options[:ip_hostname]}."
storage1.add
puts "\nStorage system added successfully."

puts "\nFinding a storage system with hostname: #{options[:ip_hostname]}"
storage_system_class.find_by(@client, credentials: { ip_hostname: options[:ip_hostname] }).each do |storage|
  puts "\nStorage system with name #{storage['name']} found."
end

storage2 = storage_system_class.new(@client, credentials: { ip_hostname: options[:ip_hostname] })
storage2.retrieve!
puts "\nRefreshing a storage system with #{options[:ip_hostname]}"
puts "and state #{storage2['refreshState']}"
storage2.set_refresh_state('RefreshPending')
puts "\nStorage system refreshed successfully and with new state: #{storage2['refreshState']}."

puts "\nRemoving the Storage system."
storage2.remove
puts "\nStorage system removed successfully."
