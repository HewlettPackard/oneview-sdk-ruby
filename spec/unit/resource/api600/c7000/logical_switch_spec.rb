require 'spec_helper'

klass = OneviewSDK::API600::C7000::LogicalSwitch
RSpec.describe klass do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::C7000::LogicalSwitch' do
    expect(described_class).to be < OneviewSDK::API500::C7000::LogicalSwitch
  end

  describe '#initialize' do
    context 'OneView 4.0' do
      it 'sets the defaults correctly' do
        logical_switch = OneviewSDK::API600::C7000::LogicalSwitch.new(@client_300)
        expect(logical_switch[:type]).to eq('logical-switchV4')
      end
    end
  end
end
