require 'spec_helper'

RSpec.describe OneviewSDK::EthernetNetwork do
  include_context 'shared context'
=begin
  describe '#initialize' do
    it 'sets the defaults correctly api_ver 120' do
      item = OneviewSDK::EthernetNetwork.new(@client, {}, 120)
      expect(item[:ethernetNetworkType]).to eq('Tagged')
      expect(item[:type]).to eq('ethernet-networkV2')
    end
    it 'sets the defaults correctly api_ver 200' do
      item = OneviewSDK::EthernetNetwork.new(@client, {}, 200)
      expect(item[:ethernetNetworkType]).to eq('Tagged')
      expect(item[:type]).to eq('ethernet-networkV3')
    end
  end

  describe '#get_associated_profiles' do
    it 'requires a uri' do
      expect { OneviewSDK::EthernetNetwork.new(@client).get_associated_profiles }.to raise_error(/Please set uri/)
    end

    it 'returns the response body from uri/associatedProfiles' do
      item = OneviewSDK::EthernetNetwork.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with("#{item['uri']}/associatedProfiles", item.api_version)
        .and_return(FakeResponse.new('[]'))
      expect(item.get_associated_profiles).to eq('[]')
    end
  end

  describe '#get_associated_uplink_groups' do
    it 'requires a uri' do
      expect { OneviewSDK::EthernetNetwork.new(@client).get_associated_uplink_groups }.to raise_error(/Please set uri/)
    end

    it 'returns the response body from uri/associatedUplinkGroups' do
      item = OneviewSDK::EthernetNetwork.new(@client, uri: '/rest/fake')
      expect(@client).to receive(:rest_get).with("#{item['uri']}/associatedUplinkGroups", item.api_version)
        .and_return(FakeResponse.new('[]'))
      expect(item.get_associated_uplink_groups).to eq('[]')
    end
  end
=end
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
      list = OneviewSDK::EthernetNetwork.bulk_create(@client, options)
      expect(list.length).to eq(3)
    end
  end

  describe 'validations' do
    it 'validates ethernetNetworkType' do
      OneviewSDK::EthernetNetwork::VALID_ETHERNET_NETWORK_TYPES.each do |i|
        expect { OneviewSDK::EthernetNetwork.new(@client, ethernetNetworkType: i) }.to_not raise_error
      end
      expect { OneviewSDK::EthernetNetwork.new(@client, ethernetNetworkType: 'FakeType') }.to raise_error(/Invalid network type/)
    end

    it 'validates the purpose' do
      OneviewSDK::EthernetNetwork::VALID_PURPOSES.each do |i|
        expect { OneviewSDK::EthernetNetwork.new(@client, purpose: i) }.to_not raise_error
      end
      expect { OneviewSDK::EthernetNetwork.new(@client, purpose: 'Fake') }.to raise_error(/Invalid ethernet purpose/)
    end
  end
end
