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

# Supported APIs:
# - 200, 300, 500, 600, 800, 1000, 1200, and 1600.

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::ServerProfileTemplate
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::ServerProfileTemplate
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::ServerProfileTemplate
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::ServerProfileTemplate
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::ServerProfileTemplate
# api_version = 600 & variant = C7000 to OneviewSDK::API600::C7000::ServerProfileTemplate
# api_version = 600 & variant = Synergy to OneviewSDK::API600::Synergy::ServerProfileTemplate
# api_version = 800 & variant = C7000 to OneviewSDK::API800::C7000::ServerProfileTemplate
# api_version = 800 & variant = Synergy to OneviewSDK::API800::Synergy::ServerProfileTemplate
# api_version = 1000 & variant = C7000 to OneviewSDK::API1000::C7000::ServerProfileTemplate
# api_version = 1000 & variant = Synergy to OneviewSDK::API1000::Synergy::ServerProfileTemplate
# api_version = 1200 & variant = C7000 to OneviewSDK::API1200::C7000::ServerProfileTemplate
# api_version = 1200 & variant = Synergy to OneviewSDK::API1200::Synergy::ServerProfileTemplate
# api_version = 1600 & variant = C7000 to OneviewSDK::API1600::C7000::ServerProfileTemplate
# api_version = 1600 & variant = Synergy to OneviewSDK::API1600::Synergy::ServerProfileTemplate

# Resource Class used in this sample
server_profile_template_class = OneviewSDK.resource_named('ServerProfileTemplate', @client.api_version)

# Extra classes used in this sample
enclosure_group_class = OneviewSDK.resource_named('EnclosureGroup', @client.api_version)
server_hardware_type_class = OneviewSDK.resource_named('ServerHardwareType', @client.api_version)

server_profile_template_name = 'OneViewSDK Test ServerProfileTemplate'
puts "\n### Creating a new Server Profile Template based on a Server Hardware Type and Enclosure Group"
item = server_profile_template_class.new(@client, name:  server_profile_template_name)

server_hardware_type = server_hardware_type_class.find_by(@client, {}).first
raise 'Failed to find Server Hardware Type' unless server_hardware_type || server_hardware_type['uri']
item.set_server_hardware_type(server_hardware_type)
enclosure_group = enclosure_group_class.find_by(@client, {}).first
raise 'Failed to find Enclosure Group' unless enclosure_group || enclosure_group['uri']
item.set_enclosure_group(enclosure_group)
item.create
puts "\nCreated Server Profile Template '#{item['name']}' successfully.\n  uri = '#{item['uri']}'"
puts "\nServer Hardware Type '#{server_hardware_type['name']}'.\n uri = '#{item['serverHardwareTypeUri']}'"
puts "\nEnclosure Group '#{enclosure_group['name']}'.\n  uri = '#{item['enclosureGroupUri']}'"

# Get server profiles filtered by scope uris.
scope_class = OneviewSDK.resource_named('Scope', @client.api_version)
scope = scope_class.get_all(@client).first
puts "\nGet all server profile templates with scope #{scope['uri']}"
profiles = server_profile_template_class.get_all_with_query(@client, 'scope_uris' => scope['uri'])
puts "\nResponse, #{profiles}"

# Find recently created item by name
puts "\n\n### Find recently created item by name"
matches = server_profile_template_class.find_by(@client, name: server_profile_template_name)
item2 = matches.first
raise "Failed to find Server Profile Template by name: '#{server_profile_template_name}'" unless matches.first
puts "\nFound Server Profile Template by name: '#{server_profile_template_name}'.\n  uri = '#{item2['uri']}'"

puts "\n\n### Creating a Server Profile from the retrieved template"
server_profile = item.new_profile("ServerProfile1 from #{item2['name']}")
server_profile.create
puts "\nCreated Server Profile '#{server_profile['name']}' successfully.\n  uri = '#{server_profile['uri']}'"
server_profile.delete
puts "\nSucessfully deleted '#{server_profile['name']}'"

puts "\n\n### Transforms an existing profile template by supplying a new server hardware type and/or enclosure group"
item3 = server_profile_template_class.new(@client, name: "#{server_profile_template_name}2")
item3.set_server_hardware_type(server_hardware_type)
item3.set_enclosure_group(enclosure_group)
item3.create
server_hardware_type2 = server_hardware_type_class.find_by(@client, {}).last
enclosure_group2 = enclosure_group_class.find_by(@client, {}).last
begin
  item3.get_transformation(@client, 'server_hardware_type' => server_hardware_type2, 'enclosure_group' => enclosure_group2)
  item3.update
  puts "\nTransformed Server Profile Template '#{item3['name']}' successfully.\n  uri = '#{item3['uri']}' "
rescue NoMethodError
  puts "\nThe method #get_transformation is available from API 300 onwards."
end

puts "\nGet all available networks to a server profile template"
begin
  available_networks = item.get_available_networks(@client, 'enclosure_group_uri' => item['enclosureGroupUri'],
                                                            'server_hardware_type_uri' => item['serverHardwareTypeUri'])
  puts "\nAvailable networks \n #{available_networks}"
rescue NoMethodError
  puts "\nThe method #get_available_networks is available from API 600 onwards."
end

puts "\n\n### Deleting all Server Profiles Template created in this sample"
item2.delete
item3.delete
puts "\nServer Profiles Template removed successfully."
