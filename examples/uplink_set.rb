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

ethernet = OneviewSDK::EthernetNetwork.new(@client, name: 'lig_eth01')
ethernet.retrieve!
puts "Ethernet uri = '#{ethernet[:uri]}'"

options = {
  nativeNetworkUri: nil,
  reachability: 'Reachable',
  logicalInterconnectUri: '/rest/logical-interconnects/a577f08e-4de6-41f4-8570-729290a24e37',
  manualLoginRedistributionState: 'NotSupported',
  connectionMode: 'Auto',
  lacpTimer: 'Short',
  networkType: 'Ethernet',
  ethernetNetworkType: 'Tagged',
  description: nil,
  name: 'Teste Uplink'
}

uplink = OneviewSDK::UplinkSet.new(@client, options)
uplink.add_port_config(
  '/rest/interconnects/f5b3790b-242f-4fed-8a6c-6ca2334e52aa',
  'Auto',
  [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH102X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
)

puts uplink.data
uplink.add_network(ethernet)
uplink.create
uplink.delete
