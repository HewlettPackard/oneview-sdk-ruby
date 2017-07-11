require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::IDPool do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API200::IDPool' do
    expect(described_class).to be < OneviewSDK::API200::IDPool
  end
end
