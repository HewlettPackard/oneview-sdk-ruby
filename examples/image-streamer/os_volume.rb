# (C) Copyright 2021 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '../_client_i3s' # Gives access to @client
# Supported APIs:
# - 1000, 1020, 2000, 2010, 2020

# Resources that can be created according to parameters:
# api_version = 1000 & variant = Synergy to OneviewSDK::ImageStreamer::API1000::OSVolume
# api_version = 1020 & variant = Synergy to OneviewSDK::ImageStreamer::API1020::OSVolume
# api_version = 2000 & variant = Synergy to OneviewSDK::ImageStreamer::API2000::OSVolume
# api_version = 2010 & variant = Synergy to OneviewSDK::ImageStreamer::API2010::OSVolume
# api_version = 2020 & variant = Synergy to OneviewSDK::ImageStreamer::API2020::OSVolume

# Example: Os Volume for an Image Streamer
# NOTE: You must have one os volume.
os_volume_class = OneviewSDK::ImageStreamer.resource_named('OSVolume', @client.api_version)
# List all os volume
list = os_volume_class.get_all(@client)
puts "\n#Listing all:"
list.each { |p| puts "  #{p['name']}" }

id = list.first['uri']
# Gets an os volume by id
puts "\n#Gets an os volume by id #{id}:"
item2 = os_volume_class.find_by(@client, uri: id).first
puts "\n#Os Volume with id #{item2['uri']} was found."

# Gets a os volumes storage
if @client.api_version.to_i >= 600
  puts "\n#Gets a os volumes storage"
  os_volumes_storage = item2.get_os_volumes_storage
  puts "\n#os volumes storage retrieved:"
  os_volumes_storage.each { |d| puts "  #{d}" }
end

# Gets the details of the archived os volume
puts "\n#Gets the details of the archived os volume with id #{item2['uri']} and name #{item2['name']}:"
details = item2.get_details_archive
puts "\n#The details of the archived os volume with name #{item2['name']} retrieved successfully."
puts details
