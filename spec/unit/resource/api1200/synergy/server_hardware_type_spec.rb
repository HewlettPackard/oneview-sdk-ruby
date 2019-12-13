require 'spec_helper'

RSpec.describe OneviewSDK::API1200::Synergy::ServerHardwareType do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API1200::C7000::ServerHardwareType' do
    expect(described_class).to be < OneviewSDK::API1200::C7000::ServerHardwareType
  end
end
