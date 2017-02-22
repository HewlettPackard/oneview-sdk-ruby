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

require_relative '../../_client' # Gives access to @client

# NOTE: It is needed have a Switch created previously.

# Retrieves all switch types from the Appliance
OneviewSDK::API300::C7000::Switch.get_types(@client).each do |type|
  puts "Switch Type: #{type['name']}\nURI: #{type['uri']}\n\n"
end

# Retrieves switch type by name
item = OneviewSDK::API300::C7000::Switch.get_type(@client, 'Cisco Nexus 50xx')
puts "Switch Type by name: #{item['name']}\nURI: #{item['uri']}\n\n"

# Retrieves switch type by name
item = OneviewSDK::API300::C7000::Switch.get_type(@client, 'Cisco Nexus 50xx')
puts "Switch Type by name: #{item['name']}\nURI: #{item['uri']}\n\n"

# Create Scopes
scope_1 = OneviewSDK::API300::C7000::Scope.new(@client, name: 'Scope 1')
scope_1.create
scope_2 = OneviewSDK::API300::C7000::Scope.new(@client, name: 'Scope 2')
scope_2.create

item = OneviewSDK::API300::C7000::Switch.get_all(@client).first

puts "\nAdding scopes"
item.add_scope(scope_1)
item.retrieve!
puts 'Scopes:', item['scopeUris']

puts "\nReplacing scopes"
item.replace_scopes(scope_2)
item.retrieve!
puts 'Scopes:', item['scopeUris']

puts "\nRemoving scopes"
item.remove_scope(scope_1)
item.remove_scope(scope_2)
item.retrieve!
puts 'Scopes:', item['scopeUris']

# Delete scopes
scope_1.delete
scope_2.delete
