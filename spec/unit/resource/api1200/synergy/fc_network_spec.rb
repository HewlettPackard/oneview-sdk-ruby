require 'spec_helper'

RSpec.describe OneviewSDK::API1200::Synergy::FCNetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1000::Synergy::FCNetwork' do
    expect(described_class).to be < OneviewSDK::API1000::Synergy::FCNetwork
  end
end
