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
# Example: List the login details
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::LoginDetail
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::LoginDetail
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::LoginDetail
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::LoginDetail
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::LoginDetail

# Resource Class used in this sample
login_detail_class = OneviewSDK.resource_named('LoginDetail', @client.api_version)

# Listing login details
puts "\nListing Login Details:"
puts JSON.pretty_generate(login_detail_class.get_login_details(@client))
