require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::SASInterconnect do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::Synergy::SASInterconnect' do
    expect(described_class).to be < OneviewSDK::API500::Synergy::SASInterconnect
  end
end
