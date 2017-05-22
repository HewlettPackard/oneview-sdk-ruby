require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::LIGUplinkSet do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::LIGUplinkSet' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::LIGUplinkSet
  end
end
