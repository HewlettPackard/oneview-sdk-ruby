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
# - 200, 300, 500, 600

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::ServerProfile
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::ServerProfile
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::ServerProfile
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::ServerProfile
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::ServerProfile
# api_version = 600 & variant = C7000 to OneviewSDK::API600::C7000::ServerProfile
# api_version = 600 & variant = Synergy to OneviewSDK::API600::Synergy::ServerProfile

# Resource Class used in this sample
server_profile_class = OneviewSDK.resource_named('ServerProfile', @client.api_version)

# Extra classes used in this sample
enclosure_group_class = OneviewSDK.resource_named('EnclosureGroup', @client.api_version)
server_hardware_type_class = OneviewSDK.resource_named('ServerHardwareType', @client.api_version)
server_profile_template_class = OneviewSDK.resource_named('ServerProfileTemplate', @client.api_version)

# Getting the server hardware type and enclosure group to use this sample
server_hardware_type = server_hardware_type_class.get_all(@client).first
enclosure_group = enclosure_group_class.get_all(@client).first

profile_name = 'OneViewSDK Test ServerProfile'

puts "\nCreating a basic server profile"
item = server_profile_class.new(@client, name: profile_name)
item.set_server_hardware_type(server_hardware_type)
item.set_enclosure_group(enclosure_group)
item.create
puts "\nServer Profile created successfully! \n Name: #{item['name']} \n URI: #{item['uri']}"

puts "\nCreating a server profile from a basic template"
# Creating a server profile template for this sample
template = server_profile_template_class.new(@client, name: 'OneViewSDK Template')
template.set_server_hardware_type(server_hardware_type)
template.set_enclosure_group(enclosure_group)
template.create

item2 = template.new_profile("#{profile_name}_2")
item2.create
puts "\nServer Profile from a template created successfully! \n Name: #{item2['name']} \n URI: #{item2['uri']}"

puts "\nListing all server profiles:"
server_profile_class.get_all(@client).each do |profile|
  puts "\n#{profile['name']}"
end

puts "\nUpdating the name of a server profile."
item3 = server_profile_class.find_by(@client, name: profile_name).first
item3.update(name: "#{profile_name}_Updated")
item3.retrieve!
puts "\nServer Profile updated successfully! New name: #{item3['name']}"
puts "\nReturning to original name"
item3['name'] = profile_name
item3.update
item3.retrieve!
puts "\nServer Profile updated successfully! Name: #{item3['name']}"

# This method supports till OneView REST API Version 1200
puts "\nGetting the available servers"
servers = server_profile_class.get_available_servers(@client)
puts "\nAvailable servers: \n#{servers}"

puts "\nGetting the available networks"
query_options = {
  'enclosure_group' => enclosure_group,
  'server_hardware_type' => server_hardware_type
}
networks = server_profile_class.get_available_networks(@client, query_options)
puts "\nNetworks retrieved:"
puts "\n Ethernet networks: #{networks['ethernetNetworks']}"
puts "\n FC networks: #{networks['fcNetworks']}"

puts "\nGetting the available targets"
targets = server_profile_class.get_available_targets(@client)
puts "\nAvailable targets: \n #{targets}"

puts "\nGetting the profile ports"
ports = server_profile_class.get_profile_ports(@client, query_options)
puts "\nPorts retrieved: \n #{ports['ports']}"

puts "\nGetting the error or status messages associated with the specified profile"
begin
  msgs = item3.get_messages
  puts "\nMessasses retrieved successfully! \n Message: #{msgs}"
rescue OneviewSDK::MethodUnavailable
  puts "\nThe method #get_messages available for API version <= 500"
end

puts "\nTransforming an existing profile"
item.get_transformation('server_hardware_type' => server_hardware_type, 'enclosure_group' => enclosure_group)
puts "\nOperation made successfully!"

puts "\nUpdating the server profile from the server profile template."
item2.update_from_template
puts "\nServer Profile updated successfully!"

# This method supports till OneView REST API Version 1200
puts "\nGetting a new profile template of a given server profile"
begin
  new_template = item2.get_profile_template
  puts "\nNew template generated: \n#{new_template.data}"
rescue NoMethodError
  puts "\nThe method #get_profile_template is available from API 500."
end

puts "\nRemoving the server profiles created is this sample"
item2.retrieve!
item3.retrieve!
item2.delete
item3.delete
puts "\nServer Profiles removed successfully!"
# Clean up
template.delete
