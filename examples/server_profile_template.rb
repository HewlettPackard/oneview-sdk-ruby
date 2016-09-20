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

# Example: Create a server profile template
# NOTE: This will create a server profile named 'OneViewSDK Test ServerProfileTemplate', then delete it.
type = 'Server Profile Template'
puts "\n### Creating a new Server Profile Template based on a Server Hardware Type and Enclosure Group"
item = OneviewSDK::ServerProfileTemplate.new(@client, name:  'OneViewSDK Test ServerProfileTemplate')
server_hardware_type = OneviewSDK::ServerHardwareType.find_by(@client, {}).first
raise 'Failed to find Server Hardware Type' unless server_hardware_type || server_hardware_type['uri']
item.set_server_hardware_type(server_hardware_type)
enclosure_group = OneviewSDK::EnclosureGroup.find_by(@client, {}).first
raise 'Failed to find Enclosure Group' unless enclosure_group || enclosure_group['uri']
item.set_enclosure_group(enclosure_group)
item.create
puts "\nCreated #{type} '#{item['name']}' sucessfully.\n  uri = '#{item['uri']}'"
puts "\nServer Hardware Type '#{server_hardware_type['name']}'.\n uri = '#{item['serverHardwareTypeUri']}'"
puts "\nEnclosure Group '#{enclosure_group['name']}'.\n  uri = '#{item['enclosureGroupUri']}'"

# Find recently created item by name
puts "\n\n### Find recently created item by name"
matches = OneviewSDK::ServerProfileTemplate.find_by(@client, name: item['name'])
item2 = matches.first
raise "Failed to find #{type} by name: '#{item['name']}'" unless matches.first
puts "\nFound #{type} by name: '#{item['name']}'.\n  uri = '#{item2['uri']}'"

puts "\n\n### Retrieve recently created item"
item3 = OneviewSDK::ServerProfileTemplate.new(@client, name: item['name'])
item3.retrieve!
puts "Retrieved #{type} data by name: '#{item['name']}'.\n  uri = '#{item3['uri']}'"

puts "\n\n### Creating a Server Profile from the retrieved template"
server_profile = item.new_profile("ServerProfile1 from #{item['name']}")
server_profile.create
puts "\nCreated Server Profile '#{server_profile['name']}' sucessfully.\n  uri = '#{item['uri']}'"
server_profile.delete
puts "\nSucessfully deleted '#{server_profile['name']}'"

puts "\n\n### Deleting the Server Profile Template"
item3.delete
puts "\nSucessfully deleted #{type} '#{item['name']}'."


# Example: List all server profile templates with certain attributes
attributes = { affinity: 'Bay' }
puts "\n\n#{type.capitalize}s with #{attributes}"
OneviewSDK::ServerProfileTemplate.find_by(@client, attributes).each do |p|
  puts "  #{p['name']}"
end
