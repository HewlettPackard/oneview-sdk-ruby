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
# api_version = 1000 & variant = Synergy to OneviewSDK::ImageStreamer::API1000::PlanScript
# api_version = 1020 & variant = Synergy to OneviewSDK::ImageStreamer::API1020::PlanScript
# api_version = 2000 & variant = Synergy to OneviewSDK::ImageStreamer::API2000::PlanScript
# api_version = 2010 & variant = Synergy to OneviewSDK::ImageStreamer::API2010::PlanScript
# api_version = 2020 & variant = Synergy to OneviewSDK::ImageStreamer::API2020::PlanScript

# Example: Create a plan script for an Image Streamer
# NOTE: This will create a plan script named 'Plan_Script_1', then delete it.
options = {
  description: 'Description of this plan script',
  name: 'Plan_Script_1',
  hpProvided: false,
  planType: 'deploy',
  content: 'f'
}

# Creating a plan script
plan_script_class = OneviewSDK::ImageStreamer.resource_named('PlanScript', @client.api_version)
puts "\n#Creating a plan script with name #{options[:name]}."
plan_script = plan_script_class.new(@client, options)
plan_script.create!
plan_script.retrieve!
puts "\n#Plan script with name #{plan_script['name']} and uri #{plan_script['uri']} created successfully."

# List all plan scripts
list = plan_script_class.get_all(@client)
puts "\n#Listing all:"
list.each { |p| puts "  #{p['name']}" }

id = list.first['uri']
# Gets a plan script by id
puts "\n#Gets a plan script by id #{id}:"
item2 = plan_script_class.find_by(@client, uri: id).first
puts "\n#Plan Script with id #{item2['uri']} was found."

# Gets a plan script which is read only artifact
if @client.api_version.to_i >= 600
  puts "\n#Gets a plan script filtered by read only artifacts"
  item3 = plan_script_class.find_by(@client, hpProvided: true).first
  read_only = item3.retrieve_read_only
  puts "\n#readOnly retrieved:"
  read_only.each { |d| puts "  #{d}" }
end
# Updates a plan script
puts "\n#Updating a plan script with id #{item2['uri']} and name #{item2['name']}:"
item2['name'] = 'Plan_Script_Updated'
item2.update
item2.retrieve!
puts "\n#Plan script updated successfully with id #{item2['uri']} and new name #{item2['name']}."

# Removes a plan script
puts "\n#Removing a plan script with id #{item2['uri']} and name #{item2['name']}:"
item2.delete
puts "\n#Plan script with id #{item2['uri']} and name #{item2['name']} removed successfully."

# Creating a plan script to support automation
puts "\n#Creating a plan script with name #{options[:name]}."
plan_script = plan_script_class.new(@client, options)
plan_script.create!
plan_script.retrieve!
puts "\n#Plan script with name #{plan_script['name']} and uri #{plan_script['uri']} created successfully."
