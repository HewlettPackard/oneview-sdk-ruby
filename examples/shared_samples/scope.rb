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

# NOTE: It is necessary a server hardware and an enclosure previous created
#
# Supported APIs:
# - API200 for C7000
# - API300 for C7000
# - API300 for Synergy
# - API500 for C7000
# - API500 for Synergy

# Resources that can be created according to parameters:
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::Scope
# api_version = 300 & variant = Synergy to OneviewSDK::API300::C7000::Scope
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::Scope
# api_version = 500 & variant = Synergy to OneviewSDK::API500::C7000::Scope
#
# NOTE: Scopes doesn't support versions smaller than 300.

# Resource Class used in this sample
scope_class = OneviewSDK.resource_named('Scope', @client.api_version)

puts "\nPerforming example for #{scope_class}"

# Extra resources used in this example
server_hardware_class = OneviewSDK.resource_named('ServerHardware', @client.api_version)
enclosure_class = OneviewSDK.resource_named('Enclosure', @client.api_version)

server_hardware = server_hardware_class.get_all(@client).first
enclosure = enclosure_class.get_all(@client).first

options = {
  name: 'Scope',
  description: 'Sample Scope description'
}
scope = scope_class.new(@client, options)

puts "\nCreating a new Scope"
scope.create
puts "Scope '#{scope['name']}' with uri '#{scope['uri']}' was successfully created."

puts "\nUpdating the #{scope['name']}"
old_name = scope['name']
scope['name'] = old_name + ' Updated'
scope.update
scope.refresh
puts "It was updated successfully to '#{scope['name']}' with uri '#{scope['uri']}'."
puts "\nUpdating to original name."
scope['name'] = old_name
scope.update
puts "It was updated successfully to '#{scope['name']}' with uri '#{scope['uri']}'."

puts "\nSetting resources to the '#{scope['name']}'"
if @client.api_version == 300
  scope.set_resources(server_hardware, enclosure)
elsif @client.api_version == 500
  scope.set_resources(server_hardware)
  scope.set_resources(enclosure)
end

server_hardware.refresh
enclosure.refresh
puts "scopeUris from Resources: Server Hardware scope  - #{server_hardware['scopeUris']}, Enclosure scope #{enclosure['scopeUris']}"

puts "\nUnsetting resource from the '#{scope['name']}'"
scope.unset_resources(server_hardware, enclosure)
server_hardware.refresh
enclosure.refresh
puts 'scopeUris from Resources:', server_hardware['scopeUris'], enclosure['scopeUris']

if @client.api_version == 300
  puts "\nReplacing resources from the '#{scope['name']}'"
  scope.change_resource_assignments(add_resources: [server_hardware], remove_resources: [enclosure])
  server_hardware.refresh
  enclosure.refresh
  puts 'scopeUris from Resources:', server_hardware['scopeUris'], enclosure['scopeUris']
end

if @client.api_version == 500
  puts "\nUpdating the scope name '#{scope['name']}' with a patch."
  old_name = scope['name']
  scope.patch('replace', '/name', "#{old_name} Updated")
  scope.refresh
  puts "It was updated successfully to '#{scope['name']}' with uri '#{scope['uri']}'."
  puts "\nUpdating to original name."
  scope.patch('replace', '/name', old_name)
  scope.refresh
  puts "It was updated successfully to '#{scope['name']}' with uri '#{scope['uri']}'."
end

puts "\nDeleting scope"
scope.refresh
scope.delete
puts 'Scope was successfully deleted.' unless scope.retrieve!
