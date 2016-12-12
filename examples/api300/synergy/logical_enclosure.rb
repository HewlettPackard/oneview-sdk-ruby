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

options = {
  name: 'Log_Encl1',
  forceInstallFirmware: false,
  firmwareBaselineUri: nil
}

logical_enclosure = OneviewSDK::API300::Synergy::LogicalEnclosure.new(@client, options)

# set an enclosure group
enclosure_group = OneviewSDK::API300::Synergy::EnclosureGroup.find_by(@client, {}).first
logical_enclosure.set_enclosure_group(enclosure_group)

# set an enclosure
enclosure = OneviewSDK::API300::Synergy::Enclosure.find_by(@client, {}).first
logical_enclosure.set_enclosures([enclosure])

# create a logical-enclosure
puts "\nCreate a logical-enclosure with name '#{logical_enclosure[:name]}'"
logical_enclosure.create!
puts "\nCreated a logical-enclosure '#{logical_enclosure[:name]}' sucessfully.\n  uri = '#{logical_enclosure[:uri]}'"

logical_enclosure2 = OneviewSDK::API300::Synergy::EnclosureGroup.new(@client, name: options[:name])
# retrieve a logical-enclosure
puts "\nRetrieve a logical-enclosure with name '#{logical_enclosure2[:name]}'"
logical_enclosure2.retrieve!
puts "\nFound by name: '#{logical_enclosure2[:name]}'.\n  uri = '#{logical_enclosure2[:uri]}'"

# Get first logical enclosure
logical_enclosure3 = OneviewSDK::API300::Synergy::LogicalEnclosure.find_by(@client, {}).first
puts "Found logical-enclosure '#{logical_enclosure[:name]}'."

# Get configuration script
orig_script = logical_enclosure3.get_script
puts "Retrieved logical-enclosure '#{logical_enclosure[:name]}' script\n  Content = '#{orig_script}'"

# Update from Group
logical_enclosure3.update_from_group
puts 'Logical enclosure updated'

# Performs a patch
puts "Performs a patch on logical-enclosure #{logical_enclosure[:name]}"
value = {
  firmwareUpdateOn: 'SharedInfrastructureOnly',
  forceInstallFirmware: false,
  updateFirmwareOnUnmanagedInterconnect: true
}

logical_enclosure3.patch(value)
puts "Patch perfomed successfully on logical-enclosure #{logical_enclosure[:name]}"

# Generate dump
dump = {
  errorCode: 'test',
  excludeApplianceDump: true
}
puts 'Generate dump'
logical_enclosure3.support_dump(dump)
puts "\nGenerated dump for logical-enclosure '#{logical_enclosure[:name]}'."

puts 'Removing the logical-enclosure'
logical_enclosure3.delete
puts "\nRemoved logical-enclosure '#{logical_enclosure[:name]}'."
