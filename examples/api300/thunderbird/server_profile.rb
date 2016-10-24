# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the specific
# language governing permissions and limitations under the License.

require_relative '../_client' # Gives access to @client

# Example: Create a server profile
# NOTE: This will create a server profile named 'OneViewSDK Test ServerProfile', then delete it.

profile = OneviewSDK::API300::Thunderbird::ServerProfile.new(@client, 'name' => 'OneViewSDK Test ServerProfile')

target = OneviewSDK::API300::Thunderbird::ServerProfile.get_available_targets(@client)['targets'].first

server_hardware = OneviewSDK::API300::Thunderbird::ServerHardware.new(@client, uri: target['serverHardwareUri'])
server_hardware_type = OneviewSDK::API300::Thunderbird::ServerHardwareType.new(@client, uri: target['serverHardwareTypeUri'])
enclosure_group = OneviewSDK::API300::Thunderbird::EnclosureGroup.new(@client, uri: target['enclosureGroupUri'])

profile.set_server_hardware(server_hardware)
profile.set_server_hardware_type(server_hardware_type)
profile.set_enclosure_group(enclosure_group)

profile.create
puts "\nCreated server profile '#{profile[:name]}' sucessfully.\n  uri = '#{profile[:uri]}'"

# Find recently created server profile by name
matches = OneviewSDK::API300::Thunderbird::ServerProfile.find_by(@client, name: profile[:name])
profile2 = matches.first
puts "\nFound server profile by name: '#{profile[:name]}'.\n  uri = '#{profile2[:uri]}'"

# Retrieve recently created server profile
profile3 = OneviewSDK::API300::Thunderbird::ServerProfile.new(@client, name: profile[:name])
profile3.retrieve!
puts "\nRetrieved server profile data by name: '#{profile[:name]}'.\n  uri = '#{profile3[:uri]}'"

# Delete this profile
profile.delete
puts "\nSucessfully deleted profile '#{profile[:name]}'."

# SAS Logical JBOD
OneviewSDK::API300::Thunderbird::ServerProfile.get_sas_logical_jbods(@client).each do |item|
  puts "Name: #{item['name']}\nURI: #{item['uri']}"
end
