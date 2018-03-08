require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::FCNetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::FCNetwork' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::FCNetwork
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::API600::Synergy::FCNetwork.new(@client_600)
      expect(item[:type]).to eq('fc-networkV4')
      expect(item[:autoLoginRedistribution]).to eq(false)
      expect(item[:linkStabilityTime]).to eq(30)
      expect(item[:fabricType]).to eq('FabricAttach')
    end
  end
end
