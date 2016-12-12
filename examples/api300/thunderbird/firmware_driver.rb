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

# NOTE: This will create a custom firmware driver, then delete it.
# The OneView appliance must have a valid spp and hotfix

# List firmware drivers
puts "\nAvailable firmware drivers"
OneviewSDK::API300::Thunderbird::FirmwareDriver.find_by(@client, {}).each do |firmware|
  puts firmware['name']
end

spp = OneviewSDK::API300::Thunderbird::FirmwareDriver.find_by(@client, state: 'Created', bundleType: 'SPP').first
hotfix = OneviewSDK::API300::Thunderbird::FirmwareDriver.find_by(@client, state: 'Created', bundleType: 'Hotfix').first

custom_spp = OneviewSDK::API300::Thunderbird::FirmwareDriver.new(@client)
custom_spp['baselineUri'] = spp['uri']
custom_spp['hotfixUris'] = [
  hotfix['uri']
]
custom_spp['customBaselineName'] = 'FirmwareDriver1_Example'

# Example: Create firmware driver
custom_spp.create
puts "\nSucessfully created '#{custom_spp['name']}' with uri '#{custom_spp['uri']}'."

# Example: Delete firmware driver
custom_spp.remove
puts "\nSucessfully deleted '#{custom_spp['name']}'."
