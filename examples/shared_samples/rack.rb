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

# Example: Create/Update/Delete racks
# NOTE: This will create a rack named 'OneViewSDK Test Rack', then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#   @enclosure_name - An enclosure not yet added to any rack
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::Rack
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::Rack
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::Rack
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::Rack
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::Rack

# Resource Class used in this sample
rack_class = OneviewSDK.resource_named('Rack', @client.api_version)

# Enclosure class used in this sample
enclosure_class = OneviewSDK.resource_named('Enclosure', @client.api_version)

rack_name = 'OneViewSDK Test Rack'

puts "\nAdding a rack with name = '#{rack_name}'"
item = rack_class.new(@client, name: rack_name)
item.add
puts "\nRack #{item['name']} added successfully. URI='#{item['uri']}'"

puts "\nListing all racks"
rack_class.get_all(@client).each do |rack|
  "\n#{rack['name']}"
end

puts "\nUpdating the name of the rack"
item.update(name: "#{rack_name}_updated")
puts "\nRack updated successfully with new name = '#{item['name']}'"
puts "\nReturning to original name"
item.update(name: rack_name)
puts "Rack updated successfully with original name = '#{item['name']}'"

enclosure = enclosure_class.find_by(@client, name: @enclosure_name).first
puts "\nAdding an enclosure with uri = '#{enclosure['uri']}' to a rack."
item.add_rack_resource(enclosure, topUSlot: 20, uHeight: 10)
item.update
puts "\nEnclosure added successfully. \n #{item['rackMounts']}"

puts "\nGetting the device topology."
puts item.get_device_topology

puts "\nRemoving an enclosure with uri = '#{enclosure['uri']}' of the rack."
item.remove_rack_resource(enclosure)
item.update
puts "\nEnclosure removed successfully. \n #{item['rackMounts']}"

puts "\nRemoving a rack."
item.remove
puts "Rack #{item['name']} removed successfully"
