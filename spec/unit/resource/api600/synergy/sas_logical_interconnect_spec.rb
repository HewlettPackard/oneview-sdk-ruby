require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::SASLogicalInterconnect do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::Synergy::SASLogicalInterconnect' do
    expect(described_class).to be < OneviewSDK::API500::Synergy::SASLogicalInterconnect
  end
end
