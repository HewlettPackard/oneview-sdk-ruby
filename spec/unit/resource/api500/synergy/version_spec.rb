require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::Version do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::Version' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::Version
  end
end
