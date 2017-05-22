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

# Example: Add/Update/Remove SAN Manager
# NOTE: This will add a SAN Manager and then remove it.
#
# Supported APIs:
# - 200, 300, 500

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::SANManager
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::SANManager
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::SANManager
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::SANManager
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::SANManager

# Resource Class used in this sample
san_manager_class = OneviewSDK.resource_named('SANManager', @client.api_version)

variant = OneviewSDK.const_get("API#{@client.api_version}").variant unless @client.api_version < 300

# Setting the connection info values according to the variant
connection_info = if variant == 'Synergy'
                    [
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
                  else
                    # Connection info values for C7000
                    [
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
                  end

# Setting the provider value according to the variant
puts "\nThis example is using a provider 'Cisco' for Synergy and 'Brocade Network Advisor' for C7000."
provider = variant == 'Synergy' ? 'Cisco' : 'Brocade Network Advisor'

# Add a SAN Manager
puts "\nAdding a SAN Manager"
item = san_manager_class.new(@client)
item['providerDisplayName'] = provider
item['connectionInfo'] = connection_info

item.add
puts "\nSAN Manager #{item['name']} added sucessfully. URI: '#{item['uri']}'."

# Updates SAN Manager
item.retrieve!
puts "\nUpdating a SAN Manager #{item['name']}"
item.update(refreshState: 'RefreshPending')
puts "\nSAN Manager #{item['name']} updated successfully."

# Print default connection info for SAN Manager
default_info = san_manager_class.get_default_connection_info(@client, provider)
puts "\nSAN Manager connection info:"
default_info.each { |property| puts "* #{property['name']} - #{property['value']}" }

# Removes SAN Manager
puts "\nRemoving the SAN Manager"
item.remove
puts "\nSAN Manager #{item['name']} removed sucessfully."
