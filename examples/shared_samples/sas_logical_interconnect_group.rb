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

# Example: Create/Update/Delete sas logical interconnect group only for Synergy
# NOTE: This will create a sas logical interconnect group named 'ONEVIEW_SDK_SAMPLE_SAS_LIG', update it and then delete it.
#
# Supported APIs:
# - 300, 500,  600

# Resources that can be created according to parameters:
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::SASLogicalInterconnectGroup
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::SASLogicalInterconnectGroup
# api_version = 600 & variant = Synergy to OneviewSDK::API600::Synergy::SASLogicalInterconnectGroup

# Resource Class used in this sample
sas_int_group_class = OneviewSDK.resource_named('SASLogicalInterconnectGroup', @client.api_version)

type = 'sas-logical-interconnect-group'

options = {
  name: 'ONEVIEW_SDK_SAMPLE_SAS_LIG'
}

item = sas_int_group_class.new(@client, options)

# Add the interconnects to the bays 1 and 4
item.add_interconnect(1, @sas_interconnect_type)
item.add_interconnect(4, @sas_interconnect_type)

puts "\nCreating a #{type} with name = #{item[:name]}."
item.create!
puts "\n#{type} #{item[:name]} created!"

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
