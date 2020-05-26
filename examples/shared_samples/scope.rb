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

# NOTE: It is necessary a server hardware and an enclosure previous created
#
# Supported APIs:
# - API200 for C7000
# - API300 for C7000
# - API300 for Synergy
# - API500 for C7000
# - API500 for Synergy
# - API600 for C7000
# - API600 for Synergy
# - API800 for C7000
# - API800 for Synergy
# - API1000 for C7000
# - API1000 for Synergy
# - API1200 for C7000
# - API1200 for Synergy
# - API1600 for C7000
# - API1600 for Synergy

# Resources that can be created according to parameters:
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::Scope
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::Scope
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::Scope
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::Scope
# api_version = 600 & variant = C7000 to OneviewSDK::API600::C7000::Scope
# api_version = 600 & variant = Synergy to OneviewSDK::API600::Synergy::Scope
# api_version = 800 & variant = C7000 to OneviewSDK::API800::C7000::Scope
# api_version = 800 & variant = Synergy to OneviewSDK::API800::Synergy::Scope
# api_version = 1000 & variant = C7000 to OneviewSDK::API1000::C7000::Scope
# api_version = 1000 & variant = Synergy to OneviewSDK::API1000:Synergy::Scope
# api_version = 1200 & variant = C7000 to OneviewSDK::API1200::C7000::Scope
# api_version = 1200 & variant = Synergy to OneviewSDK::API1200::Synergy::Scope
# api_version = 1600 & variant = C7000 to OneviewSDK::API1600::C7000::Scope
# api_version = 1600 & variant = Synergy to OneviewSDK::API1600::Synergy::Scope


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
scope.set_resources(server_hardware, enclosure)

server_hardware.refresh
enclosure.refresh
puts "\nscopeUris from Resources: Server Hardware scope  - #{server_hardware['scopeUris']}, Enclosure scope #{enclosure['scopeUris']}"

if @client.api_version >= 600
  puts "\nGet resource scope uris"
  resource_scope = scope_class.get_resource_scopes(@client, server_hardware)
  puts "Server hardware scopes #{resource_scope}"

  puts "\nReplace resource scope uris with scope2"
  options = {
    name: 'Scope2',
    description: 'Sample Scope description2'
  }
  scope2 = scope_class.new(@client, options)
  scope2.create
  puts "Created Scope2 with uri #{scope2['uri']}"
  scope_class.replace_resource_assigned_scopes(@client, server_hardware, scopes: [scope2])
  puts 'Replaced resouce scope uris'

  puts '\nAdd a resource to scope3'
  options = {
    name: 'Scope3',
    description: 'Sample Scope description3'
  }
  scope3 = scope_class.new(@client, options)
  scope3.create
  puts 'Created scope3'
  scope_item = scope_class.find_by(@client, name: 'Scope2').first
  scope_class.add_resource_scope(@client, enclosure, scopes: [scope3, scope_item])
  puts 'Server hardware resource added to scope3'

  puts '\nRemoving resource from scope3'
  scope_class.remove_resource_scope(@client, enclosure, scopes: [scope3, scope_item])
  scope_class.add_resource_scope(@client, server_hardware, scopes: [scope_item])
  scope_class.resource_patch(@client, server_hardware, add_scopes: [scope3], remove_scopes: [scope_item])
  puts 'Removed resource from scope3'

  # Delete all scopes created.
  scope2.delete
  scope3.delete
end

puts "\nUnsetting resource from the '#{scope['name']}'"
scope.unset_resources(server_hardware, enclosure)
server_hardware.refresh
enclosure.refresh
puts 'scopeUris from Resources:', server_hardware['scopeUris'], enclosure['scopeUris']

puts "\nReplacing resources from the '#{scope['name']}'"
scope.change_resource_assignments(add_resources: [server_hardware], remove_resources: [enclosure])
server_hardware.refresh
enclosure.refresh
puts 'scopeUris from Resources:', server_hardware['scopeUris'], enclosure['scopeUris']

if @client.api_version >= 500
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
