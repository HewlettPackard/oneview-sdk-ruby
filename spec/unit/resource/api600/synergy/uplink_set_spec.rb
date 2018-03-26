require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::UplinkSet do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::Synergy::UplinkSet' do
    expect(described_class).to be < OneviewSDK::API500::Synergy::UplinkSet
  end
end
