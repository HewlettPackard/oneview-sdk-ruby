require 'spec_helper'

RSpec.describe OneviewSDK::API800::Synergy::FCNetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API600::Synergy::FCNetwork' do
    expect(described_class).to be < OneviewSDK::API600::Synergy::FCNetwork
  end
end
