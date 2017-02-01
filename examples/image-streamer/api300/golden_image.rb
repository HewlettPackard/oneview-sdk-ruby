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

# Example: Create a golden image for an API300 Image Streamer
# NOTE: This will create a plan script named 'Golden_Image_1', then delete it.

os_volumes = OneviewSDK::ImageStreamer::API300::OsVolumes.find_by($client_i3s_300, {}).first
build_plan = OneviewSDK::ImageStreamer::API300::BuildPlan.find_by($client_i3s_300, oeBuildPlanType: 'capture').first

options = {
  type: 'GoldenImage',
  name: 'Golden_Image_1',
  description: 'Any_Description',
  imageCapture: true
}

# Creating a golden image
item = OneviewSDK::ImageStreamer::API300::GoldenImage.new(@client, options)
item.set_os_volume(os_volumes)
item.set_build_plan(build_plan)
puts "\n#Creating a golden image with name #{options[:name]}."
item.create!
item.retrieve!
puts "\n#Golden Image with name #{item['name']} and uri #{item['uri']} created successfully."

# List all golden images
list = OneviewSDK::ImageStreamer::API300::GoldenImage.get_all(@client)
puts "\n#Listing all:"
list.each { |p| puts "  #{p['name']}" }

id = list.first['uri']
# Gets a golden image by id
puts "\n#Gets a golden image by id #{id}:"
item2 = OneviewSDK::ImageStreamer::API300::GoldenImage.find_by(@client, uri: id).first
puts "\n#Golden Image with id #{item2['uri']} was found."

# Updates a golden image
puts "\n#Updating a golden image with id #{item2['uri']} and name #{item2['name']}:"
item2['name'] = 'Golden_Image_Updated'
item2.update
item2.retrieve!
puts "\n#Golden Image updated successfully with id #{item2['uri']} and new name #{item2['name']}."

# Removes a golden image
puts "\n#Removing a golden image with id #{item2['uri']} and name #{item2['name']}:"
item2.delete
puts "\n#Golden Image with id #{item2['uri']} and name #{item2['name']} removed successfully."
