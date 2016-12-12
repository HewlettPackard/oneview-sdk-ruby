require 'spec_helper'

klass = OneviewSDK::API300::Synergy::EthernetNetwork
RSpec.describe klass, integration: true, type: CREATE, sequence: seq(klass) do
  include_context 'integration api300 context'

  let(:file_path) { 'spec/support/fixtures/integration/ethernet_network.json' }

  describe '#create' do
    it 'can create resources' do
      item = OneviewSDK::API300::Synergy::EthernetNetwork.from_file($client_300_synergy, file_path)
      item.create
      expect(item[:name]).to eq(ETH_NET_NAME)
      expect(item[:ethernetNetworkType]).to eq('Tagged')
      expect(item[:vlanId]).to eq(1001)
      expect(item[:purpose]).to eq('General')
      expect(item[:smartLink]).to eq(false)
      expect(item[:privateNetwork]).to eq(false)
    end

    it 'bulk create ethernet resources' do
      bulk_options = {
        vlanIdRange: BULK_ETH_NET_RANGE,
        purpose: 'General',
        namePrefix: BULK_ETH_NET_PREFIX,
        smartLink: false,
        privateNetwork: false,
        bandwidth: {
          maximumBandwidth: 10_000,
          typicalBandwidth: 2_000
        }
      }
      bulk_networks = OneviewSDK::API300::Synergy::EthernetNetwork.bulk_create($client_300_synergy, bulk_options)
      expect(bulk_networks.length).to eq(5)
    end
  end

  describe '#retrieve!' do
    it 'retrieves the resource' do
      item = OneviewSDK::API300::Synergy::EthernetNetwork.new($client_300_synergy, name: ETH_NET_NAME)
      item.retrieve!
      expect(item[:name]).to eq(ETH_NET_NAME)
      expect(item[:ethernetNetworkType]).to eq('Tagged')
      expect(item[:vlanId]).to eq(1001)
      expect(item[:purpose]).to eq('General')
      expect(item[:smartLink]).to eq(false)
      expect(item[:privateNetwork]).to eq(false)
    end
  end

  describe '#find_by' do
    it 'returns all resources when the hash is empty' do
      names = OneviewSDK::API300::Synergy::EthernetNetwork.find_by($client_300_synergy, {}).map { |item| item[:name] }
      expect(names).to include(ETH_NET_NAME)
    end

    it 'finds networks by multiple attributes' do
      attrs = { name: ETH_NET_NAME, vlanId: 1001, purpose: 'General' }
      names = OneviewSDK::API300::Synergy::EthernetNetwork.find_by($client_300_synergy, attrs).map { |item| item[:name] }
      expect(names).to include(ETH_NET_NAME)
    end
  end
end
