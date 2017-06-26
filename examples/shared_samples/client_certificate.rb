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

# Resources classes that you can use for Client Certificate in this example:
# client_certificate_class = OneviewSDK::API200::ClientCertificate
# client_certificate_class = OneviewSDK::API300::C7000::ClientCertificate
# client_certificate_class = OneviewSDK::API300::Synergy::ClientCertificate
# client_certificate_class = OneviewSDK::API500::C7000::ClientCertificate
# client_certificate_class = OneviewSDK::API500::Synergy::ClientCertificate
client_certificate_class = OneviewSDK.resource_named('ClientCertificate', @client.api_version)

# Resources classes that you can use for Web Server Certificate in this example:
# web_certificate_class = OneviewSDK::API200::WebServerCertificate
# web_certificate_class = OneviewSDK::API300::C7000::WebServerCertificate
# web_certificate_class = OneviewSDK::API300::Synergy::WebServerCertificate
# web_certificate_class = OneviewSDK::API500::C7000::WebServerCertificate
# web_certificate_class = OneviewSDK::API500::Synergy::WebServerCertificate
web_certificate_class = OneviewSDK.resource_named('WebServerCertificate', @client.api_version)

item = client_certificate_class.new(@client, aliasName: @storage_system_ip)
puts "\nImporting the certificate:"
web_certificate = web_certificate_class.get_certificate(@client, @storage_system_ip)
item['base64SSLCertData'] = web_certificate['base64Data']
item['aliasName'] = @storage_system_ip
item.import
puts 'Imported successfully.'

puts "\nRetrieving the resource:"
item = client_certificate_class.new(@client, aliasName: @storage_system_ip)
puts item.data if item.retrieve!

puts "\nValidating the certificate"
item.validate
puts "Status: #{item['status']}"

puts "\nUpdating the certificate"
item = client_certificate_class.new(@client, aliasName: @storage_system_ip)
item.refresh
item.update
puts 'Updated successfully.'

puts "\nRemoving the certificate"
item.remove
puts 'Removed successfully.' unless item.retrieve!
