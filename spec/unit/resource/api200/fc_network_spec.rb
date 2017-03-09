require 'spec_helper'

RSpec.describe OneviewSDK::FCNetwork do
  include_context 'shared context'

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::FCNetwork.new(@client_200)
      expect(item[:type]).to eq('fc-networkV2')
      expect(item[:autoLoginRedistribution]).to eq(false)
      expect(item[:linkStabilityTime]).to eq(30)
      expect(item[:fabricType]).to eq('FabricAttach')
    end
  end
end
