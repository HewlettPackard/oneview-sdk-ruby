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

require_relative '../_client' # Gives access to @client

# Supported Variants
# Synergy for all api versions

# Resource Class used in this sample
os_deployment_plan_class = OneviewSDK.resource_named('OSDeploymentPlan', @client.api_version, 'Synergy')

puts "\nListing all 'OS Deployment Plans':"
all_deployments_plans = os_deployment_plan_class.get_all(@client)
all_deployments_plans.each { |item| puts "- #{item['name']}" }

puts "\nFinding items by name '#{all_deployments_plans.first['name']}'"
items = os_deployment_plan_class.find_by(@client, name: all_deployments_plans.first['name'])
puts "#{items.size} item found:", items.first.data

puts "\nRetrieving by URI '#{all_deployments_plans.first['uri']}'"
item = os_deployment_plan_class.new(@client, uri: all_deployments_plans.first['uri'])
puts 'Item retrieved: ', item.data if item.retrieve!
