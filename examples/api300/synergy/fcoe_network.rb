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

# Example: Create an fc network
# NOTE: This will create an fc network named 'OneViewSDK Test FC Network', then delete it.
options = {
  name: 'OneViewSDK Test FCoE Network',
  connectionTemplateUri: nil,
  type: 'fcoe-networkV300',
  vlanId: 300
}

# Sucess case - 1
fcoe = OneviewSDK::API300::Synergy::FCoENetwork.new(@client, options)
fcoe.create!
puts "\nCreated fcoe-network '#{fcoe[:name]}' sucessfully.\n  uri = '#{fcoe[:uri]}'"

# Find recently created network by name
matches = OneviewSDK::API300::Synergy::FCoENetwork.find_by(@client, name: fcoe[:name])
fcoe2 = matches.first
puts "\nFound fcoe-network by name: '#{fcoe2[:name]}'.\n  uri = '#{fcoe2[:uri]}'"

# Retrieve recently created network
fcoe3 = OneviewSDK::API300::Synergy::FCoENetwork.new(@client, name: fcoe[:name])
fcoe3.retrieve!
puts "\nRetrieved ethernet-network data by name: '#{fcoe3[:name]}'.\n  uri = '#{fcoe3[:uri]}'"

# Example: List all fcoe networks with certain attributes
attributes = { status: 'OK' }
puts "\n\nFCoE networks with #{attributes}"
OneviewSDK::API300::Synergy::FCoENetwork.find_by(@client, attributes).each do |network|
  puts "  #{network[:name]}"
end

# Delete this network
fcoe3.delete
puts "\nSucessfully deleted fc-network '#{fcoe3[:name]}'."
