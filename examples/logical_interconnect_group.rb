require_relative '_client'

# Example: Create a Logical Interconnect Group
options = {
  name: 'FULL_LIG_SDK',
  enclosureType: "C7000",
  type: 'logical-interconnect-groupV3'
}

HP_VC_FF_24_MODEL = 'HP VC FlexFabric 10Gb/24-Port Module'

lig = OneviewSDK::LogicalInterconnectGroup.new(@client, options)

# Add the interconnects to the bays 1 and 2
lig.add_interconnect(1, HP_VC_FF_24_MODEL)
lig.add_interconnect(2, HP_VC_FF_24_MODEL)

# Create an Ethernet Uplink Set
upset01_options = {
  name: 'ETH_UP_01',
  networkType: 'Ethernet',
  ethernetNetworkType: 'Tagged'
}

eth1_options = {
  vlanId:  801,
  purpose:  'General',
  name:  'lig_eth01',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri:  nil,
  type:  'ethernet-networkV3'
}

eth2_options = {
  vlanId:  802,
  purpose:  'General',
  name:  'lig_eth02',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri:  nil,
  type:  'ethernet-networkV3'
}

upset01 = OneviewSDK::LIGUplinkSet.new(@client, upset01_options)
eth01 = OneviewSDK::EthernetNetwork.new(@client, eth1_options)
eth02 = OneviewSDK::EthernetNetwork.new(@client, eth2_options)

eth01.create!
eth02.create!
upset01.add_network(eth01)
upset01.add_network(eth02)

upset01.add_uplink(1, "X5")
upset01.add_uplink(1, "X6")
upset01.add_uplink(2, "X7")
upset01.add_uplink(2, "X8")

lig.add_uplink_set(upset01)

# Create an FC Uplink Set
upset02_options = {
  name: 'FC_UP_01',
  networkType: 'FibreChannel',
}

fc1_options = {
  name: 'lig_fc_01',
  connectionTemplateUri: nil,
  autoLoginRedistribution: true,
  fabricType: 'FabricAttach'
}

upset02 = OneviewSDK::LIGUplinkSet.new(@client, upset02_options)
fc01 = OneviewSDK::FCNetwork.new(@client, fc1_options)

fc01.create!
upset02.add_network(fc01)

upset02.add_uplink(1, 'X1')
upset02.add_uplink(1, 'X2')

lig.add_uplink_set(upset02)

# Create the fully configured LIG
lig.create!
