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

require_relative '_client' # Gives access to @client

# Print default connection info for Brocade Network Advisor
default_info = OneviewSDK::SANManager.get_default_connection_info(@client, 'Brocade Network Advisor')
puts 'Brocade Network Advisor connection info:'
default_info.each { |property| puts "* #{property['name']} - #{property['value']}" }

# Add a Brocade Network Advisor
san_manager = OneviewSDK::SANManager.new(@client)
san_manager['providerDisplayName'] = 'Brocade Network Advisor'
san_manager['connectionInfo'] = [
  {
    'name' => 'Host',
    'value' => '172.18.15.1'
  },
  {
    'name' => 'Port',
    'value' => 5989
  },
  {
    'name' => 'Userame',
    'value' => 'dcs'
  },
  {
    'name' => 'Password',
    'value' => 'dcs'
  },
  {
    'name' => 'UseSl',
    'value' => true
  }
]

san_manager.add
puts "- SAN Manager #{san_manager['name']} sucessfully added with uri='#{san_manager['uri']}'"

# Removes Brocade Network Advisor
san_manager.remove
puts "- SAN Manager #{san_manager['name']} was sucessfully removed"
