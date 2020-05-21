require 'spec_helper'

RSpec.describe OneviewSDK::API1000::Synergy::FCoENetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API800::Synergy::FCoENetwork' do
    expect(described_class).to be < OneviewSDK::API800::Synergy::FCoENetwork
  end
end
