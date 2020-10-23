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

# Example: Actions with interconnect
# NOTE: You'll need to add an interconnect with state Configured and a port linked.

# for example, if api_version = 800 & variant = C7000 then, resource created will be in form
# OneviewSDK::API800::C7000::Interconnect

# Resource Class used in this sample
interconnect_class = OneviewSDK.resource_named('Interconnect', @client.api_version)

# List of interconnects
puts "\nGets all interconnects"
interconnect_class.find_by(@client, {}).each do |interconnect|
  puts "Interconnect #{interconnect['name']} URI=#{interconnect['uri']} state #{interconnect['state']}"
end

# Retrieves interconnect types
puts "\nRetrieving interconnect types"
interconnect_class.get_types(@client).each do |type|
  puts "Interconnect type #{type['name']} URI=#{type['uri']}"
end

item = interconnect_class.find_by(@client, state: 'Configured').first

# Retrieving the named servers for this interconnect
puts "\nRetrieving the named servers for interconnect #{item['name']}"
if item
  servers = item.name_servers
  puts 'Server not found.' unless servers.empty?
  puts servers

# Get statistics for an interconnect, for the specified port
if item:
  port = item[:ports].last
if item && port
  puts "\nGetting statistics for the interconnect #{item['name']} and port #{port['name']}"
  stats = item.statistics(port['name'])
  puts "\nStatistics for the interconnect #{item['name']} and port #{port['name']}"
  puts stats

# Resert Port Protection
if item:
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

# Patch
if item
  puts "\nUpdating an interconnect across a patch."
  puts "Interconnect #{item['name']} with uidState #{item['uidState']}"
  item.patch('replace', '/uidState', 'Off')
  item.retrieve!
  puts "Interconnect #{item['name']} updated successfully with new uidState #{item['uidState']}"
  # Returning to original state
  puts "\nReturning for original state"
  item.patch('replace', '/uidState', 'On')
  item.retrieve!
  puts "Interconnect #{item['name']} updated successfully with previous uidState #{item['uidState']}"

# List of synergy interconnect link topologies
begin
  puts "\nGets a list of synergy interconnect link topologies"
  interconnect_class.get_link_topologies(@client).each do |link_topology|
    puts "Interconnect link topology #{link_topology['name']} URI=#{link_topology['uri']}"
  end
rescue NoMethodError
  puts 'The method #get_link_topologies is available only for Synergy.'
end

# Gets all the Small Form-factor Pluggable (SFP) instances from an interconnect.
# This method 'get_pluggable_module_information' was added from api version 500.
if @client.api_version >= 500
  begin
    puts "\nGets all the Small Form-factor Pluggable (SFP) instances of interconnect #{item['uri']}."
    results = item.get_pluggable_module_information
    puts "\nThe Small Form-factor Pluggable (SFP) instances retrieved successfully:"
    puts results
  rescue NoMethodError
    puts 'The method #get_pluggable_module_information is available only for api greater than or equal to 500.'
  end

# Applies or reapplies the current interconnect configuration.
# This method 'configuration' was added in API version 500.
if @client.api_version >= 500
  begin
    puts "\nApplying the configuration to interconnect #{item['uri']}."
    item.configuration
    puts "\nThe action was executed successfully"
  rescue NoMethodError
    puts 'The method #configuration is available only for API version greater than or equal to 500.'
  end
