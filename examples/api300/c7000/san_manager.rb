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

# NOTE: This will add a Brocade Network Advisor, then delete it.
# NOTE: You'll need to add the following instance variables to the _client.rb file with valid URIs for your environment:
# @san_manager_ip
# @san_manager_username
# @san_manager_password
# NOTE: You'll need to have a BNA.

# Print default connection info for Brocade Network Advisor
default_info = OneviewSDK::API300::C7000::SANManager.get_default_connection_info(@client, 'Brocade Network Advisor')
puts 'Brocade Network Advisor connection info:'
default_info.each { |property| puts "* #{property['name']} - #{property['value']}" }

# Add a Brocade Network Advisor
san_manager = OneviewSDK::API300::C7000::SANManager.new(@client)
san_manager['providerDisplayName'] = 'Brocade Network Advisor'
san_manager['connectionInfo'] = [
  {
    'name' => 'Host',
    'value' => @san_manager_ip
  },
  {
    'name' => 'Port',
    'value' => 5989
  },
  {
    'name' => 'Username',
    'value' => @san_manager_username
  },
  {
    'name' => 'Password',
    'value' => @san_manager_password
  },
  {
    'name' => 'UseSsl',
    'value' => true
  }
]

san_manager.add
puts "- SAN Manager #{san_manager['name']} sucessfully added with uri='#{san_manager['uri']}'"

# Removes Brocade Network Advisor
san_manager.remove
puts "- SAN Manager #{san_manager['name']} was sucessfully removed"
