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

# Example: Actions with drive enclosure
#
# Supported APIs:
# - 300, 500 only for Synergy.

# Resources that can be created according to parameters:
# api_version = 300 & variant = Synergy to drive_encl_class
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::DriveEnclosure

# Resource Class used in this sample
drive_encl_class = OneviewSDK.resource_named('DriveEnclosure', @client.api_version)

# Gets all Drive Enclosures currently in the Appliance
puts 'Listing all Drive Enclosures below:'
drive_encl_class.find_by(@client, {}).each do |drive_enclosure|
  puts "Name: '#{drive_enclosure['name']}', uri: '#{drive_enclosure['uri']}'"
end

item = drive_encl_class.find_by(@client, {}).first

# Gets a specific Drive Enclosure port map information
puts "\nGets a specific Drive Enclosure port map information:"
puts item.get_port_map

# Sets the Drive Enclosure refresh state to RefreshPending
puts "\nSets the Drive Enclosure refresh state to RefreshPending."
item.set_refresh_state('RefreshPending')
puts "\nOperation done successfully."

# Sends a patch update to the Drive Enclosure
old_state = item['uidState']
new_state = old_state == 'On' ? 'Off' : 'On'
puts "\nChanging the uid state with a patch. Current state = '#{item['uidState']}'"
item.patch('replace', '/uidState', new_state)
item.retrieve!
puts "\nThe uid state with a new state = '#{item['uidState']}'"
puts "\nReturning to original state"
item.patch('replace', '/uidState', old_state)
item.retrieve!
puts "\nThe uid state with the original state = '#{item['uidState']}'"
