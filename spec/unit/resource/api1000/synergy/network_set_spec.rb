require 'spec_helper'

RSpec.describe OneviewSDK::API1000::Synergy::NetworkSet do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API800::C7000::NetworkSet' do
    expect(described_class).to be < OneviewSDK::API800::C7000::NetworkSet
  end
end
