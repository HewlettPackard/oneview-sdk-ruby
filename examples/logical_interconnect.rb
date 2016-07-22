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

require_relative '_client'
require 'json'

def pretty(arg)
  return puts arg if arg.instance_of?(String)
  puts JSON.pretty_generate(arg)
end

# Explores functionalities of Logical Interconnects

# Retrieves test enclosure to put the interconnects
# enclosure = OneviewSDK::Enclosure.new(@client, name: 'Encl1')
# enclosure.retrieve!
# pretty "Sucessfully retrieved the enclosure #{enclosure[:name]}"

log_int = OneviewSDK::LogicalInterconnect.new(@client, name: 'Encl2-EXAMPLE_LIG')
log_int.retrieve!
pretty "Logical interconnect #{log_int['name']} was retrieved sucessfully"

# pretty '#### Update of Internal networks ####'

# internal_networks = log_int.list_vlan_networks
# pretty 'Listing all the internal networks'
# internal_networks.each do |net|
#   pretty "Network #{net[:name]} with uri #{net[:uri]}"
# end
#
# li_et01_options = {
#   vlanId:  '2001',
#   purpose:  'General',
#   name:  'li_et01',
#   smartLink:  false,
#   privateNetwork:  false,
#   connectionTemplateUri: nil,
#   type:  'ethernet-networkV3'
# }
# et01 = OneviewSDK::EthernetNetwork.new(@client, li_et01_options)
# et01.create!
#
# li_et02_options = {
#   vlanId:  '2002',
#   purpose:  'General',
#   name:  'li_et02',
#   smartLink:  false,
#   privateNetwork:  false,
#   connectionTemplateUri: nil,
#   type:  'ethernet-networkV3'
# }
# et02 = OneviewSDK::EthernetNetwork.new(@client, li_et02_options)
# et02.create!
#
# pretty "\nUpdating internal networks"
# log_int.update_internal_networks(et01, et02)
#
# internal_networks2 = log_int.list_vlan_networks
# pretty 'Listing all the internal networks again'
# internal_networks2.each do |net|
#   pretty "Network #{net[:name]} with uri #{net[:uri]}"
# end
#
# pretty "\nReturning to initial state"
# ### Instance compliance ###
# pretty "\n#### Compliance ####"
# pretty "Putting #{log_int['name']} in compliance with the LIG"
# log_int.compliance
# pretty "Compliance update successful\n"
#
# internal_networks3 = log_int.list_vlan_networks
# pretty 'Listing all the internal networks one more time'
# internal_networks3.each do |net|
#   pretty "Network #{net[:name]} with uri #{net[:uri]}"
# end
#
# et01.delete
# et02.delete
#
# pretty "\n\n#### Updating Ethernet Settings ####"
# pretty 'Current:'
# pretty "igmpIdleTimeoutInterval: #{log_int['ethernetSettings']['igmpIdleTimeoutInterval']}"
# pretty "macRefreshInterval: #{log_int['ethernetSettings']['macRefreshInterval']}"
#
#
# # Backing up
# eth_set_backup = {}
# eth_set_backup['igmpIdleTimeoutInterval'] = log_int['ethernetSettings']['igmpIdleTimeoutInterval']
# eth_set_backup['macRefreshInterval'] = log_int['ethernetSettings']['macRefreshInterval']
#
# log_int['ethernetSettings']['igmpIdleTimeoutInterval'] = 222
# log_int['ethernetSettings']['macRefreshInterval'] = 15
#
# pretty "\nChanging:"
# pretty "igmpIdleTimeoutInterval to #{log_int['ethernetSettings']['igmpIdleTimeoutInterval']}"
# pretty "macRefreshInterval to #{log_int['ethernetSettings']['macRefreshInterval']}"
#
# pretty "\nUpdating internet settings"
# log_int.update_ethernet_settings
# log_int.retrieve! # Retrieving to guarantee the remote is updated
#
# pretty "\nNew Ethernet Settings:"
# pretty "igmpIdleTimeoutInterval: #{log_int['ethernetSettings']['igmpIdleTimeoutInterval']}"
# pretty "macRefreshInterval: #{log_int['ethernetSettings']['macRefreshInterval']}"
#
#
# pretty "\nRolling back..."
# eth_set_backup.each do |k, v|
#   log_int['ethernetSettings'][k] = v
# end
# log_int.update_ethernet_settings
# log_int.retrieve! # Retrieving to guarantee the remote is updated
# pretty "igmpIdleTimeoutInterval: #{log_int['ethernetSettings']['igmpIdleTimeoutInterval']}"
# pretty "macRefreshInterval: #{log_int['ethernetSettings']['macRefreshInterval']}"
#
# pretty '### Port Monitor ###'
# pretty log_int['portMonitor']
# log_int.update_port_monitor
#
# enabled_bkp = log_int['portMonitor']['enablePortMonitor']
# log_int['portMonitor']['enablePortMonitor'] = true
# log_int.update_port_monitor
# log_int.retrieve!
# pretty log_int['portMonitor']
#
# log_int['portMonitor']['enablePortMonitor'] = enabled_bkp
# log_int.update_port_monitor
# log_int.retrieve!
# pretty log_int['portMonitor']


# pretty '### QoS Configuration ###'
# pretty log_int['qosConfiguration']
# log_int.update_qos_configuration
#
# config_type_bkp = log_int['qosConfiguration']['activeQosConfig']['configType']
# description_bkp = log_int['qosConfiguration']['activeQosConfig']['description']
# log_int['qosConfiguration']['activeQosConfig']['description'] = 'Edited QoS Configuration'
# log_int.update_qos_configuration
# log_int.retrieve!
# pretty log_int['qosConfiguration']
#
# log_int['qosConfiguration']['activeQosConfig']['configType'] = config_type_bkp
# log_int['qosConfiguration']['activeQosConfig']['description'] = description_bkp
# log_int.update_qos_configuration
# log_int.retrieve!
# pretty log_int['qosConfiguration']

# pretty '### Telemetry Configuration ###'
# pretty log_int['telemetryConfiguration']
#
# sample_count_bkp = log_int['telemetryConfiguration']['sampleCount']
# sample_interval_bkp = log_int['telemetryConfiguration']['sampleInterval']
# log_int['telemetryConfiguration']['sampleCount'] = 20
# log_int['telemetryConfiguration']['sampleInterval'] = 200
# log_int.update_telemetry_configuration
# log_int.retrieve!
# pretty log_int['telemetryConfiguration']
#
# log_int['telemetryConfiguration']['sampleCount'] = sample_count_bkp
# log_int['telemetryConfiguration']['sampleInterval'] = sample_interval_bkp
# log_int.update_telemetry_configuration
# log_int.retrieve!
# pretty log_int['telemetryConfiguration']
#
# pretty '### SNMP Configuration ###'
# pretty log_int['snmpConfiguration']
#
# # Adding configuration
# log_int['snmpConfiguration']['snmpAccess'].push('172.18.6.15/24')
# enet_trap = %w(PortStatus)
# fc_trap = %w(PortStatus)
# vcm_trap = %w(Legacy)
# trap_sev = %w(Normal Warning Critical)
# trap_options = log_int.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev)
# log_int.add_snmp_trap_destination('172.18.6.16', 'SNMPv2', 'public', trap_options)
#
# # Updating snmpConfiguration
# log_int.update_snmp_configuration
# pretty "\nUpdate Complete!\n"
# pretty log_int['snmpConfiguration']
#
# # Removing all configuration
# log_int['snmpConfiguration']['snmpAccess'] = []
# log_int['snmpConfiguration']['trapDestinations'] = []
# log_int.update_snmp_configuration
# pretty "\nRemoving configuration..."
# pretty log_int['snmpConfiguration']

pretty '### Firmware Update ###'
firmware_opt = log_int.get_firmware
pretty firmware_opt

firmware_name = 'Service Pack for ProLiant'
firmware = OneviewSDK::FirmwareDriver.new(@client, name: firmware_name)
firmware.retrieve!

pretty '# Updating firmware options #'

pretty "\nStaging..."
firmware_opt['ethernetActivationDelay'] = 7
firmware_opt['ethernetActivationType'] = 'OddEven'
firmware_opt['fcActivationDelay'] = 7
firmware_opt['fcActivationType'] = 'Serial'
firmware_opt['force'] = true
log_int.firmware_update('Stage', firmware, firmware_opt)
pretty firmware_opt

pretty "\nActivating..."
firmware_opt['ethernetActivationDelay'] = 7
firmware_opt['ethernetActivationType'] = 'OddEven'
firmware_opt['fcActivationDelay'] = 7
firmware_opt['fcActivationType'] = 'Serial'
firmware_opt['force'] = true
log_int.firmware_update('Activate', firmware, firmware_opt)
pretty firmware_opt
#
# pretty "\nUpdating..."
# firmware_opt['ethernetActivationDelay'] = 15
# firmware_opt['ethernetActivationType'] = 'None'
# firmware_opt['fcActivationDelay'] = 15
# firmware_opt['fcActivationType'] = 'None'
# firmware_opt['force'] = true
# log_int.firmware_update('Update', firmware, firmware_opt)
# pretty firmware_opt
