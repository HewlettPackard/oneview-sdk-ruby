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

# Gives access to @client
require_relative '../../_client'

def print_server_hardware_type(item)
  puts "\n-- Server hardware type --",
       "Uri: #{item['uri']}",
       "Name: #{item['name']}",
       "Description: #{item['description']}",
       '----'
end


# List all server hardware types
list = OneviewSDK::API300::Synergy::ServerHardwareType.get_all(@client)
puts "\n#Listing all server hardware type:"
list.each { |p| puts "  #{p[:name]}" }

puts "\n#Retrieving by uri #{list.first['uri']}"
target = OneviewSDK::API300::Synergy::ServerHardwareType.new(@client, uri: list.first['uri'])
target.retrieve!
print_server_hardware_type(target)

puts "\nUpdating name and description of resource retrieved."
target.update(name: 'New Name', description: 'New Description')
print_server_hardware_type(target)
