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

# Example: Create an enclosure group for an API2000 C7000 Appliance
# NOTE: This will create an enclosure group named 'OneViewSDK Test Enclosure Group', then delete it.
#
# Supported APIs:
# - 200, 300, 500, 600, 800, 1200, 1600, 1800, 2000.

# Supported Variants:
# C7000 and Synergy for all API versions
# NOTE: Logical interconnect group variable "logical_interconnect_name" should be uncommented and created as a pre-requisite
# NOTE: variant should be updated before running example

# Resource Class used in this sample
encl_group_class = OneviewSDK.resource_named('EnclosureGroup', @client.api_version)

# LogicalInterconnectGroup class used in this sample.
lig_class = OneviewSDK.resource_named('LogicalInterconnectGroup', @client.api_version)

variant = 'Synergy'
type = 'enclosure group'
encl_group_name = 'OneViewSDK Test Enclosure Group'

lig = lig_class.find_by(@client, name: @logical_interconnect_name).first

interconnect_bay_mapping = [
       { interconnectBay: 3, logicalInterconnectGroupUri: lig[:uri] },
       { interconnectBay: 6, logicalInterconnectGroupUri: lig[:uri] }
]

options = {
  name: encl_group_name,
  ipAddressingMode: 'External',
  enclosureCount: 1,
  interconnectBayMappings: interconnect_bay_mapping
}

item = encl_group_class.new(@client, options)

# lig = lig_class.get_all(@client).first
item.add_logical_interconnect_group(lig)

if @client.api_version >= 600
  # Gets enclosure group by scopeUris
  scope_class = OneviewSDK.resource_named('Scope', @client.api_version)
  scope_item = scope_class.get_all(@client).first
  query = {
    scopeUris: scope_item['uri']
  }
  puts "\nGets enclosure group with scope '#{query[:scopeUris]}'"
  items = encl_group_class.get_all_with_query(@client, query)
  puts "Found enclosure group '#{items}'."
end

puts "\nCreating an #{type} with name = '#{item[:name]}' and logical interconnect group uri = '#{lig[:uri]}''"
item.create!
puts "\nCreated #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

item2 = encl_group_class.new(@client, name: encl_group_name)
item2.retrieve!
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item2[:uri]}'"

item.refresh
puts "\nUpdating an #{type} with name = '#{item[:name]}' and uri = '#{item[:uri]}''"
item.update(name: 'OneViewSDK Test Enclosure_Group Updated')
puts "\nUpdated #{type} with new name = '#{item[:name]}' sucessfully."

if variant == 'C7000'
  command = '#TEST COMMAND'
  puts "\nSetting a script with command = '#{command}'"
  item.set_script(command)
  puts "\nScript attributed sucessfully."
end

if variant == 'C7000'
  puts "\nGetting a script"
  script = item.get_script
  puts "\nScript retrieved sucessfully."
  puts script
end

puts "\nDeleting the #{type} with name = '#{item[:name]}' and uri = '#{item[:uri]}''"
item.delete
puts "\nSucessfully deleted #{type} '#{item[:name]}'."
