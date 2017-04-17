require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::NetworkSet do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::NetworkSet' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::NetworkSet
  end
end
