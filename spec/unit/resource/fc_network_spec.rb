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
      OneviewSDK::FCNetwork::VALID_FABRIC_TYPES.each do |i|
        expect { OneviewSDK::FCNetwork.new(@client, fabricType: i) }.to_not raise_error
      end
      expect { OneviewSDK::FCNetwork.new(@client, fabricType: 'FakeAttach') }.to raise_error(OneviewSDK::InvalidResource, /Invalid fabric type/)
    end

    it 'validates linkStabilityTime' do
      options = { fabricType: 'FabricAttach', linkStabilityTime: 0 }
      options2 = { fabricType: 'FabricAttach', linkStabilityTime: 1 }
      options3 = { fabricType: 'FabricAttach', linkStabilityTime: 1800 }
      options4 = { fabricType: 'FabricAttach', linkStabilityTime: 1801 }
      expect { OneviewSDK::FCNetwork.new(@client, options) }.to raise_error(OneviewSDK::InvalidResource, /Link stability time out of range/)
      expect { OneviewSDK::FCNetwork.new(@client, options2) }.to_not raise_error
      expect { OneviewSDK::FCNetwork.new(@client, options3) }.to_not raise_error
      expect { OneviewSDK::FCNetwork.new(@client, options4) }.to raise_error(OneviewSDK::InvalidResource, /Link stability time out of range/)
    end

    it 'does not validate linkStabilityTime for DirectAttach networks' do
      options = { fabricType: 'DirectAttach', linkStabilityTime: 0 }
      expect { OneviewSDK::FCNetwork.new(@client, options) }.to_not raise_error
    end
  end
end
