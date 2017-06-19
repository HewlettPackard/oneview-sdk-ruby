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

# Example: Add/Remove firmware driver
# NOTE: This will create a custom firmware driver, then delete it.
# The OneView appliance must have a valid spp and hotfix
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::FirmwareDriver
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::FirmwareDriver
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::FirmwareDriver
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::FirmwareDriver
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::FirmwareDriver

# Resource Class used in this sample
fw_driver_class = OneviewSDK.resource_named('FirmwareDriver', @client.api_version)

# List firmware drivers
puts "\nAvailable firmware drivers"
fw_driver_class.find_by(@client, {}).each do |firmware|
  puts firmware['name']
end

spp = fw_driver_class.find_by(@client, state: 'Created', bundleType: 'SPP').first
hotfix = fw_driver_class.find_by(@client, state: 'Created', bundleType: 'Hotfix').first

custom_spp = fw_driver_class.new(@client)
custom_spp['baselineUri'] = spp['uri']
custom_spp['hotfixUris'] = [
  hotfix['uri']
]
custom_spp['customBaselineName'] = 'FirmwareDriver1_Example'

puts "\nCreating a firmware driver"
custom_spp.create
puts "\nFirmware Driver created sucessfully. \n Name: '#{custom_spp['name']}' \n URI '#{custom_spp['uri']}'."

puts "\nRemoving a firmware driver"
custom_spp.remove
puts "\nFirmware Driver deleted sucessfully. \n Name: '#{custom_spp['name']}'."
