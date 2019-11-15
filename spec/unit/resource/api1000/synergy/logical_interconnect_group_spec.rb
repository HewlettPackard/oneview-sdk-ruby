require 'spec_helper'

RSpec.describe OneviewSDK::API1000::Synergy::LogicalInterconnectGroup do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API800::Synergy::LogicalInterconnectGroup' do
    expect(described_class).to be < OneviewSDK::API800::Synergy::LogicalInterconnectGroup
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      item = described_class.new(@client_1000)
      expect(item['type']).to eq('logical-interconnect-groupV6')
    end
  end
end
