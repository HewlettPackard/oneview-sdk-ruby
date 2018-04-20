require 'spec_helper'

RSpec.describe OneviewSDK::API600::Synergy::ServerHardwareType do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API500::Synergy::ServerHardwareType' do
    expect(described_class).to be < OneviewSDK::API500::Synergy::ServerHardwareType
  end
end
