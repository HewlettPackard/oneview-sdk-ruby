require 'spec_helper'

RSpec.describe OneviewSDK::API300::C7000::EthernetNetwork do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::EthernetNetwork
  end

  describe '#initialize' do
    it 'sets the defaults correctly api_ver 200' do
      item = OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300, {}, 200)
      expect(item[:ethernetNetworkType]).to eq('Tagged')
      expect(item[:type]).to eq('ethernet-networkV300')
    end
  end

  describe '#get_associated_profiles' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300).get_associated_profiles }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'returns the response body from uri/associatedProfiles' do
      item = OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with("#{item['uri']}/associatedProfiles", {}, item.api_version)
        .and_return(FakeResponse.new('[]'))
      expect(item.get_associated_profiles).to eq('[]')
    end
  end

  describe '#get_associated_uplink_groups' do
    it 'requires a uri' do
      expect { OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300).get_associated_uplink_groups }
        .to raise_error(OneviewSDK::IncompleteResource, /Please set uri/)
    end

    it 'returns the response body from uri/associatedUplinkGroups' do
      item = OneviewSDK::API300::C7000::EthernetNetwork.new(@client_300, uri: '/rest/fake')
      expect(@client_300).to receive(:rest_get).with("#{item['uri']}/associatedUplinkGroups", {}, item.api_version)
        .and_return(FakeResponse.new('[]'))
      expect(item.get_associated_uplink_groups).to eq('[]')
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
      list = OneviewSDK::API300::C7000::EthernetNetwork.bulk_create(@client_300, options)
      expect(list.length).to eq(3)
    end
  end
end
