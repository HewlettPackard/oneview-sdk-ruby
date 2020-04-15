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
# # Resources classes that you can use for Server Certificate in this example:
# server_certificate_class = OneviewSDK::API600::C7000::ServerCertificate
# server_certificate_class = OneviewSDK::API600::Synergy::ServerCertificate
# server_certificate_class = OneviewSDK::API800::C7000::ServerCertificate
# server_certificate_class = OneviewSDK::API800::Synergy::ServerCertificate
# server_certificate_class = OneviewSDK::API1000::C7000::ServerCertificate
# server_certificate_class = OneviewSDK::API1000::Synergy::ServerCertificate
# server_certificate_class = OneviewSDK::API1200::C7000::ServerCertificate
# server_certificate_class = OneviewSDK::API1200::Synergy::ServerCertificate

# Initialize the resources
server_certificate_class = OneviewSDK.resource_named('ServerCertificate', @client.api_version)

# Gets certificates from remote IP
puts 'Fetching Certificate:-'
certificate = server_certificate_class.new(@client)
certificate.data['remoteIp'] = '172.18.13.11'
puts certificate.get_certificate

# Imports the certificates
puts 'Importing the certificate:- '
item = server_certificate_class.new(@client, aliasName: @storage_system_ip)
item.data['type'] = certificate.get_certificate['type']
item.data['certificateDetails'] = []
item.data['certificateDetails'][0] = {
  'type' => certificate.get_certificate['certificateDetails'][0]['type'],
  'base64Data' => certificate.get_certificate['certificateDetails'][0]['base64Data']
}
puts 'Imported successfully.' if item.import

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
