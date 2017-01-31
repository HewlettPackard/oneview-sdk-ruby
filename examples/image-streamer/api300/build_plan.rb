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

# Example: Create a build plan for an API300 Image Streamer
# NOTE: This will create a plan script named 'Build_Plan_1', then delete it.
options = {
  name: 'Build_Plan_1',
  oeBuildPlanType: 'Deploy'
}

# Creating a build plan
item = OneviewSDK::ImageStreamer::API300::BuildPlan.new(@client, options)
puts "\n#Creating a build plan with name #{options[:name]}."
item.create!
item.retrieve!
puts "\n#Build plan with name #{item['name']} and uri #{item['uri']} created successfully."

# List all builds
list = OneviewSDK::ImageStreamer::API300::BuildPlan.get_all(@client)
puts "\n#Listing all:"
list.each { |p| puts "  #{p['name']}" }

id = list.first['uri']
# Gets a build plan by id
puts "\n#Gets a build plan by id #{id}:"
item2 = OneviewSDK::ImageStreamer::API300::BuildPlan.find_by(@client, uri: id).first
puts "\n#Build Plan with id #{item2['uri']} was found."

# Updates a build plan
puts "\n#Updating a build plan with id #{item2['uri']} and name #{item2['name']}:"
item2['name'] = 'Build_Plan_Updated'
item2.update
item2.retrieve!
puts "\n#Build Plan updated successfully with id #{item2['uri']} and new name #{item2['name']}."

# Removes a build plan
puts "\n#Removing a build plan with id #{item2['uri']} and name #{item2['name']}:"
item2.delete
puts "\n#Build plan with id #{item2['uri']} and name #{item2['name']} removed successfully."
