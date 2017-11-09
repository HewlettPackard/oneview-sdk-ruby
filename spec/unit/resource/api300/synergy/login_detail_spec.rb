require 'spec_helper'

RSpec.describe OneviewSDK::API300::Synergy::LoginDetail do
  include_context 'shared context'

  it 'inherits from API200' do
    expect(described_class).to be < OneviewSDK::API200::LoginDetail
  end
end
