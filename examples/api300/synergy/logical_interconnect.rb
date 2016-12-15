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

# Example: Explores functionalities of Logical Interconnects for API300 Synergy

# Finding a logical interconnect
items = OneviewSDK::API300::Synergy::LogicalInterconnect.find_by(@client, {})
puts "\nListing all interconnects."
items.each do |li|
  puts "\nLogical interconnect #{li['name']} was found."
end

item = OneviewSDK::API300::Synergy::LogicalInterconnect.find_by(@client, {}).first
# # Listing internal networks
puts "\nListing internal networks of the logical  interconnect with name: #{item['name']}"
networks = item.list_vlan_networks

networks.each do |nw|
  puts "\nNetwork with name #{nw['name']}, vlan #{nw['vlanId']} and uri #{nw['uri']} was found."
end

# Updating Ethernet Settings
puts "\nUpdating Ethernet Settings"
puts 'Current:'
puts "igmpIdleTimeoutInterval: #{item['ethernetSettings']['igmpIdleTimeoutInterval']}"
puts "macRefreshInterval: #{item['ethernetSettings']['macRefreshInterval']}"

# Backing up
eth_set_backup = {}
eth_set_backup['igmpIdleTimeoutInterval'] = item['ethernetSettings']['igmpIdleTimeoutInterval']
eth_set_backup['macRefreshInterval'] = item['ethernetSettings']['macRefreshInterval']

item['ethernetSettings']['igmpIdleTimeoutInterval'] = 222
item['ethernetSettings']['macRefreshInterval'] = 15

puts "\nChanging:"
puts "igmpIdleTimeoutInterval to #{item['ethernetSettings']['igmpIdleTimeoutInterval']}"
puts "macRefreshInterval to #{item['ethernetSettings']['macRefreshInterval']}"

puts "\nUpdating internet settings"
item.update_ethernet_settings
item.retrieve! # Retrieving to guarantee the remote is updated

puts "\nNew Ethernet Settings:"
puts "igmpIdleTimeoutInterval: #{item['ethernetSettings']['igmpIdleTimeoutInterval']}"
puts "macRefreshInterval: #{item['ethernetSettings']['macRefreshInterval']}"

# Rolling back
puts "\nRolling back..."
eth_set_backup.each do |k, v|
  item['ethernetSettings'][k] = v
end
item.update_ethernet_settings
item.retrieve! # Retrieving to guarantee the remote is updated
puts "igmpIdleTimeoutInterval: #{item['ethernetSettings']['igmpIdleTimeoutInterval']}"
puts "macRefreshInterval: #{item['ethernetSettings']['macRefreshInterval']}"

# Gets a collection of uplink ports eligibles for assignment to an analyzer port
puts "\nGets a collection of uplink ports eligibles for assignment to an analyzer port "
item.retrieve!
ports = item.get_unassigned_up_link_ports_for_port_monitor
puts 'Ports eligibles'
ports.each do |port|
  puts "\nInterconnect #{port['interconnectName']}, port name #{port['portName']} and uri #{port['uri']}."
end

# Update Port Monitor
puts "\nPort monitor current:"
puts "\n#{item['portMonitor']}"
puts "\nUpdate Port Monitor"
# Get port and downlink for port monitor
interconnect = OneviewSDK::API300::Synergy::Interconnect.find_by(@client, uri: item['interconnects'].first).first
downlinks = interconnect['ports'].select { |k| k['portType'] == 'Downlink' }
port = ports.select { |k| k['interconnectName'] == downlinks.first['interconnectName'] }
options = {
  'analyzerPort' => {
    'portUri' => port.first['uri'],
    'portMonitorConfigInfo' => 'AnalyzerPort'
  },
  'enablePortMonitor' => true,
  'type' => 'port-monitor',
  'monitoredPorts' => [
    {
      'portUri' => downlinks.first['uri'],
      'portMonitorConfigInfo' => 'MonitoredToServer'
    }
  ]
}

port_monitor_bkp = item['portMonitor']
item['portMonitor'] = options
item.update_port_monitor
item.retrieve!

puts "\nPort monitor after update:"
puts "\n#{item['portMonitor']}"

puts "\nReturning to initial state"
item['portMonitor'] = port_monitor_bkp
item.update_port_monitor
puts "\nPort monitor original:"
puts "\n#{item['portMonitor']}"

puts "\nQoS configuration current:"
puts "\n #{item['qosConfiguration']}"

description_bkp = item['qosConfiguration']['activeQosConfig']['description']
item['qosConfiguration']['activeQosConfig']['description'] = 'Description'
puts "\nUpdate QoS Configuration"
item.update_qos_configuration
item.retrieve!
puts "\nQoS configuration after update:"
puts "\n #{item['qosConfiguration']}"

puts "\nReturning to initial state"
item['qosConfiguration']['activeQosConfig']['description'] = description_bkp
item.update_qos_configuration
item.retrieve!
puts "\nQoS configuration original:"
puts "\n #{item['qosConfiguration']}"

puts "\nTelemetry Configuration"
puts "\nTelemetry configuration current:"
puts "\n#{item['telemetryConfiguration']}"

sample_count_bkp = item['telemetryConfiguration']['sampleCount']
sample_interval_bkp = item['telemetryConfiguration']['sampleInterval']
item['telemetryConfiguration']['sampleCount'] = 24
item['telemetryConfiguration']['sampleInterval'] = 3600
puts "\nUpdating the telemetry configuration"
item.update_telemetry_configuration
item.retrieve!
puts "\nTelemetry configuration after update:"
puts "\n#{item['telemetryConfiguration']}"

puts "\nReturning to initial state"
item['telemetryConfiguration']['sampleCount'] = sample_count_bkp
item['telemetryConfiguration']['sampleInterval'] = sample_interval_bkp
item.update_telemetry_configuration
item.retrieve!
puts "\nTelemetry configuration original:"
puts "\n#{item['telemetryConfiguration']}"

puts "\nSNMP Configuration"
puts "\nSNMP configuration current:"
puts "\n#{item['snmpConfiguration']}"

# Adding configuration
item['snmpConfiguration']['snmpAccess'].push('172.18.6.15/24')
enet_trap = %w(PortStatus)
fc_trap = %w(PortStatus)
vcm_trap = %w(Legacy)
trap_sev = %w(Normal Warning Critical)
trap_options = item.generate_trap_options(enet_trap, fc_trap, vcm_trap, trap_sev)
item.add_snmp_trap_destination('172.18.6.16', 'SNMPv2', 'public', trap_options)

# Updating snmpConfiguration
item.update_snmp_configuration
puts "\nUpdate Complete!\n"
puts "\nSNMP configuration after update:"
puts "\n#{item['snmpConfiguration']}"

# Removing all configuration
puts "\nRemoving configuration..."
item['snmpConfiguration']['snmpAccess'] = []
item['snmpConfiguration']['trapDestinations'] = []
item.update_snmp_configuration
puts "\nSNMP configuration original:"
puts "\n#{item['snmpConfiguration']}"

# Gets the installed firmware for a logical interconnect
item.retrieve!
puts "\nApplies or re-applies the logical interconnect configuration to all managed interconnects"
item.configuration
puts "\nConfiguration Applied with successfully"
puts "\nGets the installed firmware for a logical interconnect"
firmware_opt = item.get_firmware
puts "\nThe firmware installed on logical interconnect #{item['name']}:"
puts firmware_opt.inspect
