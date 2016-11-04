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

# Example: Add server hardware for an API300 Thunderbird Appliance
# NOTE: This will add an available server hardware device, then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid credentials for your environment:
#   @server_hardware_hostname (hostname or IP address)
#   @server_hardware_username
#   @server_hardware_password

type = 'server hardware'
options = {
  hostname: @server_hardware_hostname,
  username: @server_hardware_username,
  password: @server_hardware_password,
  licensingIntent: 'OneView'
}

item = OneviewSDK::API300::Thunderbird::ServerHardware.new(@client, options)
item.add
puts "\nAdded #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

# Find recently created item by name
matches = OneviewSDK::API300::Thunderbird::ServerHardware.find_by(@client, name: item[:name])
item2 = matches.first
raise "Failed to find #{type} by name: '#{item[:name]}'" unless matches.first
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item2[:uri]}'"

# Retrieve recently created item
item3 = OneviewSDK::API300::Thunderbird::ServerHardware.new(@client, name: item[:name])
item3.retrieve!
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item3[:uri]}'"

# List all server hardware
puts "\n\n#{type.capitalize} list:"
OneviewSDK::API300::Thunderbird::ServerHardware.find_by(@client, {}).each do |p|
  puts "  #{p[:name]}"
end

# Get a firmware inventory by id
item4 = OneviewSDK::API300::Thunderbird::ServerHardware.find_by(@client, {}).first
puts "\nGet a firmware with id :'#{item4[:uri]}'"
response = item4.get_firmware_by_id
puts "\nFound firware inventory by id: '#{item4[:uri]}'."
puts "\nuri firmware = '#{response['uri']}', server name = '#{response['serverName']}' and server moldel=  '#{response['serverModel']}',"

# Get a list of firmware inventory across all servers
puts 'Get a list of firmware without filters'
response = item4.get_firmwares
puts "\nFound firware inventory: '#{response}'."

puts 'Get a list of firmware with filters componentName and serverName'
filters = [
  { name: 'components.componentName', operation: '=', value: 'iLO' },
  { name: 'serverName', operation: '=', value: @server_hardware_hostname }
]
response2 = item4.get_firmwares(filters)
puts "\nFound firware inventory: '#{response2}'."

# Delete this item
item.remove
puts "\nSucessfully removed #{type} '#{item[:name]}'."
