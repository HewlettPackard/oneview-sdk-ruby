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
default_info = OneviewSDK::API300::Thunderbird::SANManager.get_default_connection_info(@client, 'Cisco')
puts 'Cisco Switch connection info:'
default_info.each { |property| puts "* #{property['name']} - #{property['value']}" }

# Add a Brocade Network Advisor
san_manager = OneviewSDK::API300::Thunderbird::SANManager.new(@client)
san_manager['providerDisplayName'] = 'Cisco'
san_manager['connectionInfo'] = [
  {
    'name' => 'Host',
    'value' => @san_manager_ip
  },
  {
    'name' => 'SnmpPort',
    'value' => 161
  },
  {
    'name' => 'SnmpUserName',
    'value' => @san_manager_username
  },
  {
    'name' => 'SnmpAuthLevel',
    'value' => 'AUTHNOPRIV'
  },
  {
    'name' => 'SnmpAuthProtocol',
    'value' => 'SHA'
  },
  {
    'name' => 'SnmpAuthString',
    'value' => @san_manager_password
  }
]

san_manager.add
puts "- SAN Manager #{san_manager['name']} sucessfully added with uri='#{san_manager['uri']}'"

# Removes Brocade Network Advisor
san_manager.remove
puts "- SAN Manager #{san_manager['name']} was sucessfully removed"
