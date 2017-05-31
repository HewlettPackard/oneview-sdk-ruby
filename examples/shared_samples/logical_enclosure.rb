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

# Example: Create/Update/Delete logical enclosure
# NOTE: This will create a logical enclosure named 'OneViewSDK Test Logical Enclosure', update it and then delete it.
# To run this test with Synergy you must have an enclosureGroup with enclosure count = 3.
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::LogicalEnclosure
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::LogicalEnclosure
# api_version = 300 & variant = Synergy to OneviewSDK::API500::Synergy::LogicalEnclosure
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::LogicalEnclosure
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::LogicalEnclosure

# Resource Class used in this sample
logical_enclosure_class = OneviewSDK.resource_named('LogicalEnclosure', @client.api_version)

# Scope class used in this sample
encl_group_class = OneviewSDK.resource_named('EnclosureGroup', @client.api_version)
enclosure_class = OneviewSDK.resource_named('Enclosure', @client.api_version)

variant = OneviewSDK.const_get("API#{@client.api_version}").variant unless @client.api_version < 300

if variant == 'Synergy'
  options = {
    name: 'OneViewSDK Test Logical Enclosure',
    forceInstallFirmware: false,
    firmwareBaselineUri: nil
  }

  puts "\nCreating a logical enclosure with the name = '#{options[:name]}'."
  item = logical_enclosure_class.new(@client, options)
  # set an enclosure group with enclosure count = 3
  enclosure_group = encl_group_class.find_by(@client, enclosureCount: 3).first
  item.set_enclosure_group(enclosure_group)

  # set the enclosures
  enclosure1 = enclosure_class.find_by(@client, name: '0000A66101').first
  enclosure2 = enclosure_class.find_by(@client, name: '0000A66102').first
  enclosure3 = enclosure_class.find_by(@client, name: '0000A66103').first
  item.set_enclosures([enclosure1, enclosure2, enclosure3])

  item.create
  sleep(10)
  puts "\nCreated a logical enclosure '#{item[:name]}' successfully.\n  uri = '#{item[:uri]}'"
end

puts "\nListing all logical enclosures:"
items = logical_enclosure_class.get_all(@client)
items.each do |i|
  puts i['name']
end

log_encl_name = items.first['name']
log_encl_uri = items.first['uri']

# retrieve a logical enclosure
item2 = logical_enclosure_class.new(@client, name: log_encl_name)
puts "\nRetrieves a logical enclosure by name: '#{log_encl_name}'"
item2.retrieve!
puts "\nFound by name: '#{item2[:name]}'.\n  uri = '#{item2[:uri]}'"

# Gets a logical enclosure by uri
puts "\nGets a logical enclosure with uri '#{log_encl_uri}'"
item3 = logical_enclosure_class.find_by(@client, uri: log_encl_uri).first
puts "Found logical enclosure '#{item3[:uri]}'."

puts "\nUpdating a logical enclosure with the name = '#{item3['name']}'."
old_name = item3['name']
item3.update(name: "#{item3['name']}_Updated")
item3.retrieve!
puts "\nlogical enclosure updated successfully and new name = '#{item3['name']}'."
puts "\nUpdating to original name."
item3.update(name: old_name)
item3.retrieve!
puts "\nlogical enclosure updated successfully and returned to original name = '#{item3['name']}'."

# Reconfigure script
puts "\nReconfiguring a logical enclosure"
item3.reconfigure
puts "\nOperation performed successfully."

orig_script = nil

# Get configuration script
puts "\nGetting a logical enclosure script"
begin
  orig_script = item3.get_script
  puts "\nRetrieved logical enclosure '#{item3['name']}' script\n  Content = '#{orig_script}'"
rescue OneviewSDK::MethodUnavailable => e
  puts "\n#{e}. Available only for C7000."
end

# Set configuration script
puts "\nSetting a logical enclosure script"
begin
  item3.set_script(orig_script)
  puts "\nOperation performed successfully."
rescue OneviewSDK::MethodUnavailable => e
  puts "\n#{e}. Available only for C7000."
end

# Update from Group
puts "\nUpdate from Group"
item3.update_from_group
puts "\nlogical enclosure updated successfully."

item3.retrieve!
# Performs a patch
puts "Updating the firmware of the logical enclosure #{item3['name']}"
begin
  value = {
    firmwareUpdateOn: 'SharedInfrastructureOnly',
    forceInstallFirmware: false,
    updateFirmwareOnUnmanagedInterconnect: true
  }

  item3.update_firmware(value)
  sleep(10)
  puts "Firmware updated successfully on logical enclosure #{item3['name']}"
rescue NoMethodError
  puts "\nThe method #update_firmware is available from API 300 onwards.."
end

# Generate dump
dump = {
  errorCode: 'test',
  excludeApplianceDump: true
}
puts 'Generate support dump'
item3.support_dump(dump)
puts "\nGenerated dump for logical enclosure '#{item3['name']}'."

if variant == 'Synergy'
  puts "\nRemoving the logical enclosure"
  item3.delete
  puts "\nRemoved logical enclosure '#{item3['name']}'."
end
