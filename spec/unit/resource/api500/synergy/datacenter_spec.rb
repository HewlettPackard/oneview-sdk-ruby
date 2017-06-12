require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::Datacenter do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::Datacenter' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::Datacenter
  end
end
