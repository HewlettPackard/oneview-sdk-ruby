require 'spec_helper'

RSpec.describe OneviewSDK::FCNetwork do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::FCNetwork.new(@client)
      expect(item[:type]).to eq('fc-networkV2')
      expect(item[:autoLoginRedistribution]).to eq(false)
      expect(item[:linkStabilityTime]).to eq(30)
      expect(item[:fabricType]).to eq('FabricAttach')
    end
  end

  describe 'validations' do
    it 'validates fabricType' do
      options = { fabricType: 'FakeAttach' }
      expect { OneviewSDK::FCNetwork.new(@client, options) }.to raise_error(/Invalid fabric type/)
    end

    it 'validates linkStabilityTime' do
      options = { fabricType: 'FabricAttach', linkStabilityTime: 0 }
      expect { OneviewSDK::FCNetwork.new(@client, options) }.to raise_error(/Link stability time out of range/)
    end

    it 'does not validate linkStabilityTime for DirectAttach networks' do
      options = { fabricType: 'DirectAttach', linkStabilityTime: 0 }
      expect { OneviewSDK::FCNetwork.new(@client, options) }.to_not raise_error
    end
  end
end
