require 'spec_helper'

RSpec.describe OneviewSDK::API1600::Synergy::Interconnect do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1200::Synergy::Interconnect' do
    expect(described_class).to be < OneviewSDK::API1200::Synergy::Interconnect
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      item = described_class.new(@client_1600)
      expect(item['type']).to eq('InterconnectV7')
    end
  end
end