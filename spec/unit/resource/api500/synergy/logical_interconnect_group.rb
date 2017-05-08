require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::LogicalInterconnectGroup do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::LogicalInterconnectGroup' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::LogicalInterconnectGroup
  end
end
