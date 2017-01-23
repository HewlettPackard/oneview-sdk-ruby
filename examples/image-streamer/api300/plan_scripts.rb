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

require_relative '../../_client_i3s' # Gives access to @client

# Example: Create a plan script for an API300 Image Streamer
# NOTE: This will create a plan script named 'Plan_Script_1', then delete it.
options = {
  description: 'Description of this plan script',
  name: 'Plan_Script_1',
  hpProvided: false,
  planType: 'deploy',
  content: 'f'
}

# Creating a plan script
item = OneviewSDK::ImageStreamer::API300::PlanScripts.new(@client, options)
puts "\n#Creating a plan script with name #{options[:name]}."
item.create!
item.retrieve!
puts "\n#Plan script with name #{item['name']} and uri #{item['uri']} created successfully."

# List all plan scripts
list = OneviewSDK::ImageStreamer::API300::PlanScripts.get_all(@client)
puts "\n#Listing all:"
list.each { |p| puts "  #{p['name']}" }

id = list.first['uri']
# Gets a plan script by id
puts "\n#Gets a plan script by id #{id}:"
item2 = OneviewSDK::ImageStreamer::API300::PlanScripts.find_by(@client, uri: id).first
puts "\n#Plan Script with id #{item2['uri']} was found."

# Updates a plan script
puts "\n#Updating a plan script with id #{item2['uri']} and name #{item2['name']}:"
item2['name'] = 'Plan_Script_Updated'
item2.update
item2.retrieve!
puts "\n#Plan script updated successfully with id #{item2['uri']} and new name #{item2['name']}."

# Updates a plan script
puts "\n#Retrieves the modified contents of the selected Plan Script with id #{item2['uri']} and name #{item2['name']}:"
differences = item2.retrieve_differences
puts "\n#Differences retrieved:"
differences.each { |d| puts "  #{d}" }
puts "\n#Plan script updated successfully with id #{item2['uri']} and new name #{item2['name']}."

# Removes a plan script
puts "\n#Removing a plan script with id #{item2['uri']} and name #{item2['name']}:"
item2.delete
puts "\n#Plan script with id #{item2['uri']} and name #{item2['name']} removed successfully."
