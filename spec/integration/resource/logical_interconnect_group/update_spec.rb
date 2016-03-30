require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup, integration: true, type: UPDATE do
  include_context 'integration context'

  let(:lig_default_options) do
    {
      'name' => LOG_INT_GROUP_NAME,
      'enclosureType' => 'C7000',
      'type' => 'logical-interconnect-groupV3'
    }
  end
  let(:lig) { OneviewSDK::LogicalInterconnectGroup.new($client, lig_default_options) }
  let(:interconnect_type) { 'HP VC FlexFabric 10Gb/24-Port Module' }

  describe '#update' do
    it 'adding and removing uplink set' do
      lig.add_interconnect(1, interconnect_type)
      uplink_options = {
        name: LIG_UPLINK_SET_NAME,
        networkType: 'Ethernet',
        ethernetNetworkType: 'Tagged'
      }
      uplink = OneviewSDK::LIGUplinkSet.new($client, uplink_options)
      eth = OneviewSDK::EthernetNetwork.new($client, name: ETH_NET_NAME)
      eth.retrieve!
      uplink.add_network(eth)
      uplink.add_uplink(1, 'X1')
      lig.add_uplink_set(uplink)
      expect { lig.create! }.not_to raise_error
      expect(lig['uri']).to be
      expect(lig['uplinkSets']).to_not be_empty

      lig['uplinkSets'] = []
      expect { lig.update }.to_not raise_error
      expect(lig['uri']).to be
      expect(lig['uplinkSets']).to be_empty
    end
  end
end
