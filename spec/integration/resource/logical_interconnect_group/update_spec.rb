require 'spec_helper'

RSpec.describe OneviewSDK::LogicalInterconnectGroup, integration: true, type: UPDATE do
  include_context 'integration context'

  let(:item_2) { OneviewSDK::LogicalInterconnectGroup.new($client, name: LOG_INT_GROUP2_NAME) }
  let(:eth) { OneviewSDK::EthernetNetwork.new($client, name: ETH_NET_NAME) }
  let(:uplink_options_2) do
    {
      name: LIG_UPLINK_SET2_NAME,
      networkType: 'Ethernet',
      ethernetNetworkType: 'Tagged'
    }
  end
  let(:uplink_2) { OneviewSDK::LIGUplinkSet.new($client, uplink_options_2) }

  describe '#save' do
    it 'adding and removing uplink set' do
      item_2.retrieve!
      eth.retrieve!

      uplink_2.add_network(eth)
      uplink_2.add_uplink(1, 'X1')

      item_2.add_uplink_set(uplink_2)

      expect { item_2.save }.not_to raise_error

      expect(item_2['uri']).to be
      expect(item_2['uplinkSets']).to_not be_empty

      item_2['uplinkSets'] = []
      expect { item_2.save }.to_not raise_error
      expect(item_2['uri']).to be
      expect(item_2['uplinkSets']).to be_empty
    end
  end
end
