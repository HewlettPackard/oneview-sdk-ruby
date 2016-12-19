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

# Example: Create an fc network
# NOTE: This will create an fc network named 'OneViewSDK Test FC Network', then delete it.
options = {
  name: 'OneViewSDK Test FC Network',
  connectionTemplateUri: nil,
  autoLoginRedistribution: true,
  fabricType: 'FabricAttach'
}

fc = OneviewSDK::FCNetwork.new(@client, options)
fc.create
puts "\nCreated fc-network '#{fc[:name]}' sucessfully.\n  uri = '#{fc[:uri]}'"

# Find recently created network by name
matches = OneviewSDK::FCNetwork.find_by(@client, name: fc[:name])
fc2 = matches.first
puts "\nFound fc-network by name: '#{fc2[:name]}'.\n  uri = '#{fc2[:uri]}'"

# Retrieve recently created network
fc3 = OneviewSDK::FCNetwork.new(@client, name: fc[:name])
fc3.retrieve!
puts "\nRetrieved fc-network data by name: '#{fc3[:name]}'.\n  uri = '#{fc3[:uri]}'"

# Update autoLoginRedistribution from recently created network
attribute = { autoLoginRedistribution: false }
fc2.update(attribute)
puts "\nUpdated fc-network: '#{fc[:name]}'.\n  uri = '#{fc2[:uri]}'"
puts "with attribute: #{attribute}"

# Example: List all fc networks with certain attributes
attributes = { fabricType: 'FabricAttach' }
puts "\nFC networks with #{attributes}"
OneviewSDK::FCNetwork.find_by(@client, attributes).each do |network|
  puts "  #{network[:name]}"
end

# Delete this network
fc3.delete
puts "\nSucessfully deleted fc-network '#{fc3[:name]}'."
