require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::User do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::User' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::User
  end
end
