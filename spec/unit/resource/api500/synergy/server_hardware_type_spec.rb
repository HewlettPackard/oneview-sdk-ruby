require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::ServerHardwareType do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::ServerHardwareType' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::ServerHardwareType
  end
end
