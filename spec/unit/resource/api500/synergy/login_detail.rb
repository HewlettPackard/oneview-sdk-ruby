require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::LoginDetail do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::LoginDetail' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::LoginDetail
  end
end
