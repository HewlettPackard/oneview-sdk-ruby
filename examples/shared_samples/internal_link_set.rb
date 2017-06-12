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
# - 300, 500

# Resources that can be created according to parameters:
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::InternalLinkSet
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::InternalLinkSet
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::InternalLinkSet
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::InternalLinkSet

# Resource Class used in this sample
internal_link_set_class = OneviewSDK.resource_named('InternalLinkSet', @client.api_version)

# List of Internal Link Sets
puts 'List of Internal Link Sets.'
internal_link_set_class.get_internal_link_sets(@client).each do |internal_link_set|
  puts "Internal Link Set #{internal_link_set['name']} URI=#{internal_link_set['uri']}"
end

# Retrieves a specific Internal Link Set
puts 'Retrieves a specific Internal Link Set.'
internal_link_set = internal_link_set_class.get_internal_link_set(@client, 'ils1')
puts "Internal Link Set #{internal_link_set['name']} URI=#{internal_link_set['uri']}" if internal_link_set
