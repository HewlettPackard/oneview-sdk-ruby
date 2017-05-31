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

require_relative '../_client' # Gives access to @client

# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::LogicalDownlink
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::LogicalDownlink
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::LogicalDownlink
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::LogicalDownlink
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::LogicalDownlink

# Resource Class used in this sample
logical_downlink_class = OneviewSDK.resource_named('LogicalDownlink', @client.api_version)

puts "\nGets all logical downlinks"
logical_downlink_class.get_all(@client).each do |link|
  puts link.inspect
end

if @client.api_version < 300
  puts "\nGets a list of logical downlinks, excluding any existing Ethernet networks."
  logical_downlink_class.get_without_ethernet(@client).each do |link|
    puts link.inspect
  end

  puts "\nGets a logical downlink by id, excluding any existing ethernet network."
  item = logical_downlink_class.find_by(@client, {}).first
  link = item.get_without_ethernet
  puts link.inspect
end
