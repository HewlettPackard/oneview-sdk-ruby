require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::EthernetNetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::EthernetNetwork' do
    expect(described_class).to be < OneviewSDK::API500::C7000::EthernetNetwork
  end

  describe '#initialize' do
    it 'sets the defaults correctly api_ver 600' do
      item = OneviewSDK::API600::C7000::EthernetNetwork.new(@client_600, {}, 200)
      expect(item[:ethernetNetworkType]).to eq('Tagged')
      expect(item[:type]).to eq('ethernet-networkV4')
    end
  end

  describe '#bulk_create' do
    let(:options) do
      {
        vlanIdRange: '26-28',
        purpose: 'General',
        namePrefix: 'Ethernet_Network'
      }
    end
    it 'returns true' do
      file = File.read('spec/support/fixtures/unit/resource/ethernet_networks_members.json')
      networks = JSON.parse(file)
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_get).and_return(FakeResponse.new(networks, 200))
      expect_any_instance_of(OneviewSDK::Client).to receive(:rest_post).and_return(FakeResponse.new({}, 202))
      expect_any_instance_of(OneviewSDK::Client).to receive(:wait_for).and_return({})
      list = OneviewSDK::API600::C7000::EthernetNetwork.bulk_create(@client_600, options)
      expect(list.length).to eq(3)
    end
  end
end
