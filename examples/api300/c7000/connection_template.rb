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

# Example: Manage connection templates
default = OneviewSDK::API300::C7000::ConnectionTemplate.get_default(@client)
if default['uri']
  puts "\nRetrieved default connection template with name='#{default['name']}' aaaa #{default['uri']}"
  puts "(- maximumBandwidth: #{default['bandwidth']['maximumBandwidth']})"
  puts "(- typicalBandwidth: #{default['bandwidth']['typicalBandwidth']})\n"
end

# List all connections
puts "\nList all connections templates:"
OneviewSDK::API300::C7000::ConnectionTemplate.find_by(@client, {}).each do |c|
  puts "  Name: #{c[:name]} with uri: #{c[:uri]}"
end

# Retrieve connection template
connection_template = OneviewSDK::ConnectionTemplate.find_by(@client, {}).first
puts "\nConnection template with name='#{connection_template['name']}' bandwidth specification is:"
puts "(- maximumBandwidth: #{connection_template['bandwidth']['maximumBandwidth']})"
puts "(- typicalBandwidth: #{connection_template['bandwidth']['typicalBandwidth']})\n"

# Update typical and maximum bandwidth for the previous connection template
puts "\nUpdating a connection template with name='#{connection_template['name']}"
puts "\n adding value 100 for maximumBandwidth and typicalBandwidth:"
connection_template['bandwidth']['maximumBandwidth'] -= 100
connection_template['bandwidth']['typicalBandwidth'] -= 100
connection_template.update
connection_template.retrieve!
puts "\nConnection template with name='#{connection_template['name']}' bandwidth specification changed:"
puts "(- maximumBandwidth: #{connection_template['bandwidth']['maximumBandwidth']})"
puts "(- typicalBandwidth: #{connection_template['bandwidth']['typicalBandwidth']})\n"
connection_template['bandwidth']['maximumBandwidth'] += 100
connection_template['bandwidth']['typicalBandwidth'] += 100
connection_template.update
