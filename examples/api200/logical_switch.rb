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

require_relative '../_client'

# SSH Credential
ssh_credentials = OneviewSDK::LogicalSwitch::CredentialsSSH.new('dcs', 'dcs')

# SNMP credentials
snmp_v1 = OneviewSDK::LogicalSwitch::CredentialsSNMPV1.new(161, 'public')
snmp_v1_2 = OneviewSDK::LogicalSwitch::CredentialsSNMPV1.new(161, 'public')


logical_switch = OneviewSDK::LogicalSwitch.new(
  @client,
  name: 'Teste_SDK',
  logicalSwitchGroupUri: '/rest/logical-switch-groups/2c5de7f0-7cb6-4897-9423-181e625a614c'
)

# Adding switches credentials
logical_switch.set_switch_credentials('172.16.11.11', ssh_credentials, snmp_v1)
logical_switch.set_switch_credentials('172.16.11.12', ssh_credentials, snmp_v1_2)

# Creates logical switch for a switch group
logical_switch.create
puts "Logical switch created with uri=#{logical_switch['uri']}"
