require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::IDPool do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::IDPool' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::IDPool
  end
end
