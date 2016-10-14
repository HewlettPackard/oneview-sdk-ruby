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

# Gets all Drive Enclosures currently in the Appliance
puts 'Listing all Drive Enclosures below:'
OneviewSDK::API300::Thunderbird::DriveEnclosure.find_by(@client, {}).each do |drive_enclosure|
  puts "Name: '#{drive_enclosure['name']}', uri: '#{drive_enclosure['uri']}'"
end

drive_enclosure = OneviewSDK::API300::Thunderbird::DriveEnclosure.find_by(@client, {}).first

# Gets a specific Drive Enclosure port map information
puts drive_enclosure.get_port_map

# Sets the Drive Enclosure refresh state to RefreshPending
drive_enclosure.set_refresh_state('RefreshPending')

# Sends a patch update to the Drive Enclosure
drive_enclosure.patch('replace', '/uidState', 'On')
