require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::LogicalInterconnectGroup do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::Synergy::LogicalInterconnectGroup' do
    expect(described_class).to be < OneviewSDK::API500::Synergy::LogicalInterconnectGroup
  end
end
