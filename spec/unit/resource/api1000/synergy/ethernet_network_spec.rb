require 'spec_helper'

RSpec.describe OneviewSDK::API1000::Synergy::EthernetNetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API800::Synergy::EthernetNetwork' do
    expect(described_class).to be < OneviewSDK::API800::Synergy::EthernetNetwork
  end
end
