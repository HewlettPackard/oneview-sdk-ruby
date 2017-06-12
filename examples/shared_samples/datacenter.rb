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

# Example: Create/Update/Delete datacenter
# NOTE: This will create a datacenter named 'OneViewSDK Test Datacenter', update it and then delete it.
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::Datacenter
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::Datacenter
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::Datacenter
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::Datacenter
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::Datacenter

# Resource Class used in this sample
datacenter_class = OneviewSDK.resource_named('Datacenter', @client.api_version)
rack_class = OneviewSDK.resource_named('Rack', @client.api_version)

# Datacenter name used in this sample
datacenter_name = 'OneViewSDK Test Datacenter'
datacenter2_name = 'OneViewSDK Test Datacenter with rack'

puts "\nAdding a datacenter with default values"
item = datacenter_class.new(@client, name: datacenter_name, width: 5000, depth: 5000)
item.add
puts "\nDatacenter #{item['name']} added successfully. URI='#{item['uri']}'"

puts "\nAdding a datacenter with an existing rack"
rack = rack_class.get_all(@client).first
item2 = datacenter_class.new(@client, name: datacenter2_name, width: 5000, depth: 5000)
item2.add_rack(rack, 1000, 1000, 0)
item2.add
puts "\nDatacenter #{item2['name']} added successfully. \nURI='#{item2['uri']}' \nRack URI='#{item2['contents'].first['resourceUri']}'"

puts "\nGetting a list of visual content objects describing each rack within the datacenter"
puts item2.get_visual_content

puts "\nRemoving a rack of the datacenter"
item2.remove_rack(rack)
item2.update
puts "\nRack removed of the datacenter successfully."

puts "\nListing all datacenters"
datacenter_class.get_all(@client).each do |datacenter|
  puts "\n#{datacenter['name']}"
end

puts "\nFinding a datacenter by name = #{datacenter_name}"
item3 = datacenter_class.find_by(@client, name:  'OneViewSDK Test Datacenter').first
puts "\nDatacenter found successfully. \nName = #{item3['name']}"

puts "\nUpdating datacenter name"
item3.update(name: "#{datacenter_name}_Updated")
item3.refresh
puts "\nDatacenter updated successfully and new name = #{item3['name']}"
puts "\nReturning to original name"
item3['name'] = datacenter_name
item3.update
item3.refresh
puts "\nDatacenter updated successfully and original name = #{item3['name']}"

puts "\nRemoving datacenters"
item2.remove
item3.remove
puts "\nDatacenters removed successfully."
