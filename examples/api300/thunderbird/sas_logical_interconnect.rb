# (C) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# You may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.

require_relative '../../_client' # Gives access to @client

type = 'SAS Logical Interconnect'

options = {
  name:  'LogicalEnclosure_1-SASLogicalInterconnectGroup_1-1'
}
sas_li = OneviewSDK::API300::Thunderbird::SASLogicalInterconnect.find_by(@client, options).first

# Prints the name and uri of all SAS Logical Interconnects
OneviewSDK::API300::Thunderbird::SASLogicalInterconnect.find_by(@client, {}).each do |sasli|
  puts "\n #{type} name: #{sasli['name']} uri: #{sasli['uri']} \n"
end

# Returns a SAS logical interconnect to a consistent state.
sas_li.compliance

# Gets the installed firmware for a SAS logical interconnect.
puts "\n Firmware information for the #{type} name: #{sas_li['name']}: \n"
puts sas_li.get_firmware

# Asynchronously applies or re-applies the SAS logical interconnect configuration to all managed interconnects
puts "\n Configuration data for the #{type} name: #{sas_li['name']}: \n"
puts sas_li.configuration.data

# Initiates the replacement operation after a drive enclosure has been physically replaced.
# puts sas_li.replace_drive_enclosure('SN123100', 'SN123102')

# # Update the firmware for a SAS logical interconnect.
# firmware_driver = OneviewSDK::API300::Thunderbird::FirmwareDriver.find_by(@client, name: 'Service Pack Sample').first
# firmware_options = {
#   force: 'false'
# }
# puts sas_li.firmware_update('stage', firmware_driver, firmware_options)
