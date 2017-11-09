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
require 'json'
# Example: List the current and minimum version
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::Version
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::Version
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::Version
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::Version
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::Version

# Resource Class used in this sample
version_class = OneviewSDK.resource_named('Version', @client.api_version)

# List the current and minimum version
puts "\nGet current and minimum version"
puts JSON.pretty_generate(version_class.get_version(@client))
