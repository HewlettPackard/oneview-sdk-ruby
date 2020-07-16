require 'spec_helper'

RSpec.describe OneviewSDK::API1800::Synergy::LogicalEnclosure do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1600::Synergy::LogicalEnclosure' do
    expect(described_class).to be < OneviewSDK::API1600::Synergy::LogicalEnclosure
  end
end
