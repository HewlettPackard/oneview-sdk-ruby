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

# Example: Actions with a Server Hardware Type
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::ServerHardwareType
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::ServerHardwareType
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::ServerHardwareType
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::ServerHardwareType
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::ServerHardwareType

# Resource Class used in this sample
sht_class = OneviewSDK.resource_named('ServerHardwareType', @client.api_version)

sh_class = OneviewSDK.resource_named('ServerHardware', @client.api_version)

def print_server_hardware_type(item)
  puts "\n-- Server hardware type --",
       "Uri: #{item['uri']}",
       "Name: #{item['name']}",
       "Description: #{item['description']}",
       '----'
end

server_hardware = nil
item = nil
# Get variant with example_helper method defined in _client.rb
variant = example_helper

# It is possible to create a server hardware type with a server hardware only for C7000.
if variant == 'C7000'
  puts "\nCreating server hardware type by the creation of server hardware."

  options_server_hardware = {
    hostname: @server_hardware_hostname,
    username: @server_hardware_username,
    password: @server_hardware_password,
    name: 'Server Hardware Type OneViewSDK Test 2',
    licensingIntent: 'OneView'
  }

  server_hardware = sh_class.new(@client, options_server_hardware)
  server_hardware.add
  # retrieving server hardware type
  item = sht_class.new(@client, uri: server_hardware['serverHardwareTypeUri'])
  item.retrieve!
  print_server_hardware_type(item)
end

# List all server hardware types
list = sht_class.get_all(@client)
puts "\n#Listing all:"
list.each { |p| puts "  #{p[:name]}" }

item ||= list.first

puts "\nUpdating name and description of SHT with name = '#{item['name']}' and description = name = '#{item['description']}'."
old_name = item['name']
old_description = item['description'] || ''
new_name = "#{old_name}_Updated"
new_description = "#{old_description}_Updated"
item.update(name: new_name, description: new_description)
item.retrieve!
puts "\nServer hardware type updated successfully!"
print_server_hardware_type(item)
puts "\nReturning to original state"
item.update(name: old_name, description: old_description)
item.retrieve!
puts "\nServer hardware returned to original state!"
print_server_hardware_type(item)

server_hardware.remove if variant == 'C7000'

puts "\nRemoving resource."
item.remove
puts "\nSucessfully removed."
