require 'spec_helper'

RSpec.describe OneviewSDK::API1600::Synergy::EthernetNetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1200::Synergy::EthernetNetwork' do
    expect(described_class).to be < OneviewSDK::API1200::Synergy::EthernetNetwork
  end
end
