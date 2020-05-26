# (C) Copyright 2020 Hewlett Packard Enterprise Development LP
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

# Example: Explores functionalities of Logical Interconnects
#
# Supported APIs:
# - 200, 300, 500, 600, 800, 1000, 1200
# Supported Variants:
# - C7000, Synergy

# Resources that can be created according to parameters:
# for example, if api_version = 800 & variant = C7000 to OneviewSDK::API800::C7000::LogicalInterconnect

# Resource Class used in this sample
logical_interconnect_class = OneviewSDK.resource_named('LogicalInterconnect', @client.api_version)

# EthernetNetwork class used in this sample
ethernet_class = OneviewSDK.resource_named('EthernetNetwork', @client.api_version)
# Interconnect class used in this sample
interconnect_class = OneviewSDK.resource_named('Interconnect', @client.api_version)

# Finding a logical interconnect
items = logical_interconnect_class.find_by(@client, {})
puts "\nListing all interconnects."
items.each do |li|
  puts "\nLogical interconnect #{li['name']} was found."
end

item = logical_interconnect_class.find_by(@client, {}).first
# # Listing internal networks
puts "\nListing internal networks of the logical  interconnect with name: #{item['name']}"
networks = item.list_vlan_networks

networks.each do |nw|
  puts "\nNetwork with name #{nw['name']}, vlan #{nw['vlanId']} and uri #{nw['uri']} was found."
end

# Update of Internal networks
puts 'Update of Internal networks'

li_et01_options = {
  vlanId:  '2001',
  purpose:  'General',
  name:  'li_et01',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri: nil
}
et01 = ethernet_class.new(@client, li_et01_options)
et01.create!

li_et02_options = {
  vlanId:  '2002',
  purpose:  'General',
  name:  'li_et02',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri: nil
}
et02 = ethernet_class.new(@client, li_et02_options)
et02.create!

puts "\nUpdating internal networks"
item.update_internal_networks(et01, et02)

# Listing internal networks after update
puts "\nListing internal networks of the logical  interconnect with name: #{item['name']} after update"
networks2 = item.list_vlan_networks

networks2.each do |nw|
  puts "\nNetwork with name #{nw['name']}, vlan #{nw['vlanId']} and uri #{nw['uri']} was found."
end

puts "\nReturning to initial state"
# Instance compliance
puts "\nCompliance"
puts "Putting #{item['name']} in compliance with the LIG"
item.compliance
puts "Compliance applied successfully\n"

# Listing internal networks after compliance
puts "\nListing internal networks of the logical  interconnect with name: #{item['name']} after compliance"
networks3 = item.list_vlan_networks

networks3.each do |nw|
  puts "\nNetwork with name #{nw['name']}, vlan #{nw['vlanId']} and uri #{nw['uri']} was found."
end

et01.delete
et02.delete

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
ports = item.get_unassigned_uplink_ports_for_port_monitor
puts 'Ports eligibles'
ports.each do |port|
  puts "\nInterconnect #{port['interconnectName']}, port name #{port['portName']} and uri #{port['uri']}."
end

# Update Port Monitor
puts "\nPort monitor current:"
puts "\n#{item['portMonitor']}"
puts "\nUpdate Port Monitor"
# Get port and downlink for port monitor
port = ports.first
interconnect = interconnect_class.find_by(@client, name: port['interconnectName']).first
downlinks = interconnect['ports'].select { |k| k['portType'] == 'Downlink' }
options = {
  'analyzerPort' => {
    'portUri' => port['uri'],
    'portMonitorConfigInfo' => 'AnalyzerPort'
  },
  'enablePortMonitor' => true,
  'type' => 'port-monitorV1', # Type value is port-monitor for OneView API version < 1200
  'monitoredPorts' => [
    {
      'portUri' => downlinks.first['uri'],
      'portMonitorConfigInfo' => 'MonitoredBoth'
    }
  ]
}

item['portMonitor'] = options
item.update_port_monitor
item.retrieve!

puts "\nPort monitor after update:"
puts "\n#{item['portMonitor']}"

puts "\nReturning to initial state"
item.compliance
puts "\nPort monitor after compliance:"
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

puts "\nGets the installed firmware for a logical interconnect"
firmware_opt = item.get_firmware
puts "\nThe firmware installed on logical interconnect #{item['name']}:"
puts firmware_opt.inspect

puts "\nTelemetry Configuration"
puts "\nTelemetry configuration current:"
puts "\n#{item['telemetryConfiguration']}"

sample_count_bkp = item['telemetryConfiguration']['sampleCount']
sample_interval_bkp = item['telemetryConfiguration']['sampleInterval']
device_type = firmware_opt['interconnects'].first['deviceType']
item['telemetryConfiguration']['sampleCount'] = device_type.include?('Virtual Connect SE 16Gb FC Module') ? 24 : 20
item['telemetryConfiguration']['sampleInterval'] = device_type.include?('Virtual Connect SE 16Gb FC Module') ? 3600 : 200
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
enet_trap = %w[PortStatus]
fc_trap = %w[PortStatus]
vcm_trap = %w[Legacy]
trap_sev = %w[Normal Warning Critical]
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

# This section illustrates scope usage with the Logical Interconnect. Supported in API 300 and onwards.
# When a scope uri is added to a logical interconnect, the logical interconnect is grouped into a resource pool.
# Once grouped, with the scope it's possible to restrict an operation or action.
puts "\nOperations with scopes"
begin
  # Scope class used in this sample
  scope_class = OneviewSDK.resource_named('Scope', @client.api_version) unless @client.api_version.to_i <= 200 || @client.api_version.to_i >= 600
  # Creating scopes for this example
  scope_1 = scope_class.new(@client, name: 'Scope 1')
  scope_1.create!
  scope_2 = scope_class.new(@client, name: 'Scope 2')
  scope_2.create!

  puts "\nAdding scopes to the logical interconnect"
  item.add_scope(scope_1)
  item.refresh
  puts 'Scopes:', item['scopeUris']

  puts "\nReplacing scopes inside the logical interconnec"
  item.replace_scopes(scope_2)
  item.refresh
  puts 'Scopes:', item['scopeUris']

  puts "\nRemoving scopes from the logical interconnect"
  item.remove_scope(scope_1)
  item.remove_scope(scope_2)
  item.refresh
  puts 'Scopes:', item['scopeUris']

  # Clear data
  scope_1.delete
  scope_2.delete
rescue NoMethodError
  puts "\nScope operations is not supported in this version."
end
