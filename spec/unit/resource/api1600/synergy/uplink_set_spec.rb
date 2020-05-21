require 'spec_helper'

RSpec.describe OneviewSDK::API1600::Synergy::UplinkSet do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1200::Synergy::UplinkSet' do
    expect(described_class).to be < OneviewSDK::API1200::Synergy::UplinkSet
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      item = described_class.new(@client_1000)
      expect(item['type']).to eq('uplink-setV7')
    end
  end
end
