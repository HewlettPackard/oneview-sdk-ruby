# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

volume_attachment_class = OneviewSDK.resource_named('VolumeAttachment', @client.api_version)

# List volume attachments
puts "\nVolume attachments available: "
volume_attachment_class.get_all(@client).each do |volume_attachment|
  puts "- URI: '#{volume_attachment['uri']}' | Owner URI: '#{volume_attachment['ownerUri']}'"
end

# List extra unmanaged storage volumes
extra_managed_volumes = volume_attachment_class.get_extra_unmanaged_volumes(@client)
puts "\nUnmanaged volumes: " unless extra_managed_volumes.empty?
extra_managed_volumes.each do |unmanaged_volume|
  puts unmanaged_volume.data
  puts "- URI: '#{volume_attachment['uri']}' | Owner URI: '#{volume_attachment['ownerUri']}'"
end

volume_attachment = volume_attachment_class.get_all(@client).first

# List volume attachment paths
if @client.api_version <= 300 && volume_attachment
  volume_paths = volume_attachment.get_paths
  puts "\nVolume #{volume_attachment['hostName']} paths: " unless volume_paths.empty?
  volume_paths.each do |path|
    puts "- #{path['initiatorName']}"
  end
end