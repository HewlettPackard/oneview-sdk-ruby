# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

# NOTE: You'll need to add the following instance variable to the _client.rb file with valid values for your environment:
#   @storage_system_ip

# All supported APIs for  Server Certificate:
# - 600, 800, 1000, 1200
# # Resources classes that you can use for Client Certificate in this example:
# server_certificate_class = OneviewSDK::API600::C7000::ClientCertificate
# server_certificate_class = OneviewSDK::API600::Synergy::ClientCertificate
# server_certificate_class = OneviewSDK::API800::C7000::ClientCertificate
# server_certificate_class = OneviewSDK::API800::Synergy::ClientCertificate
# server_certificate_class = OneviewSDK::API1000::C7000::ClientCertificate
# server_certificate_class = OneviewSDK::API1000::Synergy::ClientCertificate
# server_certificate_class = OneviewSDK::API1200::C7000::ClientCertificate
# server_certificate_class = OneviewSDK::API1200::Synergy::ClientCertificate

# Resources classes that you can use for Web Server Certificate in this example:
# web_certificate_class = OneviewSDK::API200::WebServerCertificate
# web_certificate_class = OneviewSDK::API300::C7000::WebServerCertificate
# web_certificate_class = OneviewSDK::API300::Synergy::WebServerCertificate
# web_certificate_class = OneviewSDK::API500::C7000::WebServerCertificate
# web_certificate_class = OneviewSDK::API500::Synergy::WebServerCertificate

web_certificate_api = 500

# Initialize the resources
server_certificate_class = OneviewSDK.resource_named('ServerCertificate', @client.api_version)
web_certificate_class = OneviewSDK.resource_named('WebServerCertificate', web_certificate_api)

# Imports certificates
puts 'Importing the certificate:- '
item = server_certificate_class.new(@client, aliasName: @storage_system_ip)
web_certificate = web_certificate_class.get_certificate(@client, @storage_system_ip)
item.data['type'] = 'CertificateInfoV2'
item.data['certificateDetails'] = []
item.data['certificateDetails'][0] = { 'type' => 'CertificateDetailV2', 'base64Data' => web_certificate.data['certificateDetails'][0]['base64Data'] }
item.import
puts 'Imported successfully.'
# Updates the certificate
puts 'Updating certificate:-'
item.refresh
item.update
puts 'Updated Successfully.'

# Retrieve the certificates as per the aliasName
puts 'Retrieving Imported Certificate:-'
item = server_certificate_class.new(@client, aliasName: @storage_system_ip)
puts item.data if item.retrieve!

# Deleres the certificate as per the aliasName
puts 'Removing certificate:-'
puts 'Successfully Removed.' if item.remove
