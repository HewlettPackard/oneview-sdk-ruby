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

# Example: Actions with Fabric
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::Fabric
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::Fabric
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::Fabric
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::Fabric
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::Fabric

# Resource Class used in this sample
fabric_class = OneviewSDK.resource_named('Fabric', @client.api_version)

puts "\nListing all fabrics available:"
all_fabrics = fabric_class.get_all(@client)
all_fabrics.each do |fabric|
  puts fabric['name']
end

fabric_name = 'DefaultFabric'
puts "\nRetrieving the Fabric named: #{fabric_name}"
fabric2 = fabric_class.new(@client, 'name' => fabric_name)
fabric2.retrieve!
puts "\nFabric retrieved successfully! \n#{fabric2.data}"

puts "\nGetting the reserved vlan ID range for the fabric: #{fabric2['name']}."
begin
  vlan_range = fabric2.get_reserved_vlan_range
  puts vlan_range
rescue NoMethodError
  puts 'The method #get_reserved_vlan_range is available only for Synergy.'
end

puts "\nUpdating the reserved vlan ID range for the fabric: #{fabric2['name']}."
begin
  fabric_options = {
    start: 100,
    length: 100,
    type: 'vlan-pool'
  }

  fabric2.set_reserved_vlan_range(fabric_options)
  puts "\nThe reserved vlan ID range updated successfully!"
  puts fabric2.get_reserved_vlan_range
rescue NoMethodError
  puts 'The method #set_reserved_vlan_range is available only for Synergy.'
end
