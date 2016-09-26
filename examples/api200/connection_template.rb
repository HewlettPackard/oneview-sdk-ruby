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

require_relative '../_client' # Gives access to @client

# Example: Manage connection templates
default = OneviewSDK::ConnectionTemplate.get_default(@client)
if default['uri']
  puts "\nRetrieved default connection template with name='#{default['name']}'"
  puts "(- maximumBandwidth: #{default['bandwidth']['maximumBandwidth']})"
  puts "(- typicalBandwidth: #{default['bandwidth']['typicalBandwidth']})\n"
end

# Retrieve connection template and update its name
connection_template = OneviewSDK::ConnectionTemplate.find_by(@client, {}).first
puts "\nConnection template with name='#{connection_template['name']}' bandwidth specification is:"
puts "(- maximumBandwidth: #{connection_template['bandwidth']['maximumBandwidth']})"
puts "(- typicalBandwidth: #{connection_template['bandwidth']['typicalBandwidth']})\n"

old_name = connection_template['name']
connection_template['name'] = 'ConnectionTemplate_1'
connection_template.update
puts "\nConnection template name changed from #{old_name} to #{connection_template['name']}\n"

# Update typical and maximum bandwidth for the previous connection template
connection_template['bandwidth']['maximumBandwidth'] += 1000
connection_template['bandwidth']['typicalBandwidth'] += 1000
connection_template.update
puts "\nConnection template with name='#{connection_template['name']}' bandwidth specification changed:"
puts "(- maximumBandwidth: #{connection_template['bandwidth']['maximumBandwidth']})"
puts "(- typicalBandwidth: #{connection_template['bandwidth']['typicalBandwidth']})\n"

# Restore connection template old name
connection_template['name'] = old_name
connection_template.update
puts "\nConnection template name changed back to #{connection_template['name']}"
