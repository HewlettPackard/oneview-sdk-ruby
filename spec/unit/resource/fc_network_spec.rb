require 'spec_helper'

RSpec.describe OneviewSDK::Client do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      profile = OneviewSDK::FCNetwork.new(@client)
      expect(profile[:type]).to eq('fc-networkV2')
      expect(profile[:autoLoginRedistribution]).to eq(false)
      expect(profile[:linkStabilityTime]).to eq(30)
      expect(profile[:fabricType]).to eq('FabricAttach')
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
