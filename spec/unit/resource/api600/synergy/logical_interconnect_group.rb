require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::LogicalInterconnectGroup do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API600::C7000::LogicalInterconnectGroup' do
    expect(described_class).to be < OneviewSDK::API600::C7000::LogicalInterconnectGroup
  end
end
