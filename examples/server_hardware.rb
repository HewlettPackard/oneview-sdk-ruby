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

require_relative '_client' # Gives access to @client

# Example: Add server hardware
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

item = OneviewSDK::ServerHardware.new(@client, options)
item.add
puts "\nAdded #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

# Find recently created item by name
matches = OneviewSDK::ServerHardware.find_by(@client, name: item[:name])
item2 = matches.first
fail "Failed to find #{type} by name: '#{item[:name]}'" unless matches.first
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item2[:uri]}'"

# Retrieve recently created item
item3 = OneviewSDK::ServerHardware.new(@client, name: item[:name])
item3.retrieve!
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item3[:uri]}'"

# List all server hardware
puts "\n\n#{type.capitalize} list:"
OneviewSDK::ServerHardware.find_by(@client, {}).each do |p|
  puts "  #{p[:name]}"
end

# Delete this item
item.remove
puts "\nSucessfully removed #{type} '#{item[:name]}'."
