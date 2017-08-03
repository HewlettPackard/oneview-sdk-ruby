require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::FCNetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::FCNetwork' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::FCNetwork
  end
end
