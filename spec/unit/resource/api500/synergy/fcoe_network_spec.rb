require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::FCoENetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::FCoENetwork' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::FCoENetwork
  end
end
