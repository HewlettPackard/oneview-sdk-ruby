require 'spec_helper'

klass = OneviewSDK::API600::C7000::LogicalSwitchGroup
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::LogicalSwitchGroup' do
    expect(described_class).to be < OneviewSDK::API500::C7000::LogicalSwitchGroup
  end

  describe '#initialize' do
    it 'sets the defaults correctly' do
      item = klass.new(@client_600)
      expect(item['type']).to eq('logical-switch-groupV4')
    end
  end
end
