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

require_relative '../../_client' # Gives access to @client

# NOTE: It is necessary a server hardware and an enclosure previous created

server_hardware = OneviewSDK::API300::C7000::ServerHardware.get_all(@client).first
enclosure = OneviewSDK::API300::C7000::Enclosure.get_all(@client).first

options = {
  name: 'Scope',
  description: 'Sample Scope description'
}
scope = OneviewSDK::API300::C7000::Scope.new(@client, options)

puts "\nCreating a new Scope"
scope.create
puts "Scope '#{scope['name']}' with uri '#{scope['uri']}' was successfully created."

puts "\nUpdating the #{scope['name']}"
scope['name'] = scope['name'] + ' Updated'
scope.update
puts "It was updated successfully to '#{scope['name']}' with uri '#{scope['uri']}'."

puts "\nSetting resources to the '#{scope['name']}'"
scope.set_resources(server_hardware, enclosure)
server_hardware.refresh
enclosure.refresh
puts 'scopeUris from Resources:', server_hardware['scopeUris'], enclosure['scopeUris']

puts "\nUnsetting resource from the '#{scope['name']}'"
scope.unset_resources(server_hardware)
server_hardware.refresh
enclosure.refresh
puts 'scopeUris from Resources:', server_hardware['scopeUris'], enclosure['scopeUris']

puts "\nReplacing resources from the '#{scope['name']}'"
scope.change_resource_assignments(add_resources: [server_hardware], remove_resources: [enclosure])
server_hardware.refresh
enclosure.refresh
puts 'scopeUris from Resources:', server_hardware['scopeUris'], enclosure['scopeUris']

puts "\nDeleting scope"
scope.refresh
scope.delete
puts 'Scope was successfully deleted.' unless scope.retrieve!
