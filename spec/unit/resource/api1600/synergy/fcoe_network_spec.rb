require 'spec_helper'

RSpec.describe OneviewSDK::API1600::Synergy::FCoENetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1200::Synergy::FCoENetwork' do
    expect(described_class).to be < OneviewSDK::API1200::Synergy::FCoENetwork
  end
end
