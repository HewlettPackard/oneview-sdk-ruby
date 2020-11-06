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

require_relative '../_client_i3s' # Gives access to @client

# Supported APIs:
# - 1000, 1020, 1600, 2000

# Resources that can be created according to parameters:
# api_version = 1000 & variant = Synergy to OneviewSDK::ImageStreamer::API1000::DeploymentGroup
# api_version = 1020 & variant = Synergy to OneviewSDK::ImageStreamer::API1020::DeploymentGroup
# api_version = 1600 & variant = Synergy to OneviewSDK::ImageStreamer::API1600::DeploymentGroup
# api_version = 2000 & variant = Synergy to OneviewSDK::ImageStreamer::API2000::DeploymentGroup

# Example:
# - Gets the Deployment Groups
# NOTE: It needs an existing DeploymentGroup

deployment_group_class = OneviewSDK::ImageStreamer.resource_named('DeploymentGroup', @client.api_version)

# List all deployments
list = deployment_group_class.get_all(@client)
puts "\n#Listing all Deployment Groups:"
list.each { |p| puts "  #{p['name']}" }
