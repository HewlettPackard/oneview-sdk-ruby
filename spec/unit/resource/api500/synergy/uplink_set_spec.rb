require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::UplinkSet do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::UplinkSet' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::UplinkSet
  end
end
