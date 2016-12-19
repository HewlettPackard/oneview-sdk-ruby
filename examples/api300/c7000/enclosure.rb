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

# Example: Add an enclosure
# NOTE: This will add an enclosure named 'OneViewSDK-Test-Enclosure', then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#   @enclosure_hostname (hostname or IP address)
#   @enclosure_username
#   @enclosure_password
#   @enclosure_group_uri

type = 'enclosure'
options = {
  name: 'OneViewSDK-Test-Enclosure',
  hostname: @enclosure_hostname,
  username: @enclosure_username,
  password: @enclosure_password,
  enclosureGroupUri: @enclosure_group_uri,
  licensingIntent: 'OneView'
}

item = OneviewSDK::API300::C7000::Enclosure.new(@client, options)
item.add
puts "\nAdded #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

item2 = OneviewSDK::API300::C7000::Enclosure.new(@client, name: options[:name])
item2.retrieve!
puts "\nFound #{type} by name: '#{item[:name]}'.\n  uri = '#{item2[:uri]}'"

item.refresh
item.update(name: 'OneViewSDK_Test_Enclosure')
puts "\nUpdated #{type} '#{item[:name]}' sucessfully.\n  uri = '#{item[:uri]}'"

# Patch update
item.patch('replace', '/name', 'Edited_Enclosure')

item.remove
puts "\nSucessfully removed #{type} '#{item[:name]}'."
