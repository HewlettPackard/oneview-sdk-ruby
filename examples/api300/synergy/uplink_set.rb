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

require_relative '../../_client' # Gives access to @client, @enclosure_name, @interconnect_name

# NOTE: This will create a uplink set named 'UplinkSet Example', then update it with network, then delete it.
# NOTE 2: Dependencies: Enclosure, EthernetNetwork, LogicalInterconnectGroup, LogicalInterconnect, Interconnect

fc_ethernet = OneviewSDK::API300::Synergy::FCNetwork.get_all(@client).first
logical_interconnect = OneviewSDK::API300::Synergy::LogicalInterconnect.get_all(@client).first

enclosure = OneviewSDK::API300::Synergy::Enclosure.new(@client, name: @enclosure_name)
enclosure.retrieve!

interconnect = OneviewSDK::API300::Synergy::Interconnect.new(@client, name: @interconnect_name)
interconnect.retrieve!

port = interconnect['ports'].select { |item| item['portType'] == 'Uplink' && item['portHealthStatus'] == 'Normal' }.first

options = {
  logicalInterconnectUri: logical_interconnect['uri'],
  nativeNetworkUri: nil,
  reachability: 'NotReachable',
  manualLoginRedistributionState: 'Supported',
  connectionMode: 'Auto',
  lacpTimer: 'Short',
  networkType: 'FibreChannel',
  ethernetNetworkType: 'NotApplicable',
  description: nil,
  name: 'UplinkSet Example'
}

uplink = OneviewSDK::API300::Synergy::UplinkSet.new(@client, options)
uplink.add_port_config(
  port['uri'],
  'Auto',
  [{ value: port['bayNumber'], type: 'Bay' }, { value: enclosure[:uri], type: 'Enclosure' }, { value: port['portName'], type: 'Port' }]
)

puts "\nUplinkSet data:"
puts uplink.data

puts "\nCreating UplinkSet ..."
uplink.create
puts "UplinkSet '#{uplink['uri']}' created successfully!"

puts "\nUpdating UplinkSet (adding network '#{fc_ethernet['uri']}') ..."
uplink.add_fcnetwork(fc_ethernet)
uplink.update
uplink.refresh
puts 'UplinkSet updated successfully!'

puts "\nUplinkSet data:"
puts uplink.data

puts "\nDeleting UplinkSet ..."
uplink.delete
puts 'UplinkSet deleted successfully!' unless uplink.retrieve!
