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

require_relative '../../_client'

# # List of C7000 Internal Link Sets
# OneviewSDK::LogicalSwitch.get_internal_link_sets(@client).each do |internal_link_set|
#   puts "Internal Link Set #{internal_link_set['name']} URI=#{internal_link_set['uri']}"
# end
#
# # Retrieves a specific Internal Link Set
# internal_link_set = OneviewSDK::LogicalSwitch.get_internal_link_set(@client, 'ils1')
# puts "Internal Link Set #{internal_link_set['name']} URI=#{internal_link_set['uri']}"

$client_300 = @client

klass = OneviewSDK::API300::C7000::LogicalSwitch
@item = klass.new($client_300, name: 'LOG_SWI_NAME')
ssh_credentials = klass::CredentialsSSH.new('dcs', 'dcs')
snmp_v1 = klass::CredentialsSNMPV1.new(161, 'admin')
logical_switch_group = OneviewSDK::API300::C7000::LogicalSwitchGroup.find_by($client_300, {}).first
@item.set_logical_switch_group(logical_switch_group)
@item.set_switch_credentials('172.18.20.1', ssh_credentials, snmp_v1)
@item.set_switch_credentials('172.18.20.2', ssh_credentials, snmp_v1)
@item.create
expect(@item['uri']).to be
