require 'spec_helper'

RSpec.describe OneviewSDK::API1200::Synergy::LogicalInterconnect do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API800::Synergy::LogicalInterconnect' do
    expect(described_class).to be < OneviewSDK::API800::Synergy::LogicalInterconnect
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      item = described_class.new(@client_1200)
      expect(item['type']).to eq('logical-interconnectV6')
    end
  end
end