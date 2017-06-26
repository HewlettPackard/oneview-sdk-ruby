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

# NOTE: You'll need to add the following instance variable to the _client.rb file with valid values for your environment:
#   @storage_system_ip

# All supported APIs for Web Server Certificate:
# - 200, 300, 500

# Resources classes that you can use for Web Server Certificate in this example:
# web_certificate_class = OneviewSDK::API200::WebServerCertificate
# web_certificate_class = OneviewSDK::API300::C7000::WebServerCertificate
# web_certificate_class = OneviewSDK::API300::Synergy::WebServerCertificate
# web_certificate_class = OneviewSDK::API500::C7000::WebServerCertificate
# web_certificate_class = OneviewSDK::API500::Synergy::WebServerCertificate
web_certificate_class = OneviewSDK.resource_named('WebServerCertificate', @client.api_version)

item = web_certificate_class.new(@client)

puts "\nRetrieving the certificate:"
puts item.data if item.retrieve!

puts "\nCreating a new self-signed appliance certificate"
item.create_self_signed
puts 'Created successfully.'

puts "\nCreating a new certificate signing request:"
attributes = {
  base64Data: item['base64Data'],
  commonName: 'thetemplate.example.com',
  country: 'BR',
  locality: 'Fortaleza',
  organization: 'HPE',
  state: 'Ceara',
  type: 'CertificateDtoV2'
}
item2 = web_certificate_class.new(@client, attributes)
item2.create
puts item2.data

puts "\nGetting the web server certificate of the specified remote appliance:"
item3 = web_certificate_class.get_certificate(@client, @storage_system_ip)
puts item3.data
