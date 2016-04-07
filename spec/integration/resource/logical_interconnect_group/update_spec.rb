require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup, integration: true, type: UPDATE do
  include_context 'integration context'

  let(:lig_default_options_2) do
    {
      'name' => LOG_INT_GROUP2_NAME,
      'enclosureType' => 'C7000',
      'type' => 'logical-interconnect-groupV3'
    }
  end
  let(:item_2) { OneviewSDK::LogicalInterconnectGroup.new($client, lig_default_options_2) }
  let(:interconnect_type) { 'HP VC FlexFabric 10Gb/24-Port Module' }

  describe ''

  describe '#update' do
    it 'adding and removing uplink set' do
      uplink_options_2 = {
        name: LIG_UPLINK_SET2_NAME,
        networkType: 'Ethernet',
        ethernetNetworkType: 'Tagged'
      }
      uplink_2 = OneviewSDK::LIGUplinkSet.new($client, uplink_options_2)
      eth = OneviewSDK::EthernetNetwork.new($client, name: ETH_NET_NAME)
      eth.retrieve!
      uplink_2.add_network(eth)
      uplink_2.add_uplink(1, 'X1')
      item_2.add_uplink_set(uplink_2)
      expect { item_2.create! }.not_to raise_error
      expect(item_2['uri']).to be
      expect(item_2['uplinkSets']).to_not be_empty

      item_2['uplinkSets'] = []
      expect { item_2.update }.to_not raise_error
      expect(item_2['uri']).to be
      expect(item_2['uplinkSets']).to be_empty
    end
  end
end
