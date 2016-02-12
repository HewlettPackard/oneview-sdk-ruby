require 'spec_helper'

RSpec.describe OneviewSDK::EthernetNetwork do
  include_context 'shared context'

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

  describe 'validations' do
    it 'validates ethernetNetworkType' do
      options = { ethernetNetworkType: 'FakeType' }
      expect { OneviewSDK::EthernetNetwork.new(@client, options) }.to raise_error(/Invalid network type/)
    end

    it 'validates purpose' do
      options = { purpose: 'Fake' }
      expect { OneviewSDK::EthernetNetwork.new(@client, options) }.to raise_error(/Invalid ethernet purpose/)
    end

  end
end
