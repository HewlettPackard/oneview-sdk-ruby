require 'spec_helper'

klass = OneviewSDK::API300::Thunderbird::LogicalInterconnectGroup
RSpec.describe klass, integration: true, type: UPDATE do
  include_context 'integration api300 context'

  describe '#update' do
    it 'adding and removing networks' do
      item_2 = klass.new($client_300, name: LOG_INT_GROUP2_NAME)
      item_2.retrieve!

      ethernet_network = OneviewSDK::API300::Thunderbird::EthernetNetwork.new($client_300, name: ETH_NET_NAME)
      ethernet_network.retrieve!

      item_2['internalNetworkUris'] = []
      expect { item_2.update }.not_to raise_error

      item_2.retrieve!

      item_2.add_internal_network(ethernet_network)
      expect { item_2.update }.not_to raise_error

      expect(item_2['internalNetworkUris']).to eq([ethernet_network['uri']])
    end
  end
end
