require 'spec_helper'

RSpec.describe OneviewSDK::API300::Thunderbird::FCNetwork do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::FCNetwork
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = OneviewSDK::API300::Thunderbird::FCNetwork.new(@client_300)
      expect(item[:type]).to eq('fc-networkV2')
      expect(item[:autoLoginRedistribution]).to eq(false)
      expect(item[:linkStabilityTime]).to eq(30)
      expect(item[:fabricType]).to eq('FabricAttach')
    end
  end
end
