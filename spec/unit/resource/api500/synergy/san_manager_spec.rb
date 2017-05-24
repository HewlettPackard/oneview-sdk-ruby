require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::SANManager do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::SANManager' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::SANManager
  end
end
