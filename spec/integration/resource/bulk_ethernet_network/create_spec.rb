require 'spec_helper'

RSpec.describe OneviewSDK::BulkEthernetNetwork, integration: true, type: CREATE, sequence: 1 do
  include_context 'integration context'

  let(:bulk_options) do
    {
      vlanIdRange: '1-5',
      purpose: 'General',
      namePrefix: BULK_ETH_NET_PREFIX,
      smartLink: false,
      privateNetwork: false,
      bandwidth: {
        maximumBandwidth: 10_000,
        typicalBandwidth: 2_000
      },
      type: 'bulk-ethernet-network'
    }
  end

  describe '#create' do
    it 'can create multiple ethernet networks' do
      item = OneviewSDK::BulkEthernetNetwork.new($client, bulk_options)
      item.create
      networks = OneviewSDK::EthernetNetwork.get_all($client).select { |e| e['name'].match(/^#{BULK_ETH_NET_PREFIX}_\d*/) }
      expect(networks.size).to eq(5)
    end
  end
end
