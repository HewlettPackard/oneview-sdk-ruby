require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::LogicalDownlink do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::LogicalDownlink' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::LogicalDownlink
  end
end
