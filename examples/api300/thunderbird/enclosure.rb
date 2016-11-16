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

# Example: Add an enclosure
# NOTE: This will add an enclosure named 'OneViewSDK-Test-Enclosure', then delete it.
# NOTE: This resource only supports remove operations after it has been physically removed.
# NOTE: You will need to add the following instance variables to the _client.rb file with valid URIs for your environment:
#   @enclosure_hostname (hostname or IP address)

type = 'enclosure'

item = OneviewSDK::API300::Thunderbird::Enclosure.new(@client, name: 'OneViewSDK-Test-Enclosure', hostname: @thunderbird_enclosure_hostname)
enclosures_added = item.add
enclosures_added.each do |encl|
  puts "\nAdded #{type} '#{encl[:name]}' sucessfully.\n  uri = '#{encl[:uri]}'"
end

encl1 = enclosures_added[0]

item2 = OneviewSDK::API300::Thunderbird::Enclosure.new(@client, name: 'OneViewSDK-Test-Enclosure1')
item2.retrieve!
puts "\nFound #{type} by name: '#{item2[:name]}'.\n  uri = '#{item2[:uri]}'"

encl1.refresh
encl1.update(name: 'OneViewSDK_Test_Enclosure')
puts "\nUpdated #{type} '#{encl1[:name]}' sucessfully.\n  uri = '#{encl1[:uri]}'"

# Patch update
encl1.patch('replace', '/name', 'Edited_Enclosure')
