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
