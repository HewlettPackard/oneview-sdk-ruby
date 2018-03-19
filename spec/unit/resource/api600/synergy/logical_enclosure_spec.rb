require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::LogicalEnclosure do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::Synergy::LogicalEnclosure' do
    expect(described_class).to be < OneviewSDK::API500::Synergy::LogicalEnclosure
  end
end
