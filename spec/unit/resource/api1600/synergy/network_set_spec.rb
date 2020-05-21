require 'spec_helper'

RSpec.describe OneviewSDK::API1600::Synergy::NetworkSet do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1200::C7000::NetworkSet' do
    expect(described_class).to be < OneviewSDK::API1200::C7000::NetworkSet
  end
end
