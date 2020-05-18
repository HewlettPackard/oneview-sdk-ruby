require 'spec_helper'

RSpec.describe OneviewSDK::API1600::C7000::LogicalInterconnect do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1200::C7000::LogicalInterconnect' do
    expect(described_class).to be < OneviewSDK::API1200::C7000::LogicalInterconnect
  end
  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      item = described_class.new(@client_1600)
      expect(item['type']).to eq('logical-interconnectV8')
    end
  end
end
