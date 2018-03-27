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

require_relative '../_client' # Gives access to @client and @logical_interconnect_name

# Example: Create/Update/Delete an uplink set
# NOTE: This will create a uplink set named 'UplinkSet Example', then update it with network, then delete it.
# NOTE 2: Dependencies: Enclosure, EthernetNetwork, LogicalInterconnectGroup, LogicalInterconnect, Interconnect.
# NOTE 3: To add an ethernet network, the interconnect must support ethernet network.
#
# Supported APIs:
# - 200, 300, 500, 600

# Resources that can be created according to parameters:
# api_version = 200 & variant = any to OneviewSDK::API200::UplinkSet
# api_version = 300 & variant = C7000 to OneviewSDK::API300::C7000::UplinkSet
# api_version = 300 & variant = Synergy to OneviewSDK::API300::Synergy::UplinkSet
# api_version = 500 & variant = C7000 to OneviewSDK::API500::C7000::UplinkSet
# api_version = 500 & variant = Synergy to OneviewSDK::API500::Synergy::UplinkSet
# api_version = 600 & variant = C7000 to OneviewSDK::API600::C7000::UplinkSet
# api_version = 600 & variant = Synergy to OneviewSDK::API600::Synergy::UplinkSet

# Resource Class used in this sample
uplink_set_class = OneviewSDK.resource_named('UplinkSet', @client.api_version)
ethernet_class = OneviewSDK.resource_named('EthernetNetwork', @client.api_version)
li_class = OneviewSDK.resource_named('LogicalInterconnect', @client.api_version)
interconnect_class = OneviewSDK.resource_named('Interconnect', @client.api_version)

ethernet = ethernet_class.get_all(@client).first
logical_interconnect = li_class.find_by(@client, name: @logical_interconnect_name).first

interconnect = interconnect_class.find_by(@client, logicalInterconnectUri: logical_interconnect['uri']).first

port = interconnect['ports'].select { |item| item['portType'] == 'Uplink' && item['portStatus'] == 'Unlinked' }.first

options = {
  nativeNetworkUri: nil,
  reachability: 'Reachable',
  manualLoginRedistributionState: 'NotSupported',
  connectionMode: 'Auto',
  lacpTimer: 'Short',
  networkType: 'Ethernet',
  ethernetNetworkType: 'Tagged',
  description: nil,
  name: 'UplinkSet Example'
}

uplink = uplink_set_class.new(@client, options)
uplink.set_logical_interconnect(logical_interconnect)

puts "\nCreating UplinkSet ..."
uplink.create
puts "\nUplinkSet '#{uplink['uri']}' created successfully!"

puts "\nUpdating the port config"
uplink.add_port_config(
  port['uri'],
  'Auto',
  [
    { value: port['bayNumber'], type: 'Bay' },
    { value: interconnect['enclosureUri'], type: 'Enclosure' },
    { value: port['portName'], type: 'Port' }
  ]
)

uplink.update
uplink.retrieve!

puts "\nPort config updated successfully. \nPort config: #{uplink['portConfigInfos']}"
puts "\nClean up the port config"
uplink['portConfigInfos'].clear
uplink.update
uplink.retrieve!
puts "\nClean up done. \nPort config: #{uplink['portConfigInfos']}"

# To add fc network and fcoe networks use respectively add_fcnetwork and add_fcoenetwork
puts "\nUpdating UplinkSet (adding network '#{ethernet['uri']}') ..."
uplink.add_network(ethernet)
uplink.update
uplink.retrieve!
puts "\nUplinkSet updated successfully! \nNetworks: #{uplink['networkUris']}"

puts "\nRemoving the network added..."
uplink['networkUris'].delete(ethernet['uri'])
uplink.update
uplink.retrieve!
puts "\nNetwork removed successfully! \nNetworks: #{uplink['networkUris']}"

puts "\nDeleting UplinkSet ..."
uplink.delete
puts "\nUplinkSet deleted successfully!" unless uplink.retrieve!
