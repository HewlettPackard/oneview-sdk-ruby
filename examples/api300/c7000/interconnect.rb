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

require_relative '../../_client'

# Example: Actions with interconnect
# NOTE: You'll need to add an interconnect with state Configured and a port linked.

# List of interconnects
puts "\nGets all interconnects"
OneviewSDK::API300::C7000::Interconnect.find_by(@client, {}).each do |interconnect|
  puts "Interconnect #{interconnect['name']} URI=#{interconnect['uri']} state #{interconnect['state']}"
end

# Retrieves interconnect types
puts "\nRetrieving interconnect types"
OneviewSDK::API300::C7000::Interconnect.get_types(@client).each do |type|
  puts "Interconnect type #{type['name']} URI=#{type['uri']}"
end

item = OneviewSDK::API300::C7000::Interconnect.find_by(@client, state: 'Configured').first

# Retrieving the named servers for this interconnect
puts "\nRetrieving the named servers for interconnect #{item['name']}"
servers = item.name_servers
puts 'Server not found.' unless servers.empty?
puts servers

# Get statistics for an interconnect, for the specified port
port = item[:ports].last
puts "\nGetting statistics for the interconnect #{item['name']} and port #{port['name']}"
stats = item.statistics(port['name'])
puts "\nStatistics for the interconnect #{item['name']} and port #{port['name']}"
puts stats

# Resert Port Protection
puts "\nReseting port protection for interconnect #{item['name']}"
item.reset_port_protection
puts 'Reset port protection successfully.'

# Update port
ports = item['ports'].select { |k| k['portType'] == 'Uplink' }
port = ports.first
puts "\nUpdating port for interconnect #{item['name']}"
puts "and port #{port['name']} with status #{port['enabled']}"
puts "\nChanging the status"
item.update_port(port['name'], enabled: false)
item.retrieve!
ports_2 = item['ports'].select { |k| k['portType'] == 'Uplink' }
port_updated = ports_2.first
puts "Port updated successfully for interconnect #{item['name']}"
puts "Port #{port_updated['name']} with status #{port_updated['enabled']}"
# Returning to original state
puts "\nEnabling the port #{port['name']}"
item.update_port(port['name'], enabled: true)
item.retrieve!
ports_3 = item['ports'].select { |k| k['portType'] == 'Uplink' }
port_original_state = ports_3.first
puts "\nPort #{port_original_state['name']} with status #{port_original_state['enabled']}"
