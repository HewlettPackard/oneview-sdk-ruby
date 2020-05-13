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

# Example: Create an enclosure group for an API300 C7000 Appliance
# NOTE: This will create an enclosure group named 'OneViewSDK Test Enclosure Group', then delete it.
#
# Supported APIs:
# - 200, 300, 500, 600, 800, 1200, and 1600.

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::EnclosureGroup
# api_version = 300 & variant = C7000 to encl_group_class
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::EnclosureGroup
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::EnclosureGroup
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::EnclosureGroup
# api_version = 600 & variant = C7000 to OneviewSDK::API600::C7000::EnclosureGroup
# api_version = 600 & variant = Synergy to OneviewSDK::API600::Synergy::EnclosureGroup
# api_version = 800 & variant = C7000 to OneviewSDK::API800::C7000::EnclosureGroup
# api_version = 800 & variant = Synergy to OneviewSDK::API800::Synergy::EnclosureGroup
# api_version = 1000 & variant = C7000 to OneviewSDK::API1000::C7000::EnclosureGroup
# api_version = 1000 & variant = Synergy to OneviewSDK::API1000::Synergy::EnclosureGroup
# api_version = 1200 & variant = C7000 to OneviewSDK::API1200::C7000::EnclosureGroup
# api_version = 1200 & variant = Synergy to OneviewSDK::API1200::Synergy::EnclosureGroup
# api_version = 1600 & variant = C7000 to OneviewSDK::API1600::C7000::EnclosureGroup
# api_version = 1600 & variant = Synergy to OneviewSDK::API1600::Synergy::EnclosureGroup

# Resource Class used in this sample
encl_group_class = OneviewSDK.resource_named('EnclosureGroup', @client.api_version)

# LogicalInterconnectGroup class used in this sample.
# To run this example for  API > 1200, you would need to set api version for LIG to 1200 or less.
lig_class = OneviewSDK.resource_named('LogicalInterconnectGroup', @client.api_version)

type = 'enclosure group'
encl_group_name = 'OneViewSDK Test Enclosure Group'

item = encl_group_class.new(@client, name: encl_group_name)

lig = lig_class.get_all(@client).first
item.add_logical_interconnect_group(lig)

if @client.api_version >= 600
  # Gets enclosure group by scopeUris
  # To run this example for  API > 1200, you would need to set api version for scope to 1200 or less.
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

begin
  command = '#TEST COMMAND'
  puts "\nSetting a script with command = '#{command}'"
  item.set_script(command)
  puts "\nScript attributed sucessfully."
rescue OneviewSDK::MethodUnavailable => e
  puts "\n#{e}. Available only for C7000."
end

begin
  puts "\nGetting a script"
  script = item.get_script
  puts "\nScript retrieved sucessfully."
  puts script
rescue OneviewSDK::MethodUnavailable => e
  puts "\n#{e}. Available only for C7000."
end

puts "\nDeleting the #{type} with name = '#{item[:name]}' and uri = '#{item[:uri]}''"
item.delete
puts "\nSucessfully deleted #{type} '#{item[:name]}'."
