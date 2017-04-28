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
# NOTE: This will create an ethernet network named 'OneViewSDK Test Logical Enclosure', update it and then delete it.
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::LogicalEnclosure
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::LogicalEnclosure
# api_version = 300 & variant = Synergy to logical_enclosure_class
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::LogicalEnclosure
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::LogicalEnclosure

type = 'logical enclosure'
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

  puts "\nCreating a #{type} with the name = '#{options[:name]}'."
  item = logical_enclosure_class.new(@client, options)
  # set an enclosure group with enclosure count = 3
  enclosure_group = encl_group_class.find_by(@client, name: 'EnclosureGroup_2').first
  item.set_enclosure_group(enclosure_group)

  # set an enclosure
  enclosure1 = enclosure_class.find_by(@client, name: '0000A66101').first
  enclosure2 = enclosure_class.find_by(@client, name: '0000A66102').first
  enclosure3 = enclosure_class.find_by(@client, name: '0000A66103').first
  item.set_enclosures([enclosure1, enclosure2, enclosure3])

  item.create
  puts "\nCreated a #{type} '#{item[:name]}' successfully.\n  uri = '#{item[:uri]}'"
end

puts "\nListing all logical enclosures:"
itens = logical_enclosure_class.get_all(@client)
itens.each do |i|
  puts i['name']
end

log_encl_name = itens.first['name']
log_encl_uri = itens.first['uri']

# retrieve a #{type}
item2 = logical_enclosure_class.new(@client, name: log_encl_name)
puts "\nRetrieve a #{type} with name '#{log_encl_name}'"
item2.retrieve!
puts "\nFound by name: '#{item2[:name]}'.\n  uri = '#{item2[:uri]}'"

# Gets a logical enclosure by uri
puts "\nGets a logical enclosure with uri '#{log_encl_uri}'"
item3 = logical_enclosure_class.find_by(@client, uri: log_encl_uri).first
puts "Found #{type} '#{item3[:uri]}'."

puts "\nUpdating a #{type} with the name = '#{item3['name']}'."
old_name = item3['name']
item3.update(name: "#{item3['name']}_Updated")
item3.retrieve!
puts "\n#{type} updated successfully and new name = '#{item3['name']}'."
puts "\nUpdating to original name."
item3.update(name: old_name)
item3.retrieve!
puts "\n#{type} updated successfully and returned to original name = '#{item3['name']}'."

# Reconfigure script
puts "\nReconfiguring a #{type}"
item3.reconfigure
puts "\nOperation performed successfully."

if @client.api_version <= 200 || variant == 'C7000' || (variant == 'Synergy' && @client.api_version < 500)
  # Get configuration script
  puts "\nGetting a #{type} script"
  orig_script = item3.get_script
  puts "\nRetrieved #{type} '#{item3['name']}' script\n  Content = '#{orig_script}'"
end

if @client.api_version <= 200 || variant == 'C7000'
  # Set configuration script
  puts "\nSetting a #{type} script"
  item3.set_script(orig_script)
  puts "\nOperation performed successfully."
end

# Update from Group
puts "\nUpdate from Group"
item3.update_from_group
puts "#{type} updated successfully."


if @client.api_version >= 300
  item3.retrieve!
  # Performs a patch
  puts "Performs a patch on #{type} #{item3['name']}"
  value = {
    firmwareUpdateOn: 'SharedInfrastructureOnly',
    forceInstallFirmware: false,
    updateFirmwareOnUnmanagedInterconnect: true
  }

  item3.patch(value)
  puts "Patch perfomed successfully on #{type} #{item3['name']}"
end

# Generate dump
dump = {
  errorCode: 'test',
  excludeApplianceDump: true
}
puts 'Generate dump'
item3.support_dump(dump)
puts "\nGenerated dump for #{type} '#{item3['name']}'."

if variant == 'Synergy'
  puts "Removing the #{type}"
  item3.delete
  puts "\nRemoved #{type} '#{item3['name']}'."
end
