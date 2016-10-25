require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  let(:item_2) { klass.new($client_300, name: LOG_INT_GROUP2_NAME) }
  let(:eth) { OneviewSDK::API300::Thunderbird::EthernetNetwork.new($client_300, name: ETH_NET_NAME) }
  let(:uplink_options_2) do
    {
      name: LIG_UPLINK_SET2_NAME,
      networkType: 'Ethernet',
      ethernetNetworkType: 'Tagged'
    }
  end
  let(:uplink_2) { OneviewSDK::API300::Thunderbird::LIGUplinkSet.new($client_300, uplink_options_2) }

  describe '#update' do
    it 'adding and removing uplink set' do
      item_2.retrieve!
      eth.retrieve!

      uplink_2.add_network(eth)
      uplink_2.add_uplink(1, 'X1')

      item_2.add_uplink_set(uplink_2)

      expect { item_2.update }.not_to raise_error

      expect(item_2['uri']).to be
      expect(item_2['uplinkSets']).to_not be_empty

      item_2['uplinkSets'] = []
      expect { item_2.update }.to_not raise_error
      expect(item_2['uri']).to be
      expect(item_2['uplinkSets']).to be_empty
    end
  end
end
