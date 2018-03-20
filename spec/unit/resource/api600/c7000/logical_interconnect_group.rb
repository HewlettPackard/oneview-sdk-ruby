require 'spec_helper'

RSpec.describe OneviewSDK::API600::C7000::LogicalInterconnectGroup do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::LogicalInterconnectGroup' do
    expect(described_class).to be < OneviewSDK::API500::C7000::LogicalInterconnectGroup
  end

  describe '#initialize' do
    it 'should be initialize the instance with default values' do
      item = described_class.new(@client_600)
      expect(item['type']).to eq('logical-interconnect-groupV4')
    end
  end
end
