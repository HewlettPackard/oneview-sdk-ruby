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

require_relative '../_client_i3s' # Gives access to @client
# Supported APIs:
# - 300, 500, 600

# Resources that can be created according to parameters:
# api_version = 300 & variant = Synergy to OneviewSDK::ImageStreamer::API300::DeploymentPlan
# api_version = 500 & variant = Synergy to OneviewSDK::ImageStreamer::API500::DeploymentPlan
# api_version = 600 & variant = Synergy to OneviewSDK::ImageStreamer::API600::DeploymentPlan

# Example: Create a deployment plan for an Image Streamer
# NOTE: This will create a deployment plan named 'Deployment_Plan_1', then delete it.
# NOTE: You'll need to add the following instance variables to the _client_i3s.rb file with valid URIs for your environment:
#   @build_plan_name
build_plan_class = OneviewSDK::ImageStreamer.resource_named('BuildPlan', @client.api_version)
build_plan = build_plan_class.find_by(@client, name: @build_plan_name).first
golden_image_class = OneviewSDK::ImageStreamer.resource_named('GoldenImage', @client.api_version)
golden_image = golden_image_class.find_by(@client, name: @golden_image_name).first
deployment_plan_class = OneviewSDK::ImageStreamer.resource_named('DeploymentPlan', @client.api_version)

options = {
  name: 'Deployment_Plan_1',
  description: 'AnyDescription',
  hpProvided: false,
  oeBuildPlanURI: build_plan['uri']
}

options2 = {
  name: 'Deployment_Plan_2',
  description: 'AnyDescription',
  hpProvided: false,
  oeBuildPlanURI: build_plan['uri'],
  goldenImageURI: golden_image['uri']
}

# Creating a deployment plan
item = deployment_plan_class.new(@client, options)
puts "\n#Creating a deployment plan with name #{options[:name]}."
item.create!
item.retrieve!
puts "\n#Deployment plan with name #{item['name']} and uri #{item['uri']} created successfully."

# Creating a deployment plan with a golden image
item2 = deployment_plan_class.new(@client, options2)
puts "\n#Creating a deployment plan with a golden image and name #{options2[:name]}."
item2.create!
item2.retrieve!
puts "\n#Deployment plan with name #{item2['name']} and golden image with uri #{item2['goldenImageURI']} created successfully."

# List all deployments
list = deployment_plan_class.get_all(@client)
puts "\n#Listing all:"
list.each { |p| puts "  #{p['name']}" }

id = list.first['uri']
# Gets a deployment plan by id
puts "\n#Gets a deployment plan by id #{id}:"
item3 = deployment_plan_class.find_by(@client, uri: id).first
puts "\n#Deployment Plan with uri #{item3['uri']} was found."

# Gets a deployment plan by name
puts "\n#Gets a deployment plan by name #{options[:name]}:"
item4 = deployment_plan_class.find_by(@client, name: options[:name]).first
puts "\n#Deployment Plan with name #{item4['uri']} was found."

# Updates a deployment plan
puts "\n#Updating a deployment plan with uri #{item4['uri']} and name #{item4['name']}:"
item4['name'] = 'Deployment_Plan_Updated'
item4.update
item4.retrieve!
puts "\n#Deployment Plan updated successfully with uri #{item4['uri']} and new name #{item4['name']}."

# Removes all deployment plans
puts "\n#Removing a deployment plan with uri #{item3['uri']} and name #{item3['name']}:"
item3.delete
puts "\n#Deployment plan with uri #{item3['uri']} and name #{item3['name']} removed successfully."

puts "\n#Removing a deployment plan with uri #{item4['uri']} and name #{item4['name']}:"
item4.delete
puts "\n#Deployment plan with uri #{item4['uri']} and name #{item4['name']} removed successfully."
