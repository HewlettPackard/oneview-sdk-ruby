require_relative '_client'

type = 'Logical Interconnect Group'

# Example: Create a Logical Interconnect Group
# NOTE: This will create a few networks (ethernet & FC), as well as a LIG named 'ONEVIEW_SDK_TEST_LIG', then delete them all.
options = {
  name: 'ONEVIEW_SDK_TEST_LIG',
  enclosureType: 'C7000',
  type: 'logical-interconnect-groupV3'
}

HP_VC_FF_24_MODEL = 'HP VC FlexFabric 10Gb/24-Port Module'

lig = OneviewSDK::LogicalInterconnectGroup.new(@client, options)

# Add the interconnects to the bays 1 and 2
lig.add_interconnect(1, HP_VC_FF_24_MODEL)
lig.add_interconnect(2, HP_VC_FF_24_MODEL)

# Create an Ethernet Uplink Set
eth1_options = {
  vlanId:  801,
  purpose:  'General',
  name:  'ONEVIEW_SDK_TEST_ETH01',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri:  nil,
  type:  'ethernet-networkV3'
}

eth2_options = {
  vlanId:  802,
  purpose:  'General',
  name:  'ONEVIEW_SDK_TEST_ETH02',
  smartLink:  false,
  privateNetwork:  false,
  connectionTemplateUri:  nil,
  type:  'ethernet-networkV3'
}

eth01 = OneviewSDK::EthernetNetwork.new(@client, eth1_options)
eth02 = OneviewSDK::EthernetNetwork.new(@client, eth2_options)

eth01.create
eth02.create

upset01_options = {
  name: 'ETH_UP_01',
  networkType: 'Ethernet',
  ethernetNetworkType: 'Tagged'
}

upset01 = OneviewSDK::LIGUplinkSet.new(@client, upset01_options)
upset01.add_network(eth01)
upset01.add_network(eth02)

upset01.add_uplink(1, 'X5')
upset01.add_uplink(1, 'X6')
upset01.add_uplink(2, 'X7')
upset01.add_uplink(2, 'X8')

# lig.add_uplink_set(upset01)

# Create an FC Uplink Set
fc1_options = {
  name: 'ONEVIEW_SDK_TEST_FC01',
  connectionTemplateUri: nil,
  autoLoginRedistribution: true,
  fabricType: 'FabricAttach'
}

fc01 = OneviewSDK::FCNetwork.new(@client, fc1_options)

fc01.create

upset02_options = {
  name: 'FC_UP_01',
  networkType: 'FibreChannel'
}

upset02 = OneviewSDK::LIGUplinkSet.new(@client, upset02_options)
upset02.add_network(fc01)

upset02.add_uplink(1, 'X1')
upset02.add_uplink(1, 'X2')
upset02.add_uplink(1, 'X3')

# lig.add_uplink_set(upset02)


# Create the fully configured LIG
lig.create
puts "\n#{type} #{lig[:name]} created!"


# List the LIGs
# Example: List all the logical interconnect groups
puts "\n#{type}s:"
OneviewSDK::LogicalInterconnectGroup.find_by(@client, {}).each do |r|
  puts "  #{r[:name]}"
end


# Clean up after ourselves
lig.delete
eth01.delete
eth02.delete
fc01.delete
puts "\nCleanup complete!"
