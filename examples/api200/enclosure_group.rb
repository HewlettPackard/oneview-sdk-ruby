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

require_relative '../_client' # Gives access to @client

# Example: Create an enclosure group
# NOTE: This will create an enclosure group named 'OneViewSDK Test Enclosure Group', then delete it.
type = 'enclosure group'
options = {
  name: 'OneViewSDK Test Enclosure Group',
  stackingMode: 'Enclosure',
  interconnectBayMappingCount: 8,
  type: 'EnclosureGroupV200'
}

item = OneviewSDK::EnclosureGroup.new(@client, options)
item.create
puts "\nCreated #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

item2 = OneviewSDK::EnclosureGroup.new(@client, name: options[:name])
item2.retrieve!
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item2[:uri]}'"

item.refresh
item.update(name: 'OneViewSDK Test Enclosure_Group')
puts "\nUpdated #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

item.delete
puts "\nSucessfully deleted #{type} '#{item[:name]}'."
