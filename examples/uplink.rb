require_relative '_client'

ethernet = OneviewSDK::EthernetNetwork.new(@client, name: 'lig_eth01')
ethernet.retrieve!
puts "Ethernet uri = '#{ethernet[:uri]}'"

options = {
  nativeNetworkUri: nil,
  reachability: 'Reachable',
  logicalInterconnectUri: '/rest/logical-interconnects/a01359e7-4cde-4e88-9d58-acda9fdfdd15',
  manualLoginRedistributionState: 'NotSupported',
  connectionMode: 'Auto',
  lacpTimer: 'Short',
  networkType: 'Ethernet',
  ethernetNetworkType: 'Tagged',
  description: nil,
  name: 'Teste Uplink'
}

uplink = OneviewSDK::Uplink.new(@client, options)
uplink.add_portConfig(
  '/rest/interconnects/f5b3790b-242f-4fed-8a6c-6ca2334e52aa',
  'Auto',
  [{ value: 1, type: 'Bay' }, { value: '/rest/enclosures/09SGH102X6J1', type: 'Enclosure' }, { value: 'X1', type: 'Port' }]
)

puts uplink.data
uplink.add_network(ethernet)
uplink.create
uplink.delete
