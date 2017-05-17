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
# - 300, 500 both api versions only for Synergy

# Resources that can be created according to parameters:
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::SASLogicalInterconnect
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::SASLogicalInterconnect

# Resource Class used in this sample
sas_log_int_class = OneviewSDK.resource_named('SASLogicalInterconnect', @client.api_version)

type = 'SAS Logical Interconnect'

item = sas_log_int_class.get_all(@client).first

# Prints the name and uri of all SAS Logical Interconnects
sas_log_int_class.find_by(@client, {}).each do |sasli|
  puts "\n #{type} name: #{sasli['name']} uri: #{sasli['uri']} \n"
end

# Returns a SAS logical interconnect to a consistent state.
item.compliance

# Gets the installed firmware for a SAS logical interconnect.
puts "\n Firmware information for the #{type} name: #{item['name']}: \n"
puts item.get_firmware

# Asynchronously applies or re-applies the SAS logical interconnect configuration to all managed interconnects
puts "\n Configuration data for the #{type} name: #{item['name']}: \n"
puts item.configuration.data
