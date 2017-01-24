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

# SSH Credential
ssh_credentials = OneviewSDK::API300::C7000::LogicalSwitch::CredentialsSSH.new(@logical_switch_ssh_user, @logical_switch_ssh_password)

# SNMP credentials
snmp_v1 = OneviewSDK::API300::C7000::LogicalSwitch::CredentialsSNMPV1.new(161, @logical_switch_community_string)
snmp_v1_2 = OneviewSDK::API300::C7000::LogicalSwitch::CredentialsSNMPV1.new(161, @logical_switch_community_string)

logical_switch_group = OneviewSDK::API300::C7000::LogicalSwitchGroup.get_all(@client).first

logical_switch = OneviewSDK::API300::C7000::LogicalSwitch.new(
  @client,
  name: 'Test_SDK',
  logicalSwitchGroupUri: logical_switch_group['uri']
)

# Adding switches credentials
logical_switch.set_switch_credentials(@logical_switch1_ip, ssh_credentials, snmp_v1)
logical_switch.set_switch_credentials(@logical_switch2_ip, ssh_credentials, snmp_v1_2)

# Creates logical switch for a switch group
logical_switch.create
puts "Logical switch created with uri=#{logical_switch['uri']}"

# ======================= Internal Link Sets =================================

# List of C7000 Internal Link Sets
OneviewSDK::API300::C7000::LogicalSwitch.get_internal_link_sets(@client).each do |internal_link_set|
  puts "Internal Link Set #{internal_link_set['name']} URI=#{internal_link_set['uri']}"
end

# Retrieves a specific Internal Link Set
internal_link_set = OneviewSDK::API300::C7000::LogicalSwitch.get_internal_link_set(@client, 'ils1')
puts "Internal Link Set #{internal_link_set['name']} URI=#{internal_link_set['uri']}"

# Refresh state of logical switch
puts 'Refreshing state of logical switch'
logical_switch.refresh_state!
puts 'Refreshed successfully!'
