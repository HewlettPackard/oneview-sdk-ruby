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
# api_version = 300 & variant = Synergy to OneviewSDK::ImageStreamer::API300::BuildPlan
# api_version = 500 & variant = Synergy to OneviewSDK::ImageStreamer::API500::BuildPlan
# api_version = 600 & variant = Synergy to OneviewSDK::ImageStreamer::API600::BuildPlan

# Example: Create a build plan for an API300 Image Streamer
# NOTE: This will create three build plans with the following names 'Build_Plan_1', 'Build_Plan_2' and 'Build_Plan_3', then delete them.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#   @plan_script1_name
#   @plan_script2_name (plan script with build step and custom attributes)

options = {
  name: 'Build_Plan_1',
  oeBuildPlanType: 'Deploy'
}
options_plan_script = {
  description: 'Description of this plan script',
  name: @plan_script2_name,
  hpProvided: false,
  planType: 'deploy',
  content: 'esxcli system hostname set --domain "@DomainName@"'
}
plan_script_class = OneviewSDK::ImageStreamer.resource_named('PlanScript', @client.api_version)
plan_script = plan_script_class.find_by(@client, name: @plan_script1_name).first
puts "\n#Creating a plan script with name #{options_plan_script[:name]}."
plan_script2 = plan_script_class.new(@client, options_plan_script)
plan_script2.create!
plan_script2.retrieve!
puts "\n#Plan script with name #{plan_script2['name']} and uri #{plan_script2['uri']} created successfully."

# plan_script2 = plan_script_class.find_by(@client, name: @plan_script2_name).first
custom_attributes = JSON.parse(plan_script2['customAttributes'])

custom_attributes.replace([custom_attributes[0].merge('type' => 'String')])

build_plan_class = OneviewSDK::ImageStreamer.resource_named('BuildPlan', @client.api_version)
build_step = [
  {
    serialNumber: '1',
    parameters: 'anystring',
    planScriptName: @plan_script1_name,
    planScriptUri: plan_script['uri']
  }
]

build_step2 = [
  {
    serialNumber: '1',
    parameters: 'anystring',
    planScriptName: @plan_script2_name,
    planScriptUri: plan_script2['uri']
  }
]

options2 = {
  name: 'Build_Plan_2',
  oeBuildPlanType: 'Deploy',
  buildStep: build_step
}

options3 = {
  name: 'Build_Plan_3',
  oeBuildPlanType: 'Deploy',
  buildStep: build_step2,
  customAttributes: custom_attributes
}

# Creating a build plan
item = build_plan_class.new(@client, options)
puts "\n#Creating a build plan with name #{options[:name]}."
item.create!
item.retrieve!
puts "\n#Build plan with name #{item['name']} and uri #{item['uri']} created successfully."

# Creating a build plan with build steps
item2 = build_plan_class.new(@client, options2)

puts "\n#Creating a build plan with name #{options2[:name]}."
item2.create!
item2.retrieve!
puts "\n#Build plan with name #{item2['name']} and uri #{item2['uri']} created successfully."

# Creating a build plan with custom attributes
item3 = build_plan_class.new(@client, options3)

puts "\n#Creating a build plan with name #{options3[:name]}."
item3.create!
item3.retrieve!
puts "\n#Build plan with name #{item3['name']} and uri #{item3['uri']} created successfully."

# List all builds
list = build_plan_class.get_all(@client)
puts "\n#Listing all:"
list.each { |p| puts "  #{p['name']}" }

id = list.first['uri']
# Gets a build plan by id
puts "\n#Gets a build plan by id #{id}:"
item4 = build_plan_class.find_by(@client, uri: id).first
puts "\n#Build Plan with id #{item4['uri']} was found."

# Updates a build plan
item5 = build_plan_class.find_by(@client, name: 'Build_Plan_1').first
puts "\n#Updating a build plan with id #{item5['uri']} and name #{item5['name']}:"
item5['name'] = 'Build_Plan_Updated'
item5.update
item5.retrieve!
puts "\n#Build Plan updated successfully with id #{item5['uri']} and new name #{item5['name']}."

# Removes all build plan
puts "\n#Removing a build plan with id #{item2['uri']} and name #{item2['name']}:"
item2.delete
puts "\n#Build plan with id #{item2['uri']} and name #{item2['name']} removed successfully."
puts "\n#Removing a build plan with id #{item3['uri']} and name #{item3['name']}:"
plan_script2.delete
item3.delete
puts "\n#Build plan with id #{item3['uri']} and name #{item3['name']} removed successfully."
puts "\n#Removing a build plan with id #{item5['uri']} and name #{item5['name']}:"
item5.delete
puts "\n#Build plan with id #{item5['uri']} and name #{item5['name']} removed successfully."
