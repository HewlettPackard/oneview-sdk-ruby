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
# NOTE: This will create a golden images named 'Golden_Image_1' and 'Golden_Image_2', and then, it will delete them.
# NOTE: You'll need to add the following instance variables to the _client_i3s.rb file with valid URIs for your environment:
#   @golden_image_download_path
#   @golden_image_upload_path
#   @golden_image_log_path

os_volume = OneviewSDK::ImageStreamer::API300::OSVolume.find_by(@client, {}).first
build_plan = OneviewSDK::ImageStreamer::API300::BuildPlan.find_by(@client, oeBuildPlanType: 'capture').first

options = {
  type: 'GoldenImage',
  name: 'Golden_Image_1',
  description: 'Any_Description',
  imageCapture: true
}

# Creating a golden image
item = OneviewSDK::ImageStreamer::API300::GoldenImage.new(@client, options)
item.set_os_volume(os_volume)
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

# Gets a golden image by name
puts "\n#Gets a golden image by name #{options[:name]}:"
item3 = OneviewSDK::ImageStreamer::API300::GoldenImage.find_by(@client, name: options[:name]).first
puts "\n#Golden Image with name #{item2['name']} was found."

# Updates a golden image
puts "\n#Updating a golden image with id #{item3['uri']} and name #{item3['name']}:"
item3['name'] = 'Golden_Image_Updated'
item3.update
item3.retrieve!
puts "\n#Golden Image updated successfully with id #{item3['uri']} and new name #{item3['name']}."

# Gets details of the golden image capture logs
puts "\nGetting details of the golden image capture logs with id #{item3['uri']} and name #{item3['name']}"
item3.download_details_archive(@golden_image_log_path)
puts "\nDetails of the golden image save successfully."

# Adds a golden image resource from the file that is uploaded from a local drive
puts "\nAdds a golden image resource from the file that is uploaded from a local drive"
options2 = { name: 'Golden_Image_2', description: 'Any_Description' }
puts "\nAdding a golden image with name #{options2[:name]}."
item4 = OneviewSDK::ImageStreamer::API300::GoldenImage.add(@client, @golden_image_upload_path, options2)
puts "\nGolden Image with uri #{item4['uri']} and name #{item4['name']} added successfully."

# Downloads the content of the selected golden image
puts "\nDownloads the content of the selected golden image with id #{item3['uri']} and name #{item3['name']}"
item3.download(@golden_image_download_path)
puts "\nDownload done successfully."

# Removes all golden images
puts "\n#Removing a golden image with id #{item3['uri']} and name #{item3['name']}:"
item3.delete
puts "\n#Golden Image with id #{item3['uri']} and name #{item3['name']} was removed successfully."
puts "\n#Removing a golden image with id #{item4['uri']} and name #{item4['name']}:"
item4.delete
puts "\n#Golden Image with id #{item4['uri']} and name #{item4['name']} was removed successfully."
