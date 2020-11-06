# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

# Example: Manage connection templates

# Supported variants:
# - C7000 and Synergy for all api versions


# Resource Class used in this sample
conn_template_class = OneviewSDK.resource_named('ConnectionTemplate', @client.api_version)

puts "\nGetting the default network connection template"
default = conn_template_class.get_default(@client)
if default['uri']
  puts "\nRetrieved default connection template with name='#{default['name']}'"
  puts "(- maximumBandwidth: #{default['bandwidth']['maximumBandwidth']})"
  puts "(- typicalBandwidth: #{default['bandwidth']['typicalBandwidth']})\n"
end

puts "\nList all connections templates:"
connections = conn_template_class.get_all(@client)
connections.each do |c|
  puts "  Name: #{c[:name]} with uri: #{c[:uri]}"
end

conn_name = connections.first['name']

puts "\nFinding a connection template by name. Name: #{conn_name}"
item = conn_template_class.find_by(@client, name: conn_name).first
puts "\nConnection template with name='#{item['name']}' bandwidth specification is:"
puts "(- maximumBandwidth: #{item['bandwidth']['maximumBandwidth']})"
puts "(- typicalBandwidth: #{item['bandwidth']['typicalBandwidth']})\n"

puts "\nUpdating a connection template with name='#{item['name']}"
puts "\n Reducing value 100 for maximumBandwidth and typicalBandwidth:"
item['bandwidth']['maximumBandwidth'] -= 100
item['bandwidth']['typicalBandwidth'] -= 100
item.update
item.retrieve!
puts "\nConnection template with name='#{item['name']}' bandwidth specification changed:"
puts "(- maximumBandwidth: #{item['bandwidth']['maximumBandwidth']})"
puts "(- typicalBandwidth: #{item['bandwidth']['typicalBandwidth']})\n"

puts "\nReturnig to original state."
item['bandwidth']['maximumBandwidth'] += 100
item['bandwidth']['typicalBandwidth'] += 100
item.update
item.retrieve!
puts "\nConnection template with name='#{item['name']}' returned to original state:"
puts "(- maximumBandwidth: #{item['bandwidth']['maximumBandwidth']})"
puts "(- typicalBandwidth: #{item['bandwidth']['typicalBandwidth']})\n"
