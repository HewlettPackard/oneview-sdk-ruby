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

# Gives access to @client, @server_hardware_hostname, @server_hardware_username, @server_hardware_password
require_relative '../../_client'

def print_server_hardware_type(item)
  puts "\n-- Server hardware type --",
       "Uri: #{item['uri']}",
       "Name: #{item['name']}",
       "Description: #{item['description']}",
       '----'
end

puts "\nCreating server hardware type by the creation of server hardware."

options_server_hardware = {
  hostname: @server_hardware_hostname,
  username: @server_hardware_username,
  password: @server_hardware_password,
  name: 'Server Hardware Type OneViewSDK Test 2',
  licensingIntent: 'OneView'
}

server_hardware = OneviewSDK::API300::C7000::ServerHardware.new(@client, options_server_hardware)
server_hardware.add

# retrieving server hardware type
target = OneviewSDK::API300::C7000::ServerHardwareType.new(@client, uri: server_hardware['serverHardwareTypeUri'])
target.retrieve!
print_server_hardware_type(target)

puts "\nUpdating name and description."
target.update(name: 'New Name', description: 'New Description')
print_server_hardware_type(target)

# List all server hardware types
list = OneviewSDK::API300::C7000::ServerHardwareType.get_all(@client)
puts "\n#Listing all:"
list.each { |p| puts "  #{p[:name]}" }

server_hardware.remove

puts "\nRemoving resource."
target.remove
puts "\nSucessfully removed."
