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
# - 300, 500 Synergy only

# Resources that can be created according to parameters:
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::SASInterconnect
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::SASInterconnect

# Resource Class used in this sample
sas_int_class = OneviewSDK.resource_named('SASInterconnect', @client.api_version)

type = 'SAS Interconnect'

# Gets all types of SAS interconnects supported by the appliance
puts "\nListing all SAS Interconnect types supported by the appliance below:"
sas_int_class.get_types(@client).each do |interconnect_type|
  puts "SAS Interconnect type: '#{interconnect_type['name']}', uri: '#{interconnect_type['uri']}'"
end

# Getting a specific type of SAS interconnect
puts "\n\nSpecifically retrieving SAS Interconnect type '#{@sas_interconnect_type}':"
sas_int_type = sas_int_class.get_type(@client, @sas_interconnect_type)
puts "SAS Interconnect type '#{sas_int_type['name']}' uri: '#{sas_int_type['uri']}'"

# Gets all SAS interconnects on the appliance
puts "\nListing all SAS Interconnects on the appliance below:"
sas_int_class.find_by(@client, {}).each do |interconnect|
  puts "SAS Interconnect name: '#{interconnect['name']}', uri: '#{interconnect['uri']}'"
end

item = sas_int_class.find_by(@client, {}).first

# Sets a refresh state to the SAS interconnect
puts "\nSetting the refresh state of the #{type} '#{item['name']}' to 'RefreshPending'..."
puts item.set_refresh_state('RefreshPending')

# Uses patch to hard reset a SAS interconnect
puts "\nRunning a patch operation on the #{type} '#{item['name']}' to reset it..."
puts item.patch('replace', '/hardResetState', 'Reset')
