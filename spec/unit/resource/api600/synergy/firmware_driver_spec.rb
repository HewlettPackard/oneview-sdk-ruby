require 'spec_helper'

RSpec.describe OneviewSDK::API500::Synergy::FirmwareDriver do
  include_context 'shared context'

  it 'inherits from OneviewSDK::API300::Synergy::FirmwareDriver' do
    expect(described_class).to be < OneviewSDK::API300::Synergy::FirmwareDriver
  end
end
