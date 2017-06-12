require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::InternalLinkSet do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::InternalLinkSet' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::InternalLinkSet
  end
end
