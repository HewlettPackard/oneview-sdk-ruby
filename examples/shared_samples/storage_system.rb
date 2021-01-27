# (C) Copyright 2021 Hewlett Packard Enterprise Development LP
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

# NOTE 1: You'll need to add a FCNetwork before execute this sample
# NOTE 2: You'll need to add the following instance variables to the _client.rb file with valid credentials for your environment:
#   @storage_system_ip
#   @storage_system_username
#   @storage_system_password

raise 'ERROR: Must set @storage_system_ip in _client.rb' unless @storage_system_ip
raise 'ERROR: Must set @storage_system_username in _client.rb' unless @storage_system_username
raise 'ERROR: Must set @storage_system_password in _client.rb' unless @storage_system_password

if @client.api_version < 500
  raise "If you want execute sample for API < #{@client.api_version}," \
        "you should execute the ruby file '/examples/shared_samples/storage_system.rb'"
elsif @client.api_version == 500
  raise "If you want execute sample for API #{@client.api_version}," \
        "you should execute the ruby file '/examples/api500/storage_system.rb'"
end

storage_system_class = OneviewSDK.resource_named('StorageSystem', @client.api_version)

# for StorageSystem with family StoreServ
options = {
  credentials: {
    username: @storage_system_username,
    password: @storage_system_password
  },
  hostname: @storage_system_ip,
  family: 'StoreServ',
  deviceSpecificAttributes: {
    managedDomain: 'TestDomain'
  }
}

# for StorageSystem with family StoreVirtual
# options = {
#   credentials: {
#     username: @store_virtual_user,
#     password: @store_virtual_password
#   },
#   hostname: @store_virtual_ip,
#   family: 'StoreVirtual'
# }
storage_system = storage_system_class.new(@client, options)

puts "\nAdding a storage system with"
puts "Managed Domain: #{storage_system['deviceSpecificAttributes']['managedDomain']}" if options['family'] == 'StoreServ'
puts "Family: #{storage_system['family']}"
puts "Hostname: #{storage_system['hostname']}."
storage_system.add
puts "\nStorage system with uri='#{storage_system['uri']}' added successfully."

puts "\nFinding a storage system with hostname: #{storage_system['hostname']}"
storage_system_class.find_by(@client, hostname: storage_system['hostname']).each do |storage|
  puts "\nStorage system with uri='#{storage['uri']}' found."
end

storage_system = storage_system_class.new(@client, hostname: storage_system['hostname'])
add_storage_system(storage_system, options) unless storage_system

storage_system = storage_system_class.new(@client, hostname: storage_system['hostname'])
storage_system.retrieve!
port = storage_system['ports'].find { |item| item['protocolType'].downcase.include?('fc') } # find first correct protocolType for using our fc network
if port
  fc_network = OneviewSDK::API600::C7000::FCNetwork.get_all(@client).first
  puts "\n Adding a fc network named '#{fc_network['name']}' with uri='#{fc_network['uri']}' to the storage system."
  port['expectedNetworkUri'] = fc_network['uri']
  port['expectedNetworkName'] = fc_network['name']
  port['mode'] = 'Managed'
  storage_system.update
  puts "\nNetwork added successfully."
  storage_system.refresh
end

puts "\nReachable ports:"
puts storage_system.get_reachable_ports

puts "\nTemplates:"
storage_system.get_templates

puts "\nLast refresh time: #{storage_system['lastRefreshTime']}"
puts "\nRefreshing the storage system"
storage_system.request_refresh
storage_system.refresh
puts "\nLast refresh time: #{storage_system['lastRefreshTime']}"

puts "\nRemoving the storage system."
begin
  storage_system.remove
  puts "\nStorage system removed successfully."
rescue
  puts "\nUnable to delete: #{storage_system['hostname']}"
end

# creating another storage_system to ensure continuity for automation script
storage_system = storage_system_class.new(@client, hostname: storage_system['hostname'])
storage_system.retrieve!
storage_system ||= storage_system_class.new(@client, options)
puts "\nAdding a storage system with"
puts "Managed Domain: #{storage_system['deviceSpecificAttributes']['managedDomain']}" if options['family'] == 'StoreServ'
puts "Family: #{storage_system['family']}"
puts "Hostname: #{storage_system['hostname']}."
storage_system.add
puts "\nStorage system with uri='#{storage_system['uri']}' added successfully."
