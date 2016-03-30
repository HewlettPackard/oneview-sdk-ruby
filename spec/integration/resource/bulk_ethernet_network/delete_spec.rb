require 'spec_helper'

RSpec.describe OneviewSDK::BulkEthernetNetwork, integration: true, type: DELETE, sequence: 12 do
  include_context 'integration context'

  describe '#delete' do
    it 'deletes the resources' do
      networks = OneviewSDK::EthernetNetwork.get_all($client).select { |e| e['name'].match(/^#{BULK_ETH_NET_PREFIX}_\d*/) }
      networks.map(&:delete)
      networks = OneviewSDK::EthernetNetwork.get_all($client).select { |e| e['name'].match(/^#{BULK_ETH_NET_PREFIX}_\d*/) }
      expect(networks.size).to eq(0)
    end
  end
end
