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

# Example: Actions with a firmware bundle resource
# NOTE: This will upload a firmware bundle
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::FirmwareBundle
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::FirmwareBundle
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::FirmwareBundle
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::FirmwareBundle
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::FirmwareBundle

# Resource Class used in this sample
fw_bundle_class = OneviewSDK.resource_named('FirmwareBundle', @client.api_version)

puts "\nAdding firmware bundle 'Hotfix'."
item = fw_bundle_class.add(@client, @firmware_bundle_hotfix_path)
puts "\nFirmware bundle '#{item['name']}' with uri '#{item['uri']}' added successfully."

puts "\nAdding firmware bundle 'SPP'."
item = fw_bundle_class.add(@client, @firmware_bundle_spp_path)
puts "\nFirmware bundle '#{item['name']}' with uri '#{item['uri']}' added successfully."
