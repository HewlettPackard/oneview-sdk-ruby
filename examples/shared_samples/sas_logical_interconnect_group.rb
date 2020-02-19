# (C) Copyright 2017-2020 Hewlett Packard Enterprise Development LP
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

# Example: Create/Update/Delete sas logical interconnect group only for Synergy
# NOTE: This will create a sas logical interconnect group named 'ONEVIEW_SDK_SAMPLE_SAS_LIG', update it and then delete it.
#
# Supported APIs:
# - 300, 500, 600, 800, 1000, 1200

# Resources that can be created according to parameters:
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::SASLogicalInterconnectGroup
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::SASLogicalInterconnectGroup
# api_version = 600 & variant = Synergy to OneviewSDK::API600::Synergy::SASLogicalInterconnectGroup
# api_version = 800 & variant = Synergy to OneviewSDK::API800::Synergy::SASLogicalInterconnectGroup
# api_version = 1000 & variant = Synergy to OneviewSDK::API1000::Synergy::SASLogicalInterconnectGroup
# api_version = 1200 & variant = Synergy to OneviewSDK::API1200::Synergy::SASLogicalInterconnectGroup

# Resource Class used in this sample
sas_int_group_class = OneviewSDK.resource_named('SASLogicalInterconnectGroup', @client.api_version)

scope_class = OneviewSDK.resource_named('Scope', @client.api_version)

scope = scope_class.get_all(@client).first

type = 'SAS Logical Interconnect Group'

options = {
  name: 'ONEVIEW_SDK_SAMPLE_SAS_LIG',
  initialScopeUris: ['/rest/scopes/ed1e27d2-1940-481b-bf05-a94418ab17dc']
}

item = sas_int_group_class.new(@client, options)

# Add the interconnects to the bays 1 and 4
item.add_interconnect(1, @sas_interconnect_type)
item.add_interconnect(4, @sas_interconnect_type)

puts "\nCreating a #{type} with name = #{item[:name]}."
item.create!
puts "\n#{type} #{item[:name]} created!"

# Gets a  SAS LogicalInterconnectGroup by scopeUris
query = {
  scopeUris: scope['uri']
}
if @client.api_version >= 600
  puts "\nGets a SAS LogicalInterconnectGroup with scope '#{query[:scopeUris]}'"
  item2 = sas_int_group_class.get_all_with_query(@client, query)
  puts "Found SAS LogicalInterconnectGroup'#{item2}'."
end

options2 = {
  name: 'UPDATED_ONEVIEW_SDK_SAMPLE_SAS_LIG '
}

puts "\nUpdating the name of #{type} with name = '#{item[:name]}' to '#{options2[:name]}'."
item.update(options2)
puts "#{type} updated data with new name = '#{options2[:name]}'."

# Clean up after ourselves
puts "\nDeleting #{type} with name = '#{item[:name]}' now..."
item.delete
puts "\nThe #{type} was removed successfully!"
