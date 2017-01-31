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

require_relative '../../_client_i3s' # Gives access to @client

# Example: Os Volumes for an API300 Image Streamer
# NOTE: You must have one os volume.

# List all os volumes
list = OneviewSDK::ImageStreamer::API300::OsVolumes.get_all(@client)
puts "\n#Listing all:"
list.each { |p| puts "  #{p['name']}" }

id = list.first['uri']
# Gets an os volume by id
puts "\n#Gets an os volume by id #{id}:"
item2 = OneviewSDK::ImageStreamer::API300::OsVolumes.find_by(@client, uri: id).first
puts "\n#Os Volume with id #{item2['uri']} was found."


# Gets the details of the archived os volume
puts "\n#Gets the details of the archived os volume with id #{item2['uri']} and name #{item2['name']}:"
details = item2.get_details_archive
puts details
# puts "\n#Plan script updated successfully with id #{item2['uri']} and new name #{item2['name']}."

# # Updates a plan script
# puts "\n#Retrieves the modified contents of the selected Plan Script with id #{item2['uri']} and name #{item2['name']}:"
# differences = item2.retrieve_differences
# puts "\n#Differences retrieved:"
# differences.each { |d| puts "  #{d}" }
# puts "\n#Plan script updated successfully with id #{item2['uri']} and new name #{item2['name']}."
#
# # Removes a plan script
# puts "\n#Removing a plan script with id #{item2['uri']} and name #{item2['name']}:"
# item2.delete
# puts "\n#Plan script with id #{item2['uri']} and name #{item2['name']} removed successfully."
