require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::EthernetNetwork do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::EthernetNetwork' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::EthernetNetwork
  end
end
